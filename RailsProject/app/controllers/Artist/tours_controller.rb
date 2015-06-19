module Artist
  # Controller which manage main page of the artist panel
  #
  class ToursController < ArtistsController

  	# The index page for the tour management
  	def index
  		@concerts = Concert.where(user_id: @current_user.id)
  		@menu = 'tour'
  	end

  	###############
  	# AJAX ROUTES #
  	###############

  	def create_concert
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {
		  		c = Concert.new(Concert.concert_params params)
		  		a = Address.new(Address.address_params params)

		  		if (a.save)
		  			c.address_id = a.id
		  			c.user_id = current_user.id
		  			if (c.save)
		  				render :json => c.as_json(:include => {
	  						address: {}
	  					})
		  			else
		  				a.delete
			  			render :json => { concert: c.errors }, :status => :bad_request
		  			end
		  		else
		  			render :json => { address: a.errors }, :status => :bad_request
		  		end
		  	}
		  end
  	end
  end
end