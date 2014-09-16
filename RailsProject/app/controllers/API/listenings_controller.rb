module API
  class ListeningsController < ApisecurityController
  	#index show save find 

  	# Retrieve all the listenings
    def index
      begin
        @returnValue = { content: Listening.all.as_json(:include => :user) }
        if (@returnValue.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end

  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific listening
    # 
    def show
      begin
        listening = Listening.find_by_id(@id)
        if (!listening)
          codeAnswer 502
          return
        end
        @returnValue = { content: listening.as_json(:include => :user) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end