# The model of the object Album
# Contain the relation and the validation
# Can provide some features linked to this model
class Album < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :commentaries
  has_many :album_notes
  has_many :propositions
  has_many :musics
  belongs_to :user

  validates :user, :title, :style, :price, :file, :yearProd, presence: true
  validates :file, uniqueness: true
  validates :yearProd, numericality: { only_integer: true }

  # The strong parameters to save or update object
  def self.album_params(parameters)
    parameters.require(:album).permit(:user_id, :title, :style, :price, :file, :yearProd)
  end
end
