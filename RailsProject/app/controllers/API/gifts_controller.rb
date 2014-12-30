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
    # ==== Options
    # 
    # * +:gift[to_user]+ - Id of the user who has the gift
    # * +:gift[from_user]+ - Id of the user where the gift comes from
    # * +:gift[typeObj]+ - Model name of the object to add to the gift
    # * +:gift[obj_id]+ - Id of the object
    # 
    def save
      begin
        if (@security)
          gift = Gift.new(Gift.gift_params params)
          classObj = gift.typeObj.constantize
          # check if the object exists
          if (classObj.find_by_id(gift.obj_id) != nil && gift.save)
            @returnValue = { content: gift.as_json(:include => {
				                                    :user_from => {},
				                                    :user_to => {}
				                                  }) }
            codeAnswer 201
          else
            @returnValue = { content: gift.errors.to_hash.to_json }
            codeAnswer 503
          end
        else
          codeAnswer 500
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end