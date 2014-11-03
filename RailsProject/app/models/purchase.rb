class Purchase < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :date, presence: true
  validates :date, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :obj_id, numericality: true
  validate :objectValidation

  def objectValidation
  	if !Object.const_defined?(typeObj)
  		errors.add(:typeObj, "Invalid object type")
  	elsif typeObj.constantize.find_by_id(obj_id) != nil
  		errors.add(:obj_id, "This object doesn't exist")
  	end
  end
end
