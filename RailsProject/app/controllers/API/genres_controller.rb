module API
  # Controller which manage the transaction for the Genres objects
  # Here is the list of action available :
  #
  # * index       [get]
  class GenresController < ApisecurityController

    # Retrieve all the genres
    def index
    	begin
        @returnValue = { content: Genre.all.as_json(:include => :influences) }
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

    # Retrieve a specific genre
    def show
    	begin
        genre = Genre.find_by_id(@id)
        if (!genre)
          codeAnswer 502
        else
          @returnValue = { content: genre.as_json(:include => {
                                      :influences => {},
                                      :musics => { only: Music.miniKey}
                                      }) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end