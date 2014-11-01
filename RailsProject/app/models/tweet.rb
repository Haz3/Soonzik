class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :msg, :user, presence: true
  validates :msg, length: { is: 140 }
end
