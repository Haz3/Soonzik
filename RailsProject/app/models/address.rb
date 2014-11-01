class Address < ActiveRecord::Base
  has_many :users
  has_many :concerts

  validates :numberStreet, :street, :city, :country, :zipcode, presence: true
end
