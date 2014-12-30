# The model of the object Tag
# Contain the relation and the validation
# Can provide some features linked to this model
class Tag < ActiveRecord::Base
  belongs_to :news

  validates :tag, :news, presence: true
  validates :tag, length: { maximum: 20, minimum: 4 }

  # The strong parameters to save or update object
  def self.tag_params(parameters)
    parameters.require(:tag).permit(:tag, :news_id)
  end
end
