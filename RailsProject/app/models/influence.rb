# The model of the object Influence
# Contain the relation and the validation
# Can provide some features linked to this model
class Influence < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :genres

  validates :name, presence: true, format: /([A-Za-z]+)/, uniqueness: true

  # The strong parameters to save or update object
  def self.influence_params(parameters)
    parameters.require(:influence).permit(:name)
  end
end
