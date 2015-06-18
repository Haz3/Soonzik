# The model of the object Concert
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +planification+ - (date) - The date of the event
# - +url+ - (string) - (Facultative) The url of the event (for example)
# - +user_id+ - (integer) - ID of the artist
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :news
#
class Concert < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  validates :user, :address, :planification, presence: true
  validates :planification, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  # Filter of information for the API
  #
  # Fields returned : [:id, :planification, :url]
  def self.miniKey
  	[:id, :planification, :url]
  end

  # The strong parameters to save or update object
  def self.concert_params(parameters)
    parameters.require(:concert).permit(:user_id, :planification, :address_id, :url)
  end
end
