# The model of the object Group
# Contain the relation and the validation
# Can provide some features linked to this model
class Group < ActiveRecord::Base
  has_many :accesses
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true, format: /([A-Za-z]+)/
end
