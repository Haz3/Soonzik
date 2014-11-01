class Influence < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :genres

  validates :name, presence: true, format: /([A-Za-z]+)/, uniqueness: true
end
