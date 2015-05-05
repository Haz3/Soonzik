class PlaylistsController < ApplicationController
	def index
		if user_signed_in?
			@playlist.find_by_user_id(current_user.id)
		else
			respond_to do |format|
        format.html { redirect_to root_path, notice: 'You can\'t access to this page without being logged' }
        format.json { head :no_content }
      end
    end
		end
	end

	def show
	end
	
end
