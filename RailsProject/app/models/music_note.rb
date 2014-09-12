class MusicNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
end
