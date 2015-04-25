# The model of the object Pack
# Contain the relation and the validation
# Can provide some features linked to this model
class Pack < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :genres

  has_many :purchased_packs

  validates :title, :albums, presence: true

  # The strong parameters to save or update object
  def self.pack_params(parameters)
    parameters.require(:pack).permit(:title)
  end

  def self.miniKey
  	[:id, :title]
  end
end
