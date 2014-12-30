# The model of the object Pack
# Contain the relation and the validation
# Can provide some features linked to this model
class Pack < ActiveRecord::Base
  has_and_belongs_to_many :albums

  validates :title, :style, :albums, presence: true

  # The strong parameters to save or update object
  def self.pack_params(parameters)
    parameters.require(:pack).permit(:title, :style)
  end
end
