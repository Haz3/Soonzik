class News < ActiveRecord::Base
  belongs_to :user
  has_many :tags
  has_many :newstexts
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries
end
