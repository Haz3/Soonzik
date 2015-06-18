# The model of the object Description
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +description+ - (string) - The description
# - +language+ - (string) - The language of the description
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :packs
# - +has_and_belongs_to_many+ - :genres
# - +has_and_belongs_to_many+ - :influences
#
class Description < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :influences

  validates :description, :language, presence: true

  # The strong parameters to save or update object
  def self.description_params(parameters)
    parameters.require(:description).permit(:description, :language)
  end

  # The information filtered for the API
  #
  # Fields returned : [:id, :description, :language]
  def self.miniKey
  	[:id, :description, :language]
  end
end
