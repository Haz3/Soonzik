# The model of the object Message
# Contain the relation and the validation
# Can provide some features linked to this model
class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'dest_id'


  validates :sender, :receiver, :msg, :session, presence: true
  validates :msg, length: { minimum: 1 }

  # The strong parameters to save or update object
  def self.message_params(parameters)
    parameters.require(:message).permit(:msg, :user_id, :dest_id, :session)
  end

  # Filter of information for API
  def self.miniKey
  	[:id, :msg, :user_id, :dest_id]
  end
end
