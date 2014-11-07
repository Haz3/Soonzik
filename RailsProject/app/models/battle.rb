# The model of the object Battle
# Contain the relation and the validation
# Can provide some features linked to this model
class Battle < ActiveRecord::Base
  belongs_to :artist_one, class_name: 'User', foreign_key: 'artist_one_id'
  belongs_to :artist_two, class_name: 'User', foreign_key: 'artist_two_id'
  has_many :votes

  validates :artist_one, :artist_two, :date_begin, :date_end, presence: true
  validates :date_begin, :date_end, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
end
