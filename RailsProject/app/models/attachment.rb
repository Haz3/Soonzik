# The model of the object Attachment
# Contain the relation and the validation
# Can provide some features linked to this model
class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :news

  validates :news, :url, :file_size, :content_type, presence: true
  validates :file_size, numericality: { only_integer: true }

  # The strong parameters to save or update object
  def self.attachment_params(parameters)
    parameters.require(:attachment).permit(:url, :file_size, :content_type)
  end
end
