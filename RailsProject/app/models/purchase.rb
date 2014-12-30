# The model of the object Purchase
# Contain the relation and the validation
# Can provide some features linked to this model
class Purchase < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :date, presence: true
  validates :date, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :obj_id, numericality: { only_integer: true }
  validate :objectValidation

  # A validate rules to check if an object exists
  # The typeObj and obj_id need to be present to do the check and add the error
  def objectValidation
  	if typeObj != nil && !Object.const_defined?(typeObj)
  		errors.add(:typeObj, "Invalid object type")
  	elsif typeObj != nil && obj_id != nil && typeObj.constantize.find_by_id(obj_id) == nil
  		errors.add(:obj_id, "This object doesn't exist")
  	end
  end

  # The strong parameters to save or update object
  def self.purchase_params(parameters)
    parameters.require(:purchase).permit(:user_id, :typeObj, :obj_id, :date)
  end
end
