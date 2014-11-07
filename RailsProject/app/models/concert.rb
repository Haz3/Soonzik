# The model of the object Concert
# Contain the relation and the validation
# Can provide some features linked to this model
class Concert < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  validates :user, :address, :planification, presence: true
  validates :planification, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
end
