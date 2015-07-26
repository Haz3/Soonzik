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
      begin
        if (@security)
          purchases = { musics: [], albums: [], musicsFromAlbum: [] }
          cartToDelete = []

          carts = Cart.where(user_id: @user_id)

          if carts.length > 0
            p = Purchase.new
            p.user_id = @user_id
            p.save!
            carts.each { |c|
              cTd = { cart: c, musicToDelete: [], albumToDelete: [] }
              cartToDelete << cTd

              c.musics.each { |music|
                pm = PurchasedMusic.new
                pm.purchase_id = p.id
                pm.music_id = music.id
                pm.save!
                purchases[:musics] << pm
                cTd[:musicToDelete] << music
              }

              c.albums.each { |album|
                pa = PurchasedAlbum.new
                pa.album_id = album.id
                pa.save!
                purchases[:albums] << pa
                cTd[:albumToDelete] << album

                album.musics.each { |zik|
                  pm = PurchasedMusic.new
                  pm.purchase_id = p.id
                  pm.purchased_album_id = pa.id
                  pm.music_id = zik.id
                  pm.save!
                  purchases[:musicsFromAlbum] << pm
                }
              }
            }

            cartToDelete.each { |c|
              c[:musicToDelete].each { |music|
                c[:cart].musics.delete(music)
              }
              c[:albumToDelete].each { |album|
                c[:cart].albums.delete(album)
              }
              c[:cart].destroy
            }

            ret = { musics: [], albums: [] }

            purchases[:musics].each { |p|
              ret[:musics] << p.as_json(:include => {:music => { only: Music.miniKey } })
            }
            purchases[:albums].each { |p|
              ret[:albums] << p.as_json(:include => {:album => { only: Album.miniKey } })
            }

            @returnValue = { content: ret }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: nil }
            codeAnswer 202
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        purchases[:musics].each { |p|
          p.destroy
        }
        purchases[:albums].each { |p|
          p.destroy
        }
        purchases[:musicsFromAlbum].each { |p|
          p.destroy
        }
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
    
    # Buy the current cart and empty it
    # 
    # Route : /purchases/buycart
    #
    # ==== Options
    #
    # +pack_id+ - The id of the pack purchased
    # +amount+ - The donation
    # +artist+ - The percentage for the artist
    # +association+ - The percentage for the association
    # +website+ - The percentage for the website
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +404+ - The pack is not found
    # - +503+ - Error from server
    # 
    def buypack
      begin
        if (@security)
          cartToDelete = []
          p = Purchase.new
          p.user_id = @user_id
          p.save!

          pack = Pack.find_by_id(@pack_id)
          if (pack == nil)
            codeAnswer 502
            defineHttp :not_found
          end

          pp = PurchasedPack.new
          pp.
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
  end
end