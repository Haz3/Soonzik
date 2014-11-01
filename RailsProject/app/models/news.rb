class News < ActiveRecord::Base
  belongs_to :user
  has_many :tags
  has_many :newstexts
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, :date, presence: true
  validates :date, format: /(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01]) \d\d:\d\d:\d\d/
end
