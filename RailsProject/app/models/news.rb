# The model of the object News
# Contain the relation and the validation
# Can provide some features linked to this model
class News < ActiveRecord::Base
  belongs_to :user
  has_many :tags
  has_many :newstexts
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, :date, presence: true
  validates :date, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
end
