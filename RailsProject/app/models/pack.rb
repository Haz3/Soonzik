class Pack < ActiveRecord::Base
  has_and_belongs_to_many :albums

  validates :title, :style, :albums, presence: true
end
