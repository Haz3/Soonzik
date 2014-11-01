class AlbumNote < ActiveRecord::Base
  belongs_to :album
  belongs_to :user

  validates :album, :user, :value, presence: true
  validates :value, numericality: true
end
