module API
  # Controller which manage the transaction for the Playlists objects
  # Here is the list of action available :
  #
  # * show        [get]
  # * find        [get]
  # * save        [post] - SECURITY
  # * update      [post] - SECURITY
  # * destroy     [get] - SECURITY
  #
  class PlaylistsController < ApisecurityController
    before_action :checkKey, only: [:destroy, :save, :update]

  	# Give a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific playlist
    # 
    def show
      begin
        playlist = Playlist.find_by_id(@id)
        if (!playlist)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: playlist.as_json(:include => {
          														:musics => { :only => Music.miniKey }
          														}) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object Playlist. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:playlist [user_id]+ - Id of the user who has the playlist
    # * +:playlist [name]+ - Name of the playlist
    # 
    def save
      begin
        if (@security)
          playlist = Playlist.new(Playlist.playlist_params params)
          if (playlist.save)
            @returnValue = { content: playlist.as_json() }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: playlist.errors.to_hash.to_json }
            codeAnswer 503
            defineHttp :service_unavailable
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

    # Save a new object Playlist. For more information on the parameters, check at the model
    # 
    # ==== Options
    # 
    # * +:id+ - Id of the playlist to modify
    # * +:playlist [name]+ - Name of the playlist
    # * +:playlist [music][]+ - Array of the id of the music in the playlist
    # 
    def update
      begin
        if (@security)
          playlist = Playlist.find_by_id(@id)
          if (playlist != nil)
            if (defined?(@playlist) && @playlist.has_key?(:music) && @playlist[:music].size > 0)
              playlist.musics = []
              @playlist[:music].each do |music_id|
                music = Music.find_by_id(music_id)
                playlist.musics << music if (music != nil)
              end
            end
            playlist.name = @playlist[:name] if defined?@playlist && @playlist.has_key?(:name)
            if (playlist.save)
              @returnValue = { content: playlist.as_json(:include => {
                                      :musics => {:only => Music.miniKey},
                                      :user => {:only => User.miniKey}
                                      }) }
              codeAnswer 201
              defineHttp :created
            else
              codeAnswer 505
              defineHttp :service_unavailable
            end
          else
            codeAnswer 505
            defineHttp :service_unavailable
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

    # Give a part of the playlist depending of the filter passed into parameter
    #
    # ==== Options
    # 
    # * +:attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +:order_by_asc[]+ - If you want to order by ascending by values
    # * +:order_by_desc[]+ - If you want to order by descending by values
    # * +:group_by[]+ - If you want to group by field
    # * +:limit+ - The number of row you want
    # * +:offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/playlists/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    def find
      begin
        playlist_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'playlists'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (playlist_object == nil)          #playlist_object doesn't exist
              playlist_object = Playlist.where(condition)
            else                              #playlist_object exists
              playlist_object = playlist_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          playlist_object = Playlist.all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += (%Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += (%Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          playlist_object = playlist_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          playlist_object = playlist_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          playlist_object = playlist_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          playlist_object = playlist_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          playlist_object = playlist_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          playlist_object = playlist_object.offset(@offset.to_i)
        end

        @returnValue = { content: playlist_object.as_json(:include => {
                                      :musics => {:only => Music.miniKey},
                                      :user => {:only => User.miniKey}
                                    }) }

        if (playlist_object.size == 0)
          codeAnswer 202
          defineHttp :no_content
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Destroy a specific object by its id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific playlist
    # 
    def destroy
      begin
        if (@security)
          object = Playlist.find_by_id(@id);
          object.destroy
          codeAnswer 202
          defineHttp :no_content
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