class Listening < ActiveRecord::Base
  belongs_to :music
  belongs_to :user

  validates :user, :music, :when, :latitude, :longitude, presence: true
  validates :when, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
  validates :latitude, :longitude, numericality: true
end
