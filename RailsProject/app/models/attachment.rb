class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :news

  validates :news, :url, :file_size, :content_type, presence: true
  validates :file_size, numericality: { only_integer: true }
end
