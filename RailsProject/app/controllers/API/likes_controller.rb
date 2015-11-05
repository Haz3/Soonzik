module API
  # Controller which manage the transaction for the Likes objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save       	[post] - SECURE
  # * destroy     [get] - SECURE
  #
  class LikesController < ApisecurityController
    before_action :checkKey, only: [:destroy, :save]

  	# Destroy a specific object by its id
    #
    # Route : /likes/destroy
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific like
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, there is nothing to return
    # - +401+ - It is not a secured transaction
    # - +404+ - The like was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
      	if (@security)
      	  object = Like.find_by_id(@id)
          if (!object)
            codeAnswer 502
            defineHttp :not_found
            sendJson and return
          end
          if (object.user_id != @user_id.to_i)
            codeAnswer 500
            defineHttp :forbidden
            sendJson and return
          end
      	  object.destroy
      	  codeAnswer 202
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

    # Save a new object like. For more information on the parameters, check at the model
    # 
    # Route : /likes/save
    #
    # ==== Options
    # 
    # * +like [user_id]+ - Id of the user who has the like
    # * +like [typeObj]+ - Model name of the object to add to the like -> "News" | "Albums" | "Concerts"
    # * +like [obj_id]+ - ID of the object linked to the like
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new item
    # - +403+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @like[:user_id] == @user_id && ["News", "Albums", "Concerts"].include?(@like[:typeObj]))
          obj = nil
          objLiked = nil
          classType = nil

          case @like[:typeObj]
          when "Albums"
            obj = Albumslike.new
            objLiked = Album.find_by_id(@like[:obj_id])
            obj.album_id = @like[:obj_id]
          when "Concerts"
            obj = Concertslike.new
            objLiked = Concert.find_by_id(@like[:obj_id])
            obj.concert_id = @like[:obj_id]
          when "News"
            obj = Newslike.new
            objLiked = News.find_by_id(@like[:obj_id])
            obj.news_id = @like[:obj_id]
          end
          obj.user_id = @user_id
          obj.save

          if (objLiked == nil)
            codeAnswer 502
            defineHttp :not_found
          else
            codeAnswer 201
            defineHttp :created
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
  end
end