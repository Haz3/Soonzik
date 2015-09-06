# The model of the object Album
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the artist who own the album
# - +title+ - (string) - The title of the album
# - +image+ - (string) - The image of the album (the name of the image, not the filename !)
# - +price+ - (float) - The price of the album
# - +file+ - (string) - The name of the file to find it
# - +yearProd+ - (integer) - The year of production when the album was released
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :descriptions
# - +has_and_belongs_to_many+ - :genres
# - +has_and_belongs_to_many+ - :packs
# - +has_and_belongs_to_many+ - :commentaries
# - +has_many+ - :album_notes
# - +has_many+ - :propositions
# - +has_many+ - :musics
# - +has_many+ - :purchased_albums
# - +belongs_to+ - :user
#
class Album < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :commentaries
  has_many :propositions
  has_many :musics
  belongs_to :user

  has_many :purchased_albums

  validates :user, :title, :price, :file, :yearProd, :image, presence: true
  validates :file, uniqueness: true
  validates :yearProd, numericality: { only_integer: true }

  # The strong parameters to save or update object
  def self.album_params(parameters)
    parameters.require(:album).permit(:user_id, :title, :price, :file, :yearProd, :image)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :price, :image, :yearProd]
  def self.miniKey
    [:id, :title, :price, :image, :yearProd]
  end

  # Get the average of notes
  def getAverageNote
    return AlbumNote.where(album_id: self.id).average(:value).to_f
  end

  # Add an attribute to know if it's an album proposed
  def setProposed(value)
    @proposed = value
  end

  # Get an attribute to know if it's an album proposed
  def getProposed
    @proposed
  end
end
