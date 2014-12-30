# The model of the object Newstext
# Contain the relation and the validation
# Can provide some features linked to this model
class Newstext < ActiveRecord::Base
  belongs_to :news

  validates :news, :content, :title, :language, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }

  # The strong parameters to save or update object
  def self.newstext_params(parameters)
    parameters.require(:newstext).permit(:content, :title, :language, :news_id)
  end
end
