# The model of the object PurchasedMusics
# Contain the relation and the validation
# Can provide some features linked to this model
class PurchasedMusic < ActiveRecord::Base
	belongs_to :purchase
	belongs_to :music
	belongs_to :purchased_album
end