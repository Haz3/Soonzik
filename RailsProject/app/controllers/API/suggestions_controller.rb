module API
  # Controller which manage the transaction for the Suggestions objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  #
  class SuggestionsController < ApisecurityController
    before_action :checkKey, only: [:show]

  	# Give a list of music based on the purchases
    #
    # Route : /suggest
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of music
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find musics to suggest
    # - +503+ - Error from server
    # 
    def show
      begin
      	if (@security)
	        u = User.find_by_id(@user_id)

	        suggestion = Music.suggest(u)
          suggestArray = []

          suggestion.each { |music|
            suggestArray << JSON.parse(music.to_json(:only => Music.miniKey, :include => {
              album: { only: Album.miniKey }
            }))
          }

	        if (!suggestion)
	          codeAnswer 502
            defineHttp :not_found
	        else
  	        @returnValue = { content: suggestArray.as_json }
  	        codeAnswer 200
          end
  	    else
  	    	codeAnswer 500
         defineHttp :forbidden
  	    end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end