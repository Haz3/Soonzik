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
    # - +200+ - In case of success, return an hash like this : { artist: array_of_artist, user: array_of_user, music: array_of_musics, album: array_of_albums, pack: array_of_packs }
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
					  	content = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["'users'.'username' LIKE ?", "%#{@query}%"]).select("'users'.'id', 'users'.'username', 'users'.'image', 'users'.'description', 'users'.'facebook', 'users'.'twitter', 'users'.'googlePlus'")
				    when "user"
					  	content = User.joins(:groups).merge(Group.where(:name => "User")).where(["'users'.'username' LIKE ?", "%#{@query}%"]).select("'users'.'id', 'users'.'username', 'users'.'image', 'users'.'description', 'users'.'facebook', 'users'.'twitter', 'users'.'googlePlus'")
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
				  content = JSON.parse(content.to_json)
				  case @type
	    	    when "artist"
					  	content = { artist: content }
				    when "user"
					  	content = { user: content }
				    when "music"
					  	content = { music: content }
				    when "album"
					  	content = { album: content }
				    when "pack"
					  	content = { pack: content }
				  end
				else
				  artist_result = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["users.username LIKE ?", "%#{@query}%"])
				  user_result = User.joins(:groups).merge(Group.where(:name => "User")).where(["users.username LIKE ?", "%#{@query}%"])
				  music_result = Music.where(["musics.title LIKE ?", "%#{@query}%"]).where.not(album_id: nil)
				  album_result = Album.where(["albums.title LIKE ?", "%#{@query}%"])
				  pack_result = Pack.where(["packs.title LIKE ?", "%#{@query}%"])
				  if (artist_result.size == 0 && user_result.size == 0 && music_result.size == 0 && album_result.size == 0 && pack_result.size == 0)
				  	content = []
				  	codeAnswer 202
				  else
			  		artist_result = artist_result.offset(offset)
			  		user_result = user_result.offset(offset)
			  		music_result = music_result.offset(offset)
			  		album_result = album_result.offset(offset)
			  		pack_result = pack_result.offset(offset)
				  	if limit != nil
				  		artist_result = artist_result.limit(limit)
				  		user_result = user_result.limit(limit)
				  		music_result = music_result.limit(limit)
				  		album_result = album_result.limit(limit)
				  		pack_result = pack_result.limit(limit)
				  	end
				    content = {
				    	artist: JSON.parse(artist_result.to_json(:only => User.miniKey )),
				    	user: JSON.parse(user_result.to_json(:only => User.miniKey )),
				    	music: JSON.parse(music_result.to_json(:only => Music.miniKey, :include => { album: { only: Album.miniKey } } )),
				    	album: JSON.parse(album_result.to_json(:only => Album.miniKey, :include => { user: { only: User.miniKey } } ) )),
				    	pack: JSON.parse(pack_result.to_json(:only => Pack.miniKey, :include => { albums: { only: Album.miniKey } } ) ))
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