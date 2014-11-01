class Genre < ActiveRecord::Base
  has_and_belongs_to_many :influences
  has_and_belongs_to_many :descriptions

  validates :style_name, :color_name, :color_hexa, presence: true, uniqueness: true
  validates :style_name, format: /([A-Za-z]+)/
  validates :color_hexa, format: /#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})/
end
