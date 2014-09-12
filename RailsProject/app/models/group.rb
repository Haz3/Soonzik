class Group < ActiveRecord::Base
  has_many :accesses
  has_and_belongs_to_many :users
end
