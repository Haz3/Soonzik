class Cart < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :gift, presence: true
  validates :obj_id, numericality: { only_integer: true }
  validates :typeObj, if: "Object.const_defined?(typeObj)"
  validates :obj_id, if: "u && typeObj.constantize.find_by_id(obj_id) != nil"
end
