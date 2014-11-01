class Concert < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  validates :user, :address, :planification, presence: true
  validates :planification, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
end
