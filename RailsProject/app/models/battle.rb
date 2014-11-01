class Battle < ActiveRecord::Base
  belongs_to :artist_one, class_name: 'User', foreign_key: 'artist_one_id'
  belongs_to :artist_two, class_name: 'User', foreign_key: 'artist_two_id'
  has_many :votes

  validates :artist_one, :artist_two, :date_begin, :date_end, presence: true
  validates :date_begin, :date_end, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
end
