# The model of the object News
# Contain the relation and the validation
# Can provide some features linked to this model
class News < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  has_many :tags
  has_many :newstexts
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, :date, presence: true
  validates :date, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  # Filter of information for the API
  def self.miniKey
    [:id, :title, :date]
  end
  # The strong parameters to save or update object
  def self.news_params(parameters)
    parameters.require(:news).permit(:title, :date, :author_id)
  end
end
