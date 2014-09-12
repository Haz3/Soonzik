module API
  class ApisecurityController < ApiController
    def initialize
      @security = false
      @returnValue = {}
    end

    def provideKey
      if (defined?(@id))
        begin
          u = User.find_by_id(@id)
          @returnValue = JSON.generate({key: u.idAPI})
        rescue
        end
      end

      respond_to do |format|
        format.json { render :json => JSON.generate(@returnValue) }
      end
    end

    def checkKey
      if (defined?(@id_user) && defined?(@secureKey))
        begin
          u = User.find_by_id(@id_user)
          if (@secureKey == u.secureKey)
            @security = true
            u.regenerateKey
          end
        rescue
        end
      end
    end
  end
end