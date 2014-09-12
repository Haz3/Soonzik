class Commentary < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :news
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :albums
end
