# The model of the object Purchase
# Contain the relation and the validation
# Can provide some features linked to this model
class Purchase < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :packs

  validates :user, presence: true

  # The strong parameters to save or update object
  def self.purchase_params(parameters)
    parameters.require(:purchase).permit(:user_id)
  end
end
