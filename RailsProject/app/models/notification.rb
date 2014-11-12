# The model of the object Notification
# Contain the relation and the validation
# Can provide some features linked to this model
class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user, :link, :description, presence: true
end
