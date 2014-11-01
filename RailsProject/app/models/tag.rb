class Tag < ActiveRecord::Base
  belongs_to :news

  validates :tag, :news, presence: true
  validates :tag, length: { maximum: 20, minimum: 4 }
end
