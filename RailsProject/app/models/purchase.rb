# The model of the object Purchase
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
#
# ==== Associations
#
# #######
# # First degree of relation
#
# belongs_to :user
# has_many :purchased_musics
#
# #######
# # Second degree of relation
#
#	has_many :musics, through: :purchased_musics
#	has_many :purchased_albums, through: :purchased_musics
#
# #######
# # Third degree of relation
#
#	has_many :albums, through: :purchased_albums
#	has_many :purchased_packs, through: :purchased_albums
#
# #######
# # Fourth degree of relation
#
#	has_many :packs, through: :purchased_packs
#
class Purchase < ActiveRecord::Base
  # First degree of relation
	  belongs_to :user
	  has_many :purchased_musics

	# Second degree of relation
		has_many :musics, -> { uniq }, through: :purchased_musics
		has_many :purchased_albums, -> { uniq }, through: :purchased_musics

	# Third degree of relation
		has_many :albums, -> { uniq }, through: :purchased_albums
		has_many :purchased_packs, -> { uniq }, through: :purchased_albums

	# Fourth degree of relation
		has_many :packs, -> { uniq }, through: :purchased_packs

  #has_and_belongs_to_many :albums
  #has_and_belongs_to_many :musics
  #has_and_belongs_to_many :packs

  validates :user, presence: true

  # The strong parameters to save or update object
  def self.purchase_params(parameters)
    parameters.require(:purchase).permit(:user_id)
  end

  def addPurchasedMusicFromObject(musicObject)
  	pMusic = PurchasedMusic.new
  	pMusic.music_id = musicObject.id
  	pMusic.purchase_id = self.id
  	pMusic.save!
  	return pMusic
  end

  def addPurchasedAlbumFromObject(albumObject)
  	listSavedMusics = []

  	pAlbum = PurchasedAlbum.new
  	pAlbum.album_id = albumObject.id
  	begin
	  	albumObject.musics.each { |musicObject|
	  		pMusic = addPurchasedMusicFromObject(musicObject)
		  	listSavedMusics << pMusic
	  	}
	  rescue
	  	listSavedMusics.each { |pMusic|
	  		pMusic.destroy
	  	}
	  	raise
	  end
  	pAlbum.save!
  	return pAlbum
  end

  def addPurchasedPackFromObject(packObject, partial)
  	listSavedAlbums = []

  	pPack = PurchasedPack.new
  	pPack.pack_id = packObject.id
  	begin
	  	packObject.albums.each { |albumObject|
	  		pAlbum = addPurchasedAlbumFromObject(albumObject)
		  	listSavedAlbums << pAlbum
	  	}
	  rescue
	  	listSavedAlbums.each { |pAlbum|
	  		pAlbum.musics.each { |pMusic|
	  			pMusic.destroy
	  		}
	  		pAlbum.destroy
	  	}
	  	raise
	  end

	  if partial == true
		  pPack.partial = true
		else
			pPack.partial = false
		end

  	pPack.save!
  end
end
