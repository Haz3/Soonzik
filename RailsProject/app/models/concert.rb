# The model of the object Concert
# Contain the relation and the validation
# Can provide some features linked to this model
class Concert < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  validates :user, :address, :planification, presence: true
  validates :planification, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  # Filter of information for the API
  def self.miniKey
  	[:id, :planification, :url]
  end

  # The strong parameters to save or update object
  def self.concert_params(parameters)
    parameters.require(:concert).permit(:user_id, :planification, :address_id, :url)
  end
end
