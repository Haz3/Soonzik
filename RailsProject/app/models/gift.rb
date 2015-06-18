# The model of the object Gift
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +to_user+ - (string) - The ID of the user who get the gift
# - +from_user+ - (string) - The ID of the user who give the gift
#
# ==== Associations
#
# - +belongs_to+ - :user_from [user object]
# - +belongs_to+ - :user_to [user object]
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :packs
#
class Gift < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: 'from_user'
  belongs_to :user_to, class_name: 'User', foreign_key: 'to_user'
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :packs

  validates :user_from, :user_to, presence: true

  # The strong parameters to save or update object
  def self.gift_params(parameters)
    parameters.require(:gift).permit(:to_user, :from_user)
  end
end
