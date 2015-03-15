module API
  # Controller which manage the transaction for the Influences objects
  # Here is the list of action available :
  #
  # * index       [get]
  class InfluencesController < ApisecurityController

    # Retrieve all the influences
    def index
    	begin
        @returnValue = { content: Influences.all.as_json(:include => :genres) }
        if (@returnValue[:content].size == 0)
          codeAnswer 202
          defineHttp :no_content
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end