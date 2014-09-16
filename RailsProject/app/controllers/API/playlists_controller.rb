module API
  class PlaylistsController < ApisecurityController
  	#show save |save (update)| find destroy

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
          return
        end
        @returnValue = { content: playlist.as_json(:include => {
        														:musics => {},
        														:user => {}
        														}) }
        codeAnswer 200
      rescue
        codeAnswer 504
      end
      sendJson
    end
  end
end