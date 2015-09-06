# The model of the object News
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +author_id+ - (integer) - The ID of the user
# - +title+ - (string) - The title of the news (need to change for multi language)
# - +news_type+ - (string) - The type of news (example : "discovery", "promotion", "information"...)
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_many+ - :newstexts
# - +has_and_belongs_to_many+ - :attachments
# - +has_and_belongs_to_many+ - :commentaries
#
class News < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  has_many :newstexts
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, presence: true

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :date]
  def self.miniKey
    [:id, :title, :created_at]
  end
  # The strong parameters to save or update object
  def self.news_params(parameters)
    parameters.require(:news).permit(:title, :author_id)
  end
end
