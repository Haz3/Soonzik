class Battle < ActiveRecord::Base
  belongs_to :artist_one, class_name: 'User', foreign_key: 'artist_one_id'
  belongs_to :artist_two, class_name: 'User', foreign_key: 'artist_two_id'
  has_many :votes
end
