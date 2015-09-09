module API
  # Controller which manage the transaction for the Suggestions objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * showTwo     [get] - SECURE OR NOT !
  #
  class SuggestionsController < ApisecurityController
    before_action :checkKey, only: [:show, :showTwo]

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

    # Give a list of music based on the purchases
    #
    # Route : /suggestv2
    #
    # - +type+ - What do you want ? 'music' or 'artist' ?
    # - +limit+ - (optionnal) The limit of the list. Default : 30
    # - +offset+ - (optionnal) The offset of the list. Default : 0
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of music
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find musics to suggest
    # - +503+ - Error from server
    # 
    def showTwo
      u = nil
      result = []
      offset = (@offset.present?) ? @offset.to_i : 0
      limit = (@limit.present?) ? @limit.to_i : 30

      begin
        if (@security)
          u = User.find_by_id(@user_id)
        end

        if (@type.present? && @type == "artist")
          @returnValue = { content: User.suggestArtist(u, offset, limit) }
          codeAnswer 200
        elsif (@type.present? && @type == "music")

        else
          codeAnswer 504
          defineHttp :bad_request
        end

      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end