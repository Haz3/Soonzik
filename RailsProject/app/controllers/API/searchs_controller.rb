module API
  # Controller which manage the search feature
  # There is only one 
  #
  # * search 	  [get]
  #
  class SearchsController < ApisecurityController
    # Search an element in our collection of content or for a specific object type
  	# 
  	# Route : /search
  	#
   	# ==== Options
   	# 
   	# * +offset+ - [Optionnal] Number where to begin the results (only with filter)
    # * +limit+ - [Optionnal] Number of result you want (only with filter)
    # * +query+ - [Optionnal] What the user type
    # * +type+ - [Optionnal] 
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an hash like this : { artist: array_of_artist, user: array_of_user, music: array_of_musics, album: array_of_albums, packs: array_of_packs }
    # - +503+ - Error from server
    # 
    def search
 	  	begin
	 	  	content = []
		    offset = 0
		    limit = nil
	    	offset = @offset if defined?@offset && @offset > 0
	    	limit = @limit if defined?@limit && @limit > 0
	    	if defined?@type
	    	  case @type
	    	    when "artist"
					  	content = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["'users'.'username' LIKE ?", "%#{@query}%"]).select("id, username, image, description, facebook, twitter, googlePlus")
				    when "user"
					  	content = User.joins(:groups).merge(Group.where(:name => "User")).where(["'users'.'username' LIKE ?", "%#{@query}%"]).select("id, username, image, description, facebook, twitter, googlePlus")
				    when "music"
					  	content = Music.where(["'musics'.'title' LIKE ?", "%#{@query}%"]).select(Music.miniKey)
				    when "album"
					  	content = Album.where(["'albums'.'title' LIKE ?", "%#{@query}%"]).select(Album.miniKey)
				    when "pack"
					  	content = Pack.where(["'packs'.'title' LIKE ?", "%#{@query}%"]).select(Pack.miniKey)
				  end
				  content = content.offset(offset)
				  if (limit != nil)
				  	content = content.limit(limit)
				  end
				  content = content.to_json
				else
				  artist_result = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["'users'.'username' LIKE ?", "%#{@query}%"])
				  user_result = User.joins(:groups).merge(Group.where(:name => "User")).where(["'users'.'username' LIKE ?", "%#{@query}%"])
				  music_result = Music.where(["'musics'.'title' LIKE ?", "%#{@query}%"])
				  album_result = Album.where(["'albums'.'title' LIKE ?", "%#{@query}%"])
				  pack_result = Pack.where(["'packs'.'title' LIKE ?", "%#{@query}%"])
				  if (artist_result.size == 0 && user_result.size == 0 && music_result.size == 0 && album_result.size == 0 && pack_result.size == 0)
				  	content = []
				  	codeAnswer 202
				  else
				    content = {
				    	artist: JSON.parse(artist_result.to_json(:only => User.miniKey )),
				    	user: JSON.parse(user_result.to_json(:only => User.miniKey )),
				    	music: JSON.parse(music_result.to_json(:only => Music.miniKey )),
				    	album: JSON.parse(album_result.to_json(:only => Album.miniKey )),
				    	pack: JSON.parse(pack_result.to_json(:only => Pack.miniKey ))
				    }
				  end
	    	end
    		@returnValue[:content] = content
        codeAnswer 200
	  	rescue
	    	codeAnswer 504
	    	defineHttp :service_unavailable
	  	end
	  	sendJson
    end
  end
end