module API
  # Controller which manage the search feature
  # There is only one 
  #
  # * search 	  [get]
  #
  class SearchsController < ApisecurityController
    # Search an element in our collection of content or for a specific object type
  	# 
   	# ==== Options
   	# 
   	# * +:offset+ - [Optionnal] Number where to begin the results (only with filter)
    # * +:limit+ - [Optionnal] Number of result you want (only with filter)
    # * +:type+ - [Optionnal] 
    # 
    def search
 	  	begin
	 	  	content = []
		    offset = 0
		    limit = nil
	    	offset = @offset if defined?@offset && @offset > 0
	    	limit = @limit if defined?@limit && @limit > 0
	    	puts defined?@type
	    	if defined?@type
	    	  case @type
	    	    when "artist"
					  content = User.joins(:groups).merge(Group.where(:name => "artist")).where(["'users'.'username' LIKE ?", "#{@query}"]).select("id, username, image, description, facebook, twitter, googlePlus")
				    when "user"
					  content = User.joins(:groups).merge(Group.where(:name => "user")).where(["'users'.'username' LIKE ?", "#{@query}"]).select("id, username, image, description, facebook, twitter, googlePlus")
				    when "music"
					  content = Music.where(["'musics'.'title' LIKE ?", "#{@query}"])
				    when "album"
					  content = Album.where(["'albums'.'title' LIKE ?", "#{@query}"])
				    when "pack"
					  content = Pack.where(["'packs'.'title' LIKE ?", "#{@query}"])
				  end
				  content = content.offset(offset)
				  if (limit != nil)
				  	content = content.limit(limit)
				  end
				  content = content.to_json
				else
				  artist_result = User.joins(:groups).merge(Group.where(:name => "artist")).where(["'users'.'username' LIKE ?", "#{@query}"])
				  user_result = User.joins(:groups).merge(Group.where(:name => "user")).where(["'users'.'username' LIKE ?", "#{@query}"])
				  music_result = Music.where(["'musics'.'title' LIKE ?", "#{@query}"])
				  album_result = Album.where(["'albums'.'title' LIKE ?", "#{@query}"])
				  pack_result = Pack.where(["'packs'.'title' LIKE ?", "#{@query}"])
				  if (artist_result.size == 0 && user_result.size == 0 && music_result.size == 0 && album_result.size == 0 && pack_result.size == 0)
				  	content = []
				  	codeAnswer 202
				  	defineHttp :no_content
				  else
				    content = { artist: artist_result.to_json(:only => User.miniKey ), user: user_result.to_json(:only => User.miniKey ), music: music_result.to_json(:only => Music.miniKey ), album: album_result.to_json(:only => Album.miniKey ), pack: pack_result.to_json(:only => Pack.miniKey ) }
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