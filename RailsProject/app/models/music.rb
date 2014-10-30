class Music < ActiveRecord::Base
  belongs_to :album
  has_one :flac
  has_many :listening
  has_many :music_notes
  has_and_belongs_to_many :commentaries
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :playlists
end
