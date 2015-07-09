module Artist
  # Controller which manage meet page of the artist panel
  #
  class MeetsController < ArtistsController
  	before_action :setMenu

  	# For the menu bar
  	def setMenu
  		@menu = 'meet'
  	end

		# The index page for the search engine
  	def index
  		language = current_user.language
  		@meet = Meet.new
  		@professionsArray = Meetstring.where(language: language).where(stringtype: 'profession')
  		@typesArray = Meetstring.where(language: language).where(stringtype: 'type')

  		@professionsArray = Meetstring.where(language: 'EN').where(stringtype: 'profession') if @professionsArray.length == 0
  		@typesArray = Meetstring.where(language: 'EN').where(stringtype: 'type') if @typesArray.length == 0
  	end

  	def save
  		if request.post? && params[:meet]
  			obj = Meet.new(Meet.meet_params params)
  			obj.user_id = current_user.id
  			puts params[:meet][:location]
  			puts obj
  			puts obj.inspect
	      if obj.save
	        redirect_to artist_meet_path, notice: 'Your meeting query was successfully created.'
	      else
	        redirect_to artist_meet_path(obj), notice: 'An error occured.'
	      end
	    end
  	end

  	def show
  		@meets = Meet.all
  		puts @meets
  	end
  end
end