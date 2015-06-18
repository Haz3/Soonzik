# The model of the object AlbumNote
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the artist who own the album
# - +album_id+ - (integer) - The ID of the album
# - +value+ - (integer) - The value given to the album
#
# ==== Associations
#
# - +belongs_to+ - :album
# - +belongs_to+ - :user
#
class AlbumNote < ActiveRecord::Base
  belongs_to :album
  belongs_to :user

  validates :album, :user, :value, presence: true
  validates :value, numericality: true

  # The strong parameters to save or update object
  def self.album_note_params(parameters)
    parameters.require(:album_note).permit(:user_id, :album_id, :value)
  end
end
