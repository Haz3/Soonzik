class MusicNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :music

  validates :music, :user, :value, presence: true
  validates :value, numericality: true
end
