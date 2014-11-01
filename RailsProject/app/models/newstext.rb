class Newstext < ActiveRecord::Base
  belongs_to :news

  validates :news, :content, :title, :language, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }
end
