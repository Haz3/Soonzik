# The model of the object Genre
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +style_name+ - (string) - The name of the genre
# - +color_name+ - (string) - The name of the color (is it a red ? A blue ? A particular name like magenta ?)
# - +color_hexa+ - (string) - The hexa code of the color
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :musics --- NOT ANYMORE
# - +has_and_belongs_to_many+ - :influences
# - +has_and_belongs_to_many+ - :descriptions
# - +has_and_belongs_to_many+ - :packs
# - +has_and_belongs_to_many+ - :finished_musics, -> { where("album_id IS NOT NULL") }
#
class Genre < ActiveRecord::Base
  has_and_belongs_to_many :influences
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :musics, -> { where("album_id IS NOT NULL") }, class_name: 'Music', foreign_key: 'genre_id', join_table: 'genres_musics', association_foreign_key: 'music_id'

  validates :style_name, :color_name, :color_hexa, presence: true, uniqueness: true
  validates :style_name, format: /([A-Za-z]+)/
  validates :color_hexa, format: /#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/

  # Filter of information for the API
  #
  # Fields returned : [:id, :style_name, :color_name, :color_hexa]
  def self.miniKey
    [:id, :style_name, :color_name, :color_hexa]
  end

  # The strong parameters to save or update object
  def self.genre_params(parameters)
    parameters.require(:genre).permit(:style_name, :color_name, :color_hexa)
  end
end
