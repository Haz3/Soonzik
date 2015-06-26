module Artist
  # Controller which manage main page of the artist panel
  #
  class MusicsController < ArtistsController
  	before_action :setMenu

  	# For the menu bar
  	def setMenu
  		@menu = 'music'
  	end

		# The index page for the music management
  	def index
  	end

  	##########
  	#  AJAX  #
  	##########
  	def uploadMusic
  		error = false
  		m = nil
  		http = :ok

  		begin
  			if (params.has_key?(:music))
					p = JSON.parse(params[:music])
  				if (!params.has_key?(:file) || !p.has_key?("title") || !p.has_key?("price") || !p.has_key?("limited"))
	  				error = "Parameters missing"
					else
						p = {
							title: p["title"],
							price: p["price"],
							limited: p["limited"]
						}	  				
	  			end
	  		else
	  			error = "Parameters missing"
	  		end

	      if error == false && params[:file].content_type == "audio/mp3"
	        randomNumber = rand(1000..10000)
	        timestamp = Time.now.to_i
	        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.gsub(/[^0-9A-Za-z\.-]/, '')

	        #check si le dossier existe
	        if (!Dir.exists? Rails.root.join('app', 'assets', 'musics', current_user.id.to_s))
	        	Dir.mkdir Rails.root.join('app', 'assets', 'musics', current_user.id.to_s).to_s
	        end

	        File.open(Rails.root.join('app', 'assets', 'musics', current_user.id.to_s, newFilename), 'wb') do |f|
	          f.write(params[:file].tempfile.read)
	        end

	        # new music object
	        parameters = ActionController::Parameters.new({ music: p })
	        m = Music.new(Music.music_params parameters)
	        m.file = newFilename
	        m.user_id = current_user.id
	        m.duration = 99 #To determine with a gem
	        if (m.save)
		        http = :created
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'musics', current_user.id.to_s, newFilename).to_s
		        http = :bad_request
		      end

	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
		  rescue
		  	error = true
		  end

  		render :json => { error: error, music: m }, :status => http
  	end
	end
end