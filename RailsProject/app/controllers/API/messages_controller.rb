module API
  # Controller which manage the transaction for the Messages objects
  # Here is the list of action available :
  #
  # * show        [get]
  # * save		  [post]
  # * find        [get]
  #
  class MessagesController < ApisecurityController
  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific message
    # 
    def show
      begin
      	if (@security)
	        msg = Message.find_by_id(@id)
	        if (!msg)
	          codeAnswer 502
	          return
	        end
	        @returnValue = { content: msg.as_json(:include => {
        														:sender => {},
        														:receiver => {}
        													}) }
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