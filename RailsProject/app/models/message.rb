class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'dest_id'
end
