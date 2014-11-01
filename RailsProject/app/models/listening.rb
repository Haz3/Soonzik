class Listening < ActiveRecord::Base
  belongs_to :music
  belongs_to :user

  validates :user, :music, :when, :latitude, :longitude, presence: true
  validates :when, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
  validates :latitude, :longitude, numericality: true
end
