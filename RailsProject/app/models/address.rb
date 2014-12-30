# The model of the object Address
# Contain the relation and the validation
# Can provide some features linked to this model
class Address < ActiveRecord::Base
  has_many :users
  has_many :concerts

  validates :numberStreet, :street, :city, :country, :zipcode, presence: true

  # The strong parameters to save or update object
  def self.address_params(parameters)
    parameters.require(:address).permit(:numberStreet, :street, :city, :country, :zipcode)
  end
end
