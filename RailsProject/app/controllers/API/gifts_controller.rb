module API
  # Controller which manage the transaction for the Gift objects
  # Here is the list of action available :
  #
  # * save        [post] - SECURE
  #
  class GiftsController < ApisecurityController
    before_action :checkKey, only: [:save]


    # Save a new object Gift. For more information on the parameters, check at the model
    # 
    # Route : /gifts/save
    #
    # ==== Options
    # 
    # * +gift [to_user]+ - Id of the user who has the gift
    # * +gift [from_user]+ - Id of the user where the gift comes from
    # * +gift [typeObj]+ - Model name of the object to add to the gift -> "Music" | "Album" | "Pack"
    # * +gift [obj_id]+ - Id of the object
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the gift saved including its informations
    # - +301+ - It is not a secure transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security)
          raise ArgumentError, 'to_user missing' if (!defined?@gift[:to_user])
          raise ArgumentError, 'from_user missing' if (!defined?@gift[:from_user])
          raise ArgumentError, 'typeObj missing' if (!defined?@gift[:typeObj])
          raise ArgumentError, 'obj_id missing' if (!defined?@gift[:obj_id])

          gift = Gift.new
          gift.to_user = @gift[:to_user]
          gift.from_user = @gift[:from_user]
          classObj = @gift[:typeObj].constantize
          obj = classObj.find_by_id(@gift[:obj_id])
          # check if the object exists
          if (obj != nil)
            case @gift[:typeObj]
              when "Music"
                gift.musics << obj;
              when "Album"
                gift.albums << obj;
              when "Pack"
                gift.packs << obj;
            end

            if (gift.save)
              @returnValue = { content: gift.as_json(:include => {
  				                                    :user_from => { :only => User.miniKey },
  				                                    :user_to => { :only => User.miniKey },
                                              :musics => { :only => Music.miniKey},
                                              :albums => { :only => Album.miniKey },
                                              :packs => { :only => Pack.miniKey }
  				                                  }) }
              codeAnswer 201
              defineHttp :created
            else
              @returnValue = { content: gift.errors.to_hash.to_json }
              codeAnswer 503
              defineHttp :service_unavailable
            end
          else
            codeAnswer 503
            defineHttp :service_unavailable
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
  end
end