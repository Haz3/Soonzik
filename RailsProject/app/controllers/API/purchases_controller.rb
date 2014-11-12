module API
  # Controller which manage the transaction for the Purchase objects
  # Here is the list of action available :
  #
  # * save		    [post] - SECURE
  #
  class PurchasesController < ApisecurityController
    # Save a new object Purchase. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:purchase[user_id]+ - Id of the user who has the purchase
    # * +:purchase[typeObj]+ - Model name of the object to add to the purchase
    # * +:purchase[obj_id]+ - Id of the object
    # 
    def save
      begin
        if (@security)
          purchase = Purchase.new(@purchase)
          classObj = purchase.typeObj.constantize
          # check if the object exists
          if (classObj.find_by_id(purchase.obj_id) != nil && purchase.save)
            @returnValue = { content: purchase.as_json(:include => :user) }
            codeAnswer 201
          else
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