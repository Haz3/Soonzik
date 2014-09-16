module API
  class BattlesController < ApisecurityController
  	#index show find

  	# Retrieve all the battles
    def index
      begin
        @returnValue = { content: Battle.all.as_json(:include => {
        														:artist_one => {},
        														:artist_two => {},
        														:votes => {}
        													}) }
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
    # * +:id+ - The id of the specific battle
    # 
    def show
      begin
        battle = Battle.find_by_id(@id)
        if (!battle)
          codeAnswer 502
          return
        end
        @returnValue = { content: battle.as_json(:include => {
        														:artist_one => {},
        														:artist_two => {},
        														:votes => {}
        													}) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end