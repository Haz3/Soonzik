# The model of the object PurchasedPacks
# Contain the relation and the validation
# Can provide some features linked to this model
class PurchasedPack < ActiveRecord::Base
	has_many :purchased_albums
	belongs_to :pack
end