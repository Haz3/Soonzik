# The model of the object Commentary
# Contain the relation and the validation
# Can provide some features linked to this model
class Commentary < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :news
  has_and_belongs_to_many :musics
  has_and_belongs_to_many :albums

  validates :user, :content, presence: true
end
