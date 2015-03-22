# The model of the object Music
# Contain the relation and the validation
# Can provide some features linked to this model
class Music < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  has_one :flac
  has_many :listening
  has_many :music_notes
  has_and_belongs_to_many :commentaries
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :playlists
  has_and_belongs_to_many :genres


  validates :album, :user, :title, :duration, :price, :file, :limited, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }
  validates :price, :duration, numericality: true
  validates :file, uniqueness: true

  # The strong parameters to save or update object
  def self.music_params(parameters)
    parameters.require(:music).permit(:user_id, :album_id, :title, :duration, :price, :file, :limited)
  end

  # Filter of information for the API
  def self.miniKey
    [:id, :title, :duration, :price, :file]
  end

  # Get the average of notes
  def getAverageNote
    return MusicNote.where(music_id: self.id).average(:value).to_f
  end

  # Suggestion logic
  #
  # ==== Attributes
  #
  # * +userList+ - Users with same musics
  #
  def suggest(userList)
    genresPonderation = {}

    musicList.each do |music|
      if (music.genres != nil && music.genres.size != 0)
        # For each genre, we change ponderation
        music.genres.each do |g|
          if (genresPonderation.has_key?(g.id))
            genresPonderation[g.id] += 1
          else
            genresPonderation[g.id] = 0
          end
        end
      end
    end
  end

end
