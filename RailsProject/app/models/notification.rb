# The model of the object Notification
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +link+ - (string) - The link to see what about the notification is
# - +description+ - (string) - The text inside the notification
#
# ==== Associations
#
# - +belongs_to+ - :user
#
class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user, :link, :description, presence: true

  # The strong parameters to save or update object
  def self.notification_params(parameters)
    parameters.require(:notification).permit(:user_id, :link, :description)
  end
end
