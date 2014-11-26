# The model of the object Gift
# Contain the relation and the validation
# Can provide some features linked to this model
class Gift < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: 'to_user'
  belongs_to :user_to, class_name: 'User', foreign_key: 'from_user'

  validates :user_from, :user_to, :typeObj, :obj_id, presence: true
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
end
