# The model of the object Tag
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +news_id+ - (integer) - The ID of the news
# - +tag+ - (string) - The name of the tag
#
# ==== Associations
#
# - +belongs_to+ - :news
#
class Tag < ActiveRecord::Base
  belongs_to :news

  validates :tag, :news, presence: true
  validates :tag, length: { maximum: 20, minimum: 4 }

  # Filter of information for the API
  #
  # Fields returned : [:id, :tag]
  def self.miniKey
  	[:id, :tag]
  end
  
  # The strong parameters to save or update object
  def self.tag_params(parameters)
    parameters.require(:tag).permit(:tag, :news_id)
  end
end
