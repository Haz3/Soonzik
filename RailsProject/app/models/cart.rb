class Cart < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :gift, presence: true
  validates :obj_id, numericality: { only_integer: true }
end
