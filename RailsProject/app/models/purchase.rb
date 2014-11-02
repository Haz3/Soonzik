class Purchase < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :date, presence: true
  validates :date, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :obj_id, numericality: true
  validates :typeObj, if: "Object.const_defined?(typeObj)"
  validates :obj_id, if: "u && typeObj.constantize.find_by_id(obj_id) != nil"
end
