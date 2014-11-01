class Playlist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :musics

  validates :user, :musics, :name, presence: true
  validates :name, length: { minimum: 4, maximum: 20 }
end
