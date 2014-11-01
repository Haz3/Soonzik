class Access < ActiveRecord::Base
  belongs_to :group

  validates :group, :controllerName, :actionName, presence: true
  validates :controllerName, :actionName, format: /([A-Za-z]+)/
end
