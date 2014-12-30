# The model of the object Proposition
# Contain the relation and the validation
# Can provide some features linked to this model
class Proposition < ActiveRecord::Base
  belongs_to :user, foreign_key: 'artist_id'
  belongs_to :album

  validates :user, :album, :state, presence: true

  # The strong parameters to save or update object
  def self.proposition_params(parameters)
    parameters.require(:proposition).permit(:artist_id, :album_id, :state, :date_posted)
  end
end
