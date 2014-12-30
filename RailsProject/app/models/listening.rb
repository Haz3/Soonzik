# The model of the object Listening
# Contain the relation and the validation
# Can provide some features linked to this model
class Listening < ActiveRecord::Base
  belongs_to :music
  belongs_to :user

  validates :user, :music, :when, :latitude, :longitude, presence: true
  validates :when, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :latitude, :longitude, numericality: true

  # The strong parameters to save or update object
  def self.listening_params(parameters)
    parameters.require(:listening).permit(:user_id, :music_id, :when, :latitude, :longitude)
  end
end
