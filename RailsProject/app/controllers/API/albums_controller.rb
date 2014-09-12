module API
  class AlbumsController < ApisecurityController
  	before_action :checkKey, only: [:addcomment]

    # Retrieve all the albums
    #
    # ==== Attributes
    #
    # ==== Options
    #
    # ==== Examples
    #
    def index
      respond_to do |format|
        format.json { render :json => JSON.generate(["mdr"]) }
      end
    end

  	def addcomment
      if (@security)
        @returnValue = ["lul"]
      end

      respond_to do |format|
        format.json { render :json => JSON.generate(@returnValue) }
      end
  	end

  	#index, show, find, addcomment
  end
end