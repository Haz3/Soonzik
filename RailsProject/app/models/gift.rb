class Gift < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: 'to_user'
  belongs_to :user_to, class_name: 'User', foreign_key: 'from_user'

  validates :user_from, :user_to, :typeObj, :obj_id, presence: true
  validate :objectValidation

  def objectValidation
  	if !Object.const_defined?(typeObj)
  		errors.add(:typeObj, "Invalid object type")
  	elsif typeObj.constantize.find_by_id(obj_id) != nil
  		errors.add(:obj_id, "This object doesn't exist")
  	end
  end
end
