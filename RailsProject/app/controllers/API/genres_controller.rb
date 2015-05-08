module API
  # Controller which manage the transaction for the Genres objects
  # Here is the list of action available :
  #
  # * index       [get]
  class GenresController < ApisecurityController

    # Retrieve all the genres
    #
    # Route : /genres
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of genres including its influences
    # - +503+ - Error from server
    # 
    def index
    	begin
        @returnValue = { content: Genre.all.as_json(:include => {
                                                        :influences => { :only => Influence.miniKey }
                                                    }, :only => Genre.miniKey) }
        if (@returnValue[:content].size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Retrieve a specific genre
    #
    # Route : /genres/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the genre selected
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a genre including its influences and musics
    # - +404+ - Can't get the genre, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
    	begin
        genre = Genre.find_by_id(@id)
        if (!genre)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: genre.as_json(:include => {
                                      :influences => { :only => Influence.miniKey },
                                      :musics => { only: Music.miniKey}
                                      }, :only => Genre.miniKey) }
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