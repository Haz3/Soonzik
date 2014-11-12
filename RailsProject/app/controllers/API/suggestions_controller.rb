module API
  # Controller which manage the transaction for the Suggestions objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  #
  class SuggestionsController < ApisecurityController
  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific suggestion
    # 
    def show
      begin
      	if (@security)
	        u = User.find_by_id(@id)

	        # algo de création de la suggestion

	        suggestion = {}

	        if (!suggestion)
	          codeAnswer 502
	        else
  	        @returnValue = { content: suggestion.as_json }
  	        codeAnswer 200
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