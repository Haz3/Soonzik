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
  end
end