module API
  # Controller which manage the transaction for the ambiances objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  #
  class AmbiancesController < ApisecurityController
    #
    # Retrieve all the ambiances
    #
    # Route : /ambiances
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of ambiance including its music and the artist
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Ambiance.count }
        else
          @returnValue = { content: Ambiance.eager_load([:musics]).all.as_json(:only => Ambiance.miniKey, :include => {
            musics: { 
              only: Music.miniKey
            }
          }) }
        end
        if (@returnValue[:content].size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        puts $!, $@
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a specific object by its id
    #
    # Route : /ambiances/:id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific ambiance
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the ambiance including its music and the artist
    # - +404+ - Can't get the ambiance, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        ambiance = Ambiance.find_by_id(@id)
        if (!ambiance)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: ambiance.as_json(:only => Ambiance.miniKey) }
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