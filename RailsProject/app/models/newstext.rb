# The model of the object Newstext
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +news_id+ - (integer) - The ID of the news
# - +title+ - (string) - The title of the block of text
# - +content+ - (string) - The content of this block of text
# - +language+ - (string) - The language of the block of text
#
# ==== Associations
#
# - +belongs_to+ - :news
#
class Newstext < ActiveRecord::Base
  belongs_to :news

  validates :news, :content, :title, :language, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :content, :language]
  def self.miniKey
  	[:id, :title, :content, :language]
  end
  
  # The strong parameters to save or update object
  def self.newstext_params(parameters)
    parameters.require(:newstext).permit(:content, :title, :language, :news_id)
  end
end
