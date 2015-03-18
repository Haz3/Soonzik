# The model of the object Cart
# Contain the relation and the validation
# Can provide some features linked to this model
class Cart < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :packs

  validates :user, :gift, presence: true

  # The strong parameters to save or update object
  def self.cart_params(parameters)
    parameters.require(:cart).permit(:gift, :user_id)
  end
end
