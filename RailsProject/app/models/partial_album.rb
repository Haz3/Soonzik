# The model of the object PartialAlbum
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Associations
#
#  +:belongs_to+ - :pack
#  +:belongs_to+ - :album
#
class PartialAlbum < ActiveRecord::Base
  belongs_to :pack
  belongs_to :album
end
