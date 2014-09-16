module API
  class ConcertsController < ApisecurityController
  	#index show find

  	# Retrieve all the concerts
    def index
      begin
        @returnValue = { content: Concert.all.as_json(:include => :address) }
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
    # * +:id+ - The id of the specific concert
    # 
    def show
      begin
        concert = Concert.find_by_id(@id)
        if (!concert)
          codeAnswer 502
          return
        end
        @returnValue = { content: concert.as_json(:include => :address) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end