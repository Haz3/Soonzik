# The model of the object Attachment
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +news_id+ - (integer) - The ID of the news
# - +url+ - (string) - The url of the resource
# - +file_size+ - (integer) - The size of the file (in octets)
# - +content_type+ - (string) - The MIME code to know which type of file it is
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :news
#
class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :news

  validates :news, :url, :file_size, :content_type, presence: true
  validates :file_size, numericality: { only_integer: true }

  # Filter of information for the API
  #
  # Fields returned : [:id, :url, :file_size, :content_type]
  def self.miniKey
  	[:id, :url, :file_size, :content_type]
  end

  # The strong parameters to save or update object
  def self.attachment_params(parameters)
    parameters.require(:attachment).permit(:url, :file_size, :content_type)
  end
end
