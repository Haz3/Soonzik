# The model of the object Flac
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +music_id+ - (integer) - The ID of the music
# - +file+ - (string) - The filename to find the file
#
# ==== Associations
#
# - +belongs_to+ - :music
#
class Flac < ActiveRecord::Base
  belongs_to :music

  validates :music, :file, presence: true, uniqueness: true

  # The strong parameters to save or update object
  def self.flac_params(parameters)
    parameters.require(:flac).permit(:music_id, :file)
  end
end
