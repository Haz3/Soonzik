class Album < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :commentaries
  has_many :album_notes
  has_many :propositions
  belongs_to :user
end
