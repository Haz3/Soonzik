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
    # - +paypal [:payment_id] + - The informations that paypal returns after a payment
    # - +paypal [:payment_method] + - The informations that paypal returns after a payment
    # - +paypal [:status] + - The informations that paypal returns after a payment
    # - +paypal [:payer_email] + - The informations that paypal returns after a payment
    # - +paypal [:payer_first_name] + - The informations that paypal returns after a payment
    # - +paypal [:payer_last_name] + - The informations that paypal returns after a payment
    # - +paypal [:payer_id] + - The informations that paypal returns after a payment
    # - +paypal [:payer_phone] + - The informations that paypal returns after a payment
    # - +paypal [:payer_country_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_street] + - The informations that paypal returns after a payment
    # - +paypal [:payer_city] + - The informations that paypal returns after a payment
    # - +paypal [:payer_postal_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_country_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_recipient_name] + - The informations that paypal returns after a payment
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def buycart
      ret = { musics: [], albums: [] }

      if (!(@paypal.present? && @paypal.has_key?(:payment_id) && @paypal.has_key?(:payment_method) && @paypal.has_key?(:status) && @paypal.has_key?(:payer_email)
          && @paypal.has_key?(:payer_first_name) && @paypal.has_key?(:payer_last_name) && @paypal.has_key?(:payer_id) && @paypal.has_key?(:payer_phone) && @paypal.has_key?(:payer_country_code)
          && @paypal.has_key?(:payer_street) && @paypal.has_key?(:payer_city) && @paypal.has_key?(:payer_postal_code) && @paypal.has_key?(:payer_country_code) && @paypal.has_key?(:payer_recipient_name)))
        codeAnswer 503
        defineHttp :bad_request
      else
        begin
          if (@security)
            p = Purchase.new
            p.user_id = @user_id
            p.save!

            cart = Cart.eager_load(albums: { musics: {} }).where(carts: { user_id: @user_id })
            list = p.buyCart(cart, false, true)
            PaypalPayment.create({
              payment_id: @paypal[:payment_id],
              payment_method: @paypal[:payment_method],
              status: @paypal[:status],
              payer_email: @paypal[:payer_email],
              payer_first_name: @paypal[:payer_first_name],
              payer_last_name: @paypal[:payer_last_name],
              payer_id: @paypal[:payer_id],
              payer_phone: @paypal[:payer_phone],
              payer_country_code: @paypal[:payer_country_code],
              payer_street: @paypal[:payer_street],
              payer_city: @paypal[:payer_city],
              payer_postal_code: @paypal[:payer_postal_code],
              payer_country_code: @paypal[:payer_country_code],
              payer_recipient_name: @paypal[:payer_recipient_name],
              purchase_id: p.id
            })
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
    # - +paypal [:payment_id] + - The informations that paypal returns after a payment
    # - +paypal [:payment_method] + - The informations that paypal returns after a payment
    # - +paypal [:status] + - The informations that paypal returns after a payment
    # - +paypal [:payer_email] + - The informations that paypal returns after a payment
    # - +paypal [:payer_first_name] + - The informations that paypal returns after a payment
    # - +paypal [:payer_last_name] + - The informations that paypal returns after a payment
    # - +paypal [:payer_id] + - The informations that paypal returns after a payment
    # - +paypal [:payer_phone] + - The informations that paypal returns after a payment
    # - +paypal [:payer_country_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_street] + - The informations that paypal returns after a payment
    # - +paypal [:payer_city] + - The informations that paypal returns after a payment
    # - +paypal [:payer_postal_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_country_code] + - The informations that paypal returns after a payment
    # - +paypal [:payer_recipient_name] + - The informations that paypal returns after a payment
    # 
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
      if (!(@paypal.present? && @paypal.has_key?(:payment_id) && @paypal.has_key?(:payment_method) && @paypal.has_key?(:status) && @paypal.has_key?(:payer_email)
          && @paypal.has_key?(:payer_first_name) && @paypal.has_key?(:payer_last_name) && @paypal.has_key?(:payer_id) && @paypal.has_key?(:payer_phone) && @paypal.has_key?(:payer_country_code)
          && @paypal.has_key?(:payer_street) && @paypal.has_key?(:payer_city) && @paypal.has_key?(:payer_postal_code) && @paypal.has_key?(:payer_country_code) && @paypal.has_key?(:payer_recipient_name)))
        codeAnswer 503
        defineHttp :bad_request
      else
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

              p.addPurchasedPackFromObject(pack, (pack.averagePrice > @amount.to_f), @artist, @association, @website, @amount)

              PaypalPayment.create({
                payment_id: @paypal[:payment_id],
                payment_method: @paypal[:payment_method],
                status: @paypal[:status],
                payer_email: @paypal[:payer_email],
                payer_first_name: @paypal[:payer_first_name],
                payer_last_name: @paypal[:payer_last_name],
                payer_id: @paypal[:payer_id],
                payer_phone: @paypal[:payer_phone],
                payer_country_code: @paypal[:payer_country_code],
                payer_street: @paypal[:payer_street],
                payer_city: @paypal[:payer_city],
                payer_postal_code: @paypal[:payer_postal_code],
                payer_country_code: @paypal[:payer_country_code],
                payer_recipient_name: @paypal[:payer_recipient_name],
                purchase_id: p.id
              })

              @returnValue = {
                content: pack.as_json(only: Pack.miniKey, :include => {
                  albums: {
                    only: Album.miniKey,
                    :include => {
                      musics: { only: Music.miniKey }
                    }
                  }
                })
              }
            end
          else
            codeAnswer 500
            defineHttp :forbidden
          end
        rescue
          p.destroy
          codeAnswer 504
          defineHttp :service_unavailable
        end
      end
      sendJson
    end
  end
end