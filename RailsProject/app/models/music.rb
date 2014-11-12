# The model of the object Music
# Contain the relation and the validation
# Can provide some features linked to this model
class Music < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  has_one :flac
  has_many :listening
  has_many :music_notes
  has_and_belongs_to_many :commentaries
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :playlists

  validates :album, :user, :title, :duration, :style, :price, :file, :limited, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }
  validates :price, :duration, numericality: true
  validates :file, uniqueness: true
end
