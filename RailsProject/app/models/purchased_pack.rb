# The model of the object PurchasedPacks
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This object will never be used for something else than relation
class PurchasedPack < ActiveRecord::Base
	has_many :purchased_albums
	belongs_to :pack

	has_many :purchased_musics, through: :purchased_albums
end
