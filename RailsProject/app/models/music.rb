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
  has_and_belongs_to_many :playlist_objects
  has_and_belongs_to_many :genres

  has_many :purchased_musics

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
    [:id, :title, :duration, :price]
  end

  # Get the average of notes
  def getAverageNote
    return MusicNote.where(music_id: self.id).average(:value).to_f
  end

  # Suggestion logic
  def self.suggest(user)
    index =           0
    gPond =           {}
    musicList =       []
    suggestionList =  []

    user.purchases.each { |purchase|        # => For each purchase
      purchase.musics.each { | music |      # => For each musics purchased
        music.genres.each { | genre_obj |   # => For each genre
          # If the genre is not in the hash, we init it, else we increment it 
          gPond[genre_obj] = (gPond.has_key?(genre_obj)) ? gPond[genre_obj] + 1 : 1
        }
        # The music is already purchased so we don't have to suggest it
        musicList << music 
      }
    }

    # if our list is too small, we add a random genre to fill the suggestion list
    if (gPond.size < Genre.count)
      randomGenre = Genre.all
      gPond.each { |key, value|
        randomGenre = randomGenre.where.not(id: key)
      }
      randomGenre = randomGenre.offset(rand(randomGenre.size)).first
      gPond[randomGenre] = 0 if randomGenre != nil
    end

    # We sort by ponderation and transform it as an array [ [key, value], [key, value], ...]
    gPond = gPond.sort_by{|k,v| v}

    # While the list of suggestion is not filled or our list of genre is not finished
    while index < gPond.size && suggestionList.size < 10
      # We get the genre Object and its musics
      genreObject = gPond[index][0]
      listTmp = genreObject.musics.to_a

      # We sort it by notes
      listTmp.sort! { |music1, music2| music2.getAverageNote <=> music1.getAverageNote }
      
      # We remove the musics already purchased
      musicList.each { |musicToRemove|
        listTmp.delete(musicToRemove)
      }
      if (listTmp.size + suggestionList.size <= 10)
        suggestionList = suggestionList | listTmp
        musicList = musicList | listTmp
      else
        # To fill the suggestionList, we get random element of our new list
        suggestionList = suggestionList | listTmp[0..30].shuffle[0..(10 - suggestionList.size)]
      end
      index += 1
    end

    return suggestionList
  end

end
