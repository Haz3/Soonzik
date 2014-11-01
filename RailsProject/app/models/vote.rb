class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :battle
  belongs_to :artist, class_name: 'User', foreign_key: 'artist_id'

  validates :user, :battle, :artist, presence: true
end
