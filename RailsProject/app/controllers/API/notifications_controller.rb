module API
  # Controller which manage the transaction for the Notifications objects
  # Here is the list of action available :
  #
  # * show        [get]
  # * save		  [post]
  # * find        [get]
  # * destroy     [get]
  #
  class NotificationsController < ApisecurityController
  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific notification
    # 
    def show
      begin
      	if (@security)
	        notif = Notification.find_by_id(@id)
	        if (!notif)
	          codeAnswer 502
	          return
	        end
	        @returnValue = { content: notif.as_json(:include => :user) }
	        codeAnswer 200
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