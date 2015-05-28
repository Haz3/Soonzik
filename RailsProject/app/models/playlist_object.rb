# The model of the object PlaylistMusic
# Contain the relation and the validation
# Can provide some features linked to this model
class PlaylistObject < ActiveRecord::Base
  include RankedModel

	ranks				:row_order,
							:with_same => :playlist_id
	belongs_to	:playlist

	has_and_belongs_to_many		:musics


  # The strong parameters to save or update object
  def self.playlist_params(parameters)
    parameters.require(:playlist_object).permit(:playlist_id, :music_id, :row_order)
  end
end