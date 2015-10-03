# The model of the object Access
# Contain the relation and the validation
# Can provide some features linked to this model
class Access < ActiveRecord::Base
  belongs_to :group

  validates :group, :controllerName, :actionName, presence: true
  validates :controllerName, :actionName, format: /([A-Za-z]+)/

  # The strong parameters to save or update object
  def self.access_params(parameters)
    parameters.require(:access).permit(:controllerName, :actionName)
  end
end