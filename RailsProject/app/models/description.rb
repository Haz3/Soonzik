# The model of the object Description
# Contain the relation and the validation
# Can provide some features linked to this model
class Description < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :influences

  validates :description, :language, presence: true

  # The strong parameters to save or update object
  def self.description_params(parameters)
    parameters.require(:description).permit(:description, :language)
  end
end
