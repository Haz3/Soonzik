# The model of the object Battle
# Contain the relation and the validation
# Can provide some features linked to this model
class Battle < ActiveRecord::Base
  belongs_to :artist_one, class_name: 'User', foreign_key: 'artist_one_id'
  belongs_to :artist_two, class_name: 'User', foreign_key: 'artist_two_id'
  has_many :votes

  validates :artist_one, :artist_two, :date_begin, :date_end, presence: true
  validates :date_begin, :date_end, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  # Filter of information for the API
  def self.miniKey
  	[:id, :date_begin, :date_end]
  end

  # The strong parameters to save or update object
  def self.battle_params(parameters)
    parameters.require(:battle).permit(:date_begin, :date_end, :artist_one_id, :artist_two_id)
  end
end
