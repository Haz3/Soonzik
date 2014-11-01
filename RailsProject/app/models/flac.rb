class Flac < ActiveRecord::Base
  belongs_to :music

  validates :music, :file, presence: true, uniqueness: true
end
