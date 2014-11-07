# The model of the object AlbumNote
# Contain the relation and the validation
# Can provide some features linked to this model
class AlbumNote < ActiveRecord::Base
  belongs_to :album
  belongs_to :user

  validates :album, :user, :value, presence: true
  validates :value, numericality: true
end
