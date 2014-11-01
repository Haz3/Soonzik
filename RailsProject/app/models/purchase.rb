class Purchase < ActiveRecord::Base
  belongs_to :user

  validates :user, :typeObj, :obj_id, :date, presence: true
  validates :date, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
  validates :obj_id, numericality: true
end
