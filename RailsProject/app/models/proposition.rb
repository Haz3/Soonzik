class Proposition < ActiveRecord::Base
  belongs_to :user, foreign_key: 'artist_id'
  belongs_to :album

  validates :user, :album, :state, presence: true
end
