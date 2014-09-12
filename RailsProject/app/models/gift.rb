class Gift < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User', foreign_key: 'to_user'
  belongs_to :user_to, class_name: 'User', foreign_key: 'from_user'
end
