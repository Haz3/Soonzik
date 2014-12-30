# The model of the object AlbumNote
# Contain the relation and the validation
# Can provide some features linked to this model
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
