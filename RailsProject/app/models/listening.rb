# The model of the object Listening
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +when+ - (date) - The name of the group
# - +latitude+ - (float) - The latitude of the position
# - +longitude+ - (float) - The longitude of the position
# - +music_id+ - (integer) - The ID of the music listened
# - +user_id+ - (integer) - The ID of the user who listen music
#
# ==== Associations
#
# - +belongs_to+ - :music
# - +belongs_to+ - :user
#
class Listening < ActiveRecord::Base
  belongs_to :music
  belongs_to :user

  validates :user, :music, :when, :latitude, :longitude, presence: true
  validates :when, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :latitude, :longitude, numericality: true

  # Filter of information for the API - Restricted
  #
  # Fields returned : [:id, :when, :latitude, :longitude]
  def self.miniKey
    [:id, :when, :latitude, :longitude]
  end

  # The strong parameters to save or update object
  def self.listening_params(parameters)
    parameters.require(:listening).permit(:user_id, :music_id, :when, :latitude, :longitude)
  end
end
