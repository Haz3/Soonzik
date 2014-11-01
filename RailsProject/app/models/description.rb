class Description < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :influences

  validates :description, :language, presence: true
end
