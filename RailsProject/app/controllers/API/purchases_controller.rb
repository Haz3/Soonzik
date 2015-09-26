module API
  # Controller which manage the transaction for the Purchase objects
  # Here is the list of action available :
  #
  # * buycart       [post] - SECURE
  # * buypack		    [post] - SECURE
  #
  class PurchasesController < ApisecurityController
    before_action :checkKey, only: [:buypack, :buycart]
    
    # Buy the current cart and empty it
    # 
    # Route : /purchases/buycart
    #
    # ==== Options
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def buycart
      ret = { musics: [], albums: [] }

      begin
        if (@security)
          p = Purchase.new
          p.user_id = @user_id
          p.save!

          cart = Cart.eager_load(albums: { musics: {} }).where(carts: { user_id: @user_id })
          list = p.buyCart(cart, false, true)
          if (list == false)
            p.destroy
            @returnValue = { content: nil }
            codeAnswer 202
          else
            list.each { |item|
              if (item.is_a?(Music))
                ret[:musics] << p.as_json(:include => {:album => { only: Album.miniKey } })
              else
                ret[:albums] << p.as_json(:include => {:musics => { only: Music.miniKey } })
              end
            }

            @returnValue = { content: ret }
            codeAnswer 201
            defineHttp :created
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
    
    # Buy the current cart and empty it
    # 
    # Route : /purchases/buypack
    #
    # ==== Options
    #
    # - +pack_id+ - The id of the pack purchased
    # - +amount+ - The donation
    # - +artist+ - The percentage for the artist
    # - +association+ - The percentage for the association
    # - +website+ - The percentage for the website
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +403+ - The sum of the percentage != 100
    # - +503+ - Error from server
    # 
    def buypack
      objectToDelete = []
      begin
        if (@security)
          pack = Pack.find_by_id(@pack_id)
          if (pack == nil)
            codeAnswer 502
            defineHttp :not_found
          elsif @artist.to_f + @association.to_f + @website.to_f != 100 || @amount.to_f < pack.minimal_price
            codeAnswer 504
            defineHttp :bad_request
          else
            p = Purchase.new
            p.user_id = @user_id
            p.save!

            objectToDelete.unshift p

            pp = PurchasedPack.new
            pp.pack_id = pack.id
            pp.partial = (pack.averagePrice > @amount.to_f)
            pp.artist_percentage = @artist
            pp.association_percentage = @association
            pp.website_percentage = @website
            pp.value = @amount
            pp.save!

            objectToDelete.unshift pp

            pack.albums.each do |album|
              album.setPack(@pack_id)
              if (!album.isPartial || (album.isPartial && @amount.to_f > pack.averagePrice))
                pa = PurchasedAlbum.new
                pa.album_id = album.id
                pa.purchased_pack_id = pp.id
                pa.save!
                objectToDelete.unshift pa

                album.musics.each { |zik|
                  pm = PurchasedMusic.new
                  pm.purchase_id = p.id
                  pm.purchased_album_id = pa.id
                  pm.music_id = zik.id
                  pm.save!
                  objectToDelete.unshift pm
                }
              end
            end

            @returnValue = {
              content: pp.as_json(except: [:updated_at], :include => {
                pack: {
                  only: Pack.miniKey
                }
              } )
            }
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        objectToDelete.each do |obj|
          obj.destroy
        end
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end