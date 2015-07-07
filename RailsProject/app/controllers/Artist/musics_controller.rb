module Artist
  # Controller which manage main page of the artist panel
  #
  class MusicsController < ArtistsController
  	before_action :setMenu
  	include ::Multimedia

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

  	# Route to upload a music (with genres)
  	def uploadMusic
  		error = false
  		m = nil
  		http = :ok
  		genres = []
  		newFilename = nil
  		hasWritten = false

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

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)

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
	        hasWritten = true

	        cutObject = Multimedia::CutAudio.new(Rails.root.join('app', 'assets', 'musics', current_user.id.to_s).to_s, newFilename)
	        
  				# new music object
	        parameters = ActionController::Parameters.new({ music: p })
	        m = Music.new(Music.music_params parameters)
	        m.file = newFilename
	        m.user_id = current_user.id
	        m.duration = cutObject.determine_duration
	        if (m.save)
		        http = :created
						cutObject.determineStart(0)
						cutObject.determineEnd(30)
						cutObject.cut
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.musics << m
								end
							rescue
							end
						}
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
		  	if hasWritten == true
					File.delete Rails.root.join('app', 'assets', 'musics', current_user.id.to_s, newFilename).to_s
		  	end
		  	m.delete if m.id != nil
		  	http = :bad_request
		  end

  		render :json => { error: error, music: m.as_json(:include => { genres: {} }) }, :status => http
  	end

  	# Route to update a music. Usefull to change album too
  	def updateMusic
  		m = nil
  		http = :ok

  		begin
	  		if (params.has_key?(:id) && params.has_key?(:music))
	  			m = Music.find_by_id(params[:id])
	  			if (m.user_id != current_user.id)
	  				http = :bad_request
	  			else
		  			u = false
		  			u = m.update(Music.music_params params) if m.user_id == current_user.id
		  			if (u == false)
		  				http = :bad_request
		  			elsif (params.has_key?(:genres))
		  				m.genres = []
		  				params[:genres].each { |genre|
								begin
									g = Genre.find_by_id(genre)
									if g != nil
										g.musics << m
									end
								rescue
								end
							}
							m.reload
		  			end
		  		end
	  		else
	  			http = :bad_request
	  		end
	  	rescue
	  		http = :bad_request
	  	end

  		render :json => { music: m.as_json(:include => { genres: {} }) }, :status => http
  	end

  	# Route to create an album
  	def uploadAlbum
  		error = false
  		a = nil
  		http = :ok
  		genres = []

  		begin
  			if (params.has_key?(:album))
					p = JSON.parse(params[:album])
  				if (!params.has_key?(:file) || !p.has_key?("title") || !p.has_key?("price") || !p.has_key?("yearProd"))
	  				error = "Parameters missing"
					else
						p = {
							title: p["title"],
							price: p["price"],
							yearProd: p["yearProd"]
						}	  				
	  			end
	  		else
	  			error = "Parameters missing"
	  		end

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)
				
				acceptedContentType = [
          "image/gif",
          "image/jpeg",
          "image/pjpeg",
          "image/png",
          "image/x-png"
        ]

				if error == false && acceptedContentType.include?(params[:file].content_type)
	        randomNumber = rand(1000..10000)
	        timestamp = Time.now.to_i
	        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.gsub(/[^0-9A-Za-z\.-]/, '')
  				
	        File.open(Rails.root.join('app', 'assets', 'images', 'albums', newFilename), 'wb') do |f|
	          f.write(params[:file].tempfile.read)
	        end

	        # new music object
	        parameters = ActionController::Parameters.new({ album: p })
	        a = Album.new(Album.album_params parameters)
	        a.image = newFilename
	        a.file = newFilename
	        a.user_id = current_user.id
	        if (a.save)
						http = :created
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.albums << a
								end
							rescue
							end
						}
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'images', 'albums', newFilename).to_s
		        http = :bad_request
		      end
	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
			rescue
		  	error = true
      	http = :bad_request
			end

  		render :json => { error: error, album: a.as_json(:include => { musics: {}, genres: {} } ) }, :status => http
  	end

  	# To update the album
  	# We can't change the file
  	def updateAlbum
  		error = false
  		a = nil
  		http = :ok
  		genres = []

  		begin
  			if (params.has_key?(:album) && params.has_key?(:id))
					p = JSON.parse(params[:album])
					p[:title] = p["title"] if p.has_key?("title")
					p[:price] = p["price"] if p.has_key?("price")
					p[:yearProd] = p["yearProd"] if p.has_key?("yearProd")
	  		else
	  			error = "Parameters missing"
	  		end

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)

				acceptedContentType = [
          "image/gif",
          "image/jpeg",
          "image/pjpeg",
          "image/png",
          "image/x-png"
        ]

        a = Album.find_by_id(params[:id])

        if a != nil && a.user_id == current_user.id && error == false && (!params.has_key?(:file) || (params.has_key?(:file) && acceptedContentType.include?(params[:file].content_type)))
        	oldFile = nil
        	newFilename = nil

        	if (params.has_key? :file)
		        randomNumber = rand(1000..10000)
		        timestamp = Time.now.to_i
		        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.gsub(/[^0-9A-Za-z\.-]/, '')
	  				
		        File.open(Rails.root.join('app', 'assets', 'images', 'albums', newFilename), 'wb') do |f|
		          f.write(params[:file].tempfile.read)
		        end

		        oldFile = a.image
		      end

	        # new music object
	        parameters = ActionController::Parameters.new({ album: p })
	        ret = a.update(Album.album_params parameters)
	        if (ret && newFilename != nil)
		        a.image = newFilename
		        a.file = newFilename
		        a.save!
		      end
	        if (ret)
	        	File.delete Rails.root.join('app', 'assets', 'images', 'albums', oldFile).to_s if oldFile != nil
						http = :created
						a.genres = []
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.albums << a
								end
							rescue
							end
						}
						a.reload
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'images', 'albums', newFilename).to_s
		        http = :bad_request
		      end
	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
			rescue
		  	error = true
      	http = :bad_request
			end
  		render :json => { error: error, album: a.as_json(:include => { musics: {}, genres: {} } ) }, :status => http
  	end
	end
end