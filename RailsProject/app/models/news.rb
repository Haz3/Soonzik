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
  after_initialize :myConstructor

  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  has_many :newstexts
  has_many :news_titles
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, presence: true

  # My constructor called after activerecord create the object ; it init the default language
  def myConstructor
    @language = "EN"
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :date]
  def self.miniKey
    [:id, :created_at]
  end

  # The strong parameters to save or update object
  def self.news_params(parameters)
    parameters.require(:news).permit(:title, :author_id)
  end

  # To give the title of the good language
  def setLanguage(language)
    if (Language.where(abbreviation: language).size != 0)
      @language = language
    end
  end

  # To give the title of the good language
  def title
    title = "No Title"
    if (@language.present?)
      nt = NewsTitle.where(news_id: self.id).where(language: @language)
      if (nt != nil && nt.size > 0)
        title = nt.first.title
      end
    end

    title
  end

  # To give the content of the good language
  def content
    content = "No Content"
    if (@language.present?)
      nt = Newstext.where(news_id: self.id).where(language: @language)
      if (nt != nil && nt.size > 0)
        content = nt.first.content
      end
    end

    content
  end
end
