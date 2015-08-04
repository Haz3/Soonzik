# The model of the object Cart
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user who own it
# - +gift_id+ - (integer) - Is it a gift or not
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +belongs_to+ - :gift
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :packs
#
class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics

  validates :user, presence: true

  # The strong parameters to save or update object
  def self.cart_params(parameters)
    parameters.require(:cart).permit(:gift_id, :user_id)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :created_at]
  def self.miniKey
    [:id, :created_at]
  end
end
