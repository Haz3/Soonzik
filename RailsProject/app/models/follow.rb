class Follow < ActiveRecord::Base 
  belongs_to :user, 
    :class_name => 'User', :foreign_key => 'user_id' 
  belongs_to :user_to, 
    :class_name => 'User', :foreign_key => 'follow_id' 
end 