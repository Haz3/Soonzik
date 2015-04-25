# The model of the object Playlist
# Contain the relation and the validation
# Can provide some features linked to this model
class Playlist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :musics

  validates :user, :name, presence: true
  validates :name, length: { minimum: 4, maximum: 20 }

  # The strong parameters to save or update object
  def self.playlist_params(parameters)
    parameters.require(:playlist).permit(:user_id, :name)
  end

  def self.miniKey
  	[:id, :name]
  end
end
