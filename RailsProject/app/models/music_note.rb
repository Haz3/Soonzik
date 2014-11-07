# The model of the object MusicNote
# Contain the relation and the validation
# Can provide some features linked to this model
class MusicNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :music

  validates :music, :user, :value, presence: true
  validates :value, numericality: true
end
