# The model of the object Flac
# Contain the relation and the validation
# Can provide some features linked to this model
class Flac < ActiveRecord::Base
  belongs_to :music

  validates :music, :file, presence: true, uniqueness: true
end
