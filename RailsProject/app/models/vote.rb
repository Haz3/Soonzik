# The model of the object Vote
# Contain the relation and the validation
# Can provide some features linked to this model
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :battle
  belongs_to :artist, class_name: 'User', foreign_key: 'artist_id'

  validates :user, :battle, :artist, presence: true
end
