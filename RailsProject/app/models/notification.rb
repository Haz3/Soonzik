class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user, :link, :description, presence: true
end
