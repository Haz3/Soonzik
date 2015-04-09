module API
  # Controller which manage the transaction for the Purchase objects
  # Here is the list of action available :
  #
  # * save		    [post] - SECURE
  #
  class PurchasesController < ApisecurityController
    before_action :checkKey, only: [:save]
    
    # Save a new object Purchase. For more information on the parameters, check at the model
    # 
    # Route : /purchases/save
    #
    # ==== Options
    # 
    # * +purchase [user_id]+ - Id of the user who has the purchase
    # * +purchase [typeObj]+ - Model name of the object to add to the purchase -> "Music" | "Album" | "Pack"
    # * +purchase [obj_id]+ - Id of the object
    # * +purchase [partial]+ - Boolean IN CASE OF A PACK to know if the user has the entire pack or not
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security)
          raise ArgumentError, 'user_id missing' if (!defined?@purchase[:user_id])
          raise ArgumentError, 'typeObj missing' if (!defined?@purchase[:typeObj])
          raise ArgumentError, 'obj_id missing' if (!defined?@purchase[:obj_id])

          purchase = Purchase.new
          purchase.user_id = @purchase[:user_id]
          classObj = @purchase[:typeObj].constantize
          obj = classObj.find_by_id(@purchase[:obj_id])
          # check if the object exists
          if (purchase.save && obj != nil)
            begin
              case @purchase[:typeObj]
                when "Music"
                  purchase.addPurchasedMusicFromObject(obj);
                when "Album"
                  purchase.addPurchasedAlbumFromObject(obj);
                when "Pack"
                  purchase.addPurchasedPackFromObject(obj, @purchase[:partial]);
              end

              @returnValue = { content: purchase.as_json(:include => {
                                                                        :user => {:only => User.miniKey },
                                                                        :purchased_musics => {
                                                                          :include => {
                                                                            :music => { :only => Music.miniKey},
                                                                            :purchased_album => {
                                                                              :include => {
                                                                                :album => { :only => Album.miniKey },
                                                                                :purchased_pack => {
                                                                                  :include => {
                                                                                    :pack => { :only => Pack.miniKey }
                                                                                  }
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                     })}
              codeAnswer 201
              defineHttp :created
            rescue
              purchase.destroy
              codeAnswer 503
              defineHttp :service_unavailable
            end
          else
            @returnValue = { content: purchase.errors.to_hash.to_json }
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