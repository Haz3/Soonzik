class Cart < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :gift, presence: true
  validates :obj_id, numericality: { only_integer: true }
  validate :objectValidation

  def objectValidation
  	if !Object.const_defined?(typeObj)
  		errors.add(:typeObj, "Invalid object type")
  	elsif typeObj.constantize.find_by_id(obj_id) != nil
  		errors.add(:obj_id, "This object doesn't exist")
  	end
  end
end
