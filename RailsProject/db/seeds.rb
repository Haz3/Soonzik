# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or create!d alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


# Admin user
if (AdminUser.count == 0)
  AdminUser.create!(email: 'admin@soonzik.com', password: 'azertyuiop', password_confirmation: 'azertyuiop')
end

# Languages
languages = Language.create!(
	[
		{ language: "Français", abbreviation: "FR" },
		{ language: "English", abbreviation: "EN" }
	]
)

# Groups
artistGroup = Group.create!({ name: "Artist" })

########################
###   UTILISATEURS   ###
########################

# Addresses
	# for users
addr1 = Address.create!(numberStreet: 1, street: 'Rue des sciences', city: 'Strasbourg', country: 'France', zipcode: '67000')
addr2 = Address.create!(numberStreet: 2, street: 'Rue Solférino', city: 'Lille', country: 'France', zipcode: '59000')
addr3 = Address.create!(numberStreet: 3, street: 'Rue Nationale', city: 'Lyon', country: 'France', zipcode: '69000')
addr4 = Address.create!(numberStreet: 4, street: 'Rue de la paix', city: 'Paris', country: 'France', zipcode: '59000')
	# for concerts
addr5 = Address.create!(numberStreet: 5, street: 'Boulevard de la République', city: 'Rennes', country: 'France', zipcode: '35000')
addr6 = Address.create!(numberStreet: 6, street: 'Avenue Coubertin', city: 'Bordeaux', country: 'France', zipcode: '33000')
addr7 = Address.create!(numberStreet: 7, street: 'Impasse de la gare', city: 'Marseille', country: 'France', zipcode: '13000', complement: "Immeuble B Appartement 4")

# Users
u1 = User.create!(email: "user_one@gmail.com", password: "azertyuiop", fname: "Pierre", lname: "Fournier", username: "user1", birthday: "1980-01-01 00:00:00", address_id: addr1.id, language: "FR", background: "04191c1a850e9b2a4907c00f5a576f431c68759d5ee38c3f91209721ed0a0ba9-vault-boy-fallout-cover.jpg", image: "390edf60727581a22c9c2eda21a92d74a19f36ad81336cad73a4f2226f3a443c-avatarCF.png")
u2 = User.create!(email: "user_two@gmail.com", password: "azertyuiop", fname: "Paul", lname: "Dupont", username: "user2", birthday: "1981-02-02 00:00:00", language: "EN", background: "88f0459a4158f6631c057f52fdf60c7dcac2125983e0ad8d39d3f6ab11b2f6fd-vault-boy-fallout-cover.jpg", image: "5564724a35f753977549815abdbf955315b19d63d0de7ab65db4dc6aca38a1b3-tarask.jpg")
u3 = User.create!(email: "user_three@gmail.com", password: "azertyuiop", fname: "Jacques", lname: "Dupond", username: "user3", birthday: "1982-03-03 00:00:00", language: "FR", image: "9100df8f5383a10d8accb26aae55ffe9b292be3c53f90741f8f9f0e15ad9b247-tarask.jpg")
u4 = User.create!(email: "user_four@gmail.com", password: "azertyuiop", fname: "Maurice", lname: "Denys", username: "user4", birthday: "1983-04-04 00:00:00", address_id: addr2.id, language: "EN", image: "b29a4646a1eaa1708d4e4b18cbe0cab2a31780c1b0f5cf909200c811413b3507-BxulrrIAAAGpUq.jpg")
u5 = User.create!(email: "user_five@gmail.com", password: "azertyuiop", fname: "Bernard", lname: "Maheux", username: "user5", birthday: "1984-05-05 00:00:00", address_id: addr3.id, language: "FR", image: "cfd4b1776948cfd089aa67ece9216f6e04c91ad22939e343d005969fb9aaad46-avatarCF.png")
u6 = User.create!(email: "user_six@gmail.com", password: "azertyuiop", fname: "Jean", lname: "Moliner", username: "user6", birthday: "1985-06-06 00:00:00", address_id: addr4.id, language: "FR", image: "e2ab9423d9fac2f10bd1a9c8b68077470388cfe5e57804dc2e06e146d245f410-avatarCF.png")

# Artist
a1 = User.create!(email: "artist_one@gmail.com", password: "azertyuiop", fname: "First", lname: "Artist", username: "Kygo", birthday: "1990-01-01 00:00:00", language: "EN", image: "picture.jpg")
a2 = User.create!(email: "artist_two@gmail.com", password: "azertyuiop", fname: "Second", lname: "Artist", username: "CalvinHarris", birthday: "1990-01-01 00:00:00", language: "EN")
a3 = User.create!(email: "artist_three@gmail.com", password: "azertyuiop", fname: "Third", lname: "Artist", username: "MajorLazer", birthday: "1990-01-01 00:00:00", language: "EN")
a4 = User.create!(email: "artist_four@gmail.com", password: "azertyuiop", fname: "Fourth", lname: "Artist", username: "Soprano", birthday: "1990-01-01 00:00:00", language: "EN")
a5 = User.create!(email: "artist_five@gmail.com", password: "azertyuiop", fname: "Fifth", lname: "Artist", username: "Skrillex", birthday: "1990-01-01 00:00:00", language: "EN")
a6 = User.create!(email: "artist_six@gmail.com", password: "azertyuiop", fname: "Sixth", lname: "Artist", username: "Avicii", birthday: "1990-01-01 00:00:00", language: "FR")
a7 = User.create!(email: "artist_seven@gmail.com", password: "azertyuiop", fname: "Seventh", lname: "Artist", username: "DavidGuetta", birthday: "1990-01-01 00:00:00", language: "FR")
a8 = User.create!(email: "artist_eigh@gmail.com", password: "azertyuiop", fname: "Eighth", lname: "Artist", username: "IndieArtist", birthday: "1990-01-01 00:00:00", language: "FR")

a1.groups << artistGroup
a2.groups << artistGroup
a3.groups << artistGroup
a4.groups << artistGroup
a5.groups << artistGroup
a6.groups << artistGroup
a7.groups << artistGroup
a8.groups << artistGroup

# Follow

Follow.create!([
	{ user_id: a1.id, follow_id: a2.id },
	{ user_id: a2.id, follow_id: a3.id },
	{ user_id: a3.id, follow_id: a4.id },
	{ user_id: a4.id, follow_id: a5.id },
	{ user_id: a5.id, follow_id: a6.id },
	{ user_id: a6.id, follow_id: a7.id },
	{ user_id: a7.id, follow_id: a8.id },
	{ user_id: u1.id, follow_id: u2.id },
	{ user_id: u2.id, follow_id: u3.id },
	{ user_id: u3.id, follow_id: u4.id },
	{ user_id: u4.id, follow_id: u5.id },
	{ user_id: u5.id, follow_id: u6.id },
])

Friend.create!([
	# u1 & u2
	{ user_id: u1.id, friend_id: u2.id },
	{ user_id: u2.id, friend_id: u1.id },
	# u1 & u6
	{ user_id: u6.id, friend_id: u1.id },
	{ user_id: u1.id, friend_id: u6.id },
	# u2 & u3
	{ user_id: u2.id, friend_id: u3.id },
	{ user_id: u3.id, friend_id: u2.id },
	# u2 & u5
	{ user_id: u5.id, friend_id: u2.id },
	{ user_id: u2.id, friend_id: u5.id },
	# u3 & u4
	{ user_id: u3.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: u3.id },
	# u3 & a1
	{ user_id: u3.id, friend_id: a1.id },
	{ user_id: a1.id, friend_id: u3.id },
	# u4 & u5
	{ user_id: u5.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: u5.id },
	# u5 & u6
	{ user_id: u5.id, friend_id: u6.id },
	{ user_id: u6.id, friend_id: u5.id },
	# a1 & a2
	{ user_id: a1.id, friend_id: a2.id },
	{ user_id: a2.id, friend_id: a1.id },
	# a3 & a4
	{ user_id: a3.id, friend_id: a4.id },
	{ user_id: a4.id, friend_id: a3.id },
	# a5 & u4
	{ user_id: a5.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: a5.id }
])

Identity.create!([
	{ user_id: a5.id, provider: "facebook", uid: 793698620716097 },
	{ user_id: a5.id, provider: "twitter", uid: 611647919 },
	{ user_id: u5.id, provider: "facebook", uid: 10206800091031572 },
	{ user_id: u6.id, provider: "facebook", uid: 10206035273190419 }
])


###########################
###   CONTENU MUSICAL   ###
###########################

# Influence
influ = Influence.create!([
	{ name: "Electronic" },
	{ name: "Vocal" },
	{ name: "Rock" }
])

# Genres
genres = Genre.create!([
	{ style_name: "Rock'n roll", color_name: "red", color_hexa: "#FF0000" },
	{ style_name: "Rap", color_name: "green", color_hexa: "#00FF00" },
	{ style_name: "Techno", color_name: "blue", color_hexa: "#0000FF" },
	{ style_name: "Metal", color_name: "blue2", color_hexa: "#0000FE" },
	{ style_name: "Classique", color_name: "blue3", color_hexa: "#0000FD" },
	{ style_name: "Reggae", color_name: "blue4", color_hexa: "#0000FC" },
	{ style_name: "Zen", color_name: "blue5", color_hexa: "#0000FB" }
])

influ[0].genres << genres[2]
influ[1].genres << genres[1]
influ[1].genres << genres[4]
influ[1].genres << genres[5]
influ[1].genres << genres[6]
influ[2].genres << genres[0]
influ[2].genres << genres[3]

# Albums
albums = Album.create!([
	{ user_id: a1.id, title: "Album 1", image: "album1.jpg", price: 10.0, file: "album1.jpg", yearProd: 2000 },
	{ user_id: a2.id, title: "Album 2", image: "album2.jpg", price: 11.0, file: "album2.jpg", yearProd: 2003 },
	{ user_id: a3.id, title: "Album 3", image: "album3.jpg", price: 12.0, file: "album3.jpg", yearProd: 2006 },
	{ user_id: a4.id, title: "Album 4", image: "1546b7a0f80ac170cd902363eaaf04b302077ea1f8b13836bbe01e6ad3bb3132-kirbyseeker.png", price: 13.0, file: "1546b7a0f80ac170cd902363eaaf04b302077ea1f8b13836bbe01e6ad3bb3132-kirbyseeker.png", yearProd: 2006 },
	{ user_id: a5.id, title: "Album 5", image: "ebda6daa0ed21cd0a11ee3447008be9d5fee83f2b00240930fb024e2edb5f2a0-SoonZiklogo.png", price: 14.0, file: "ebda6daa0ed21cd0a11ee3447008be9d5fee83f2b00240930fb024e2edb5f2a0-SoonZiklogo.png", yearProd: 2006 },
	{ user_id: a6.id, title: "Album 6", image: "album4.jpg", price: 15.0, file: "album4.jpg", yearProd: 2006 },
	{ user_id: a7.id, title: "Album 7", image: "album5.jpg", price: 16.0, file: "album5.jpg", yearProd: 2006 },
	{ user_id: a8.id, title: "Album 8", image: "album6.jpg", price: 17.0, file: "album6.jpg", yearProd: 2006 }
])

i = 0
albums.each do |album|
	album.genres << genres[i]
	i++
	i = 0 if (i == 7)
end

pack = Pack.create!(title: "Le premier pack", association_id: nil, begin_date: Time.now, end_date: Time.now + 10000000 + 20000, minimal_price: 1.0)
pack.albums << albums.first
pack.albums << albums.second
pack.albums << albums.third
pack.albums << albums.fourth

PartialAlbum.create!([
	{ pack_id: pack.id, album_id: albums.third.id },
	{ pack_id: pack.id, album_id: albums.fourth.id }
])

# Musics
musics = Music.create!([
	# artist 1
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 01", duration: 213, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 02", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 03", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 04", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 05", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 06", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 07", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 08", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 09", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 10", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Track 11", duration: 193, price: 1, file: "music1", limited: true },
	# artist 2
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 1", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 2", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 3", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 4", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 5", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 6", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 7", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 8", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 9", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 10", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Music 11", duration: 193, price: 1, file: "music1", limited: true },
	# artist 3
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 1", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 2", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 3", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 4", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 5", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 6", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 7", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 8", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Song 9", duration: 193, price: 1, file: "music1", limited: true },
	# artist 4
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 1", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 2", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 3", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 4", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 5", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 6", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 7", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Musique 8", duration: 193, price: 1, file: "music1", limited: true },
	# artist 5
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 1", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 2", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 3", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 4", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 5", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 6", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 7", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Melodie 8", duration: 193, price: 1, file: "music1", limited: true },
	# artist 6
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 1", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 2", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 3", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 4", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 5", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 6", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 7", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 8", duration: 193, price: 1, file: "music1", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Melody 9", duration: 193, price: 1, file: "music1", limited: true },
])

i = 0
musics.each do |music|
	music.genres << genres[i]
	i++
	i = 0 if (i == 7)
end

####################
###   Services   ###
####################

news = News.create!([
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id }
])

news.each do |n|
	Newstext.create!([
		{ content: "Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français", language: "FR", news_id: n.id },
		{ content: "Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english", language: "EN", news_id: n.id }
	])

	NewsTitle.create!([
		{ news_id: n.id, title: "Titre de ma news", language: "FR" },
		{ news_id: n.id, title: "Title of my news", language: "EN" }
	])

	n.attachments << Attachment.create!({ url: "placeholder.jpg", file_size: 1024, content_type: "image/jpegNews" })
end


battle = Battle.create!({ date_begin: "2015-09-01 00:00:00", date_end: "2015-10-10 00:00:00", artist_one_id: a5.id, artist_two_id: a6.id })

Concert.create!([
	{ user_id: a5.id, planification: "2016-01-01 00:00:00", address_id: addr5.id, url: nil },
	{ user_id: a6.id, planification: "2016-02-01 00:00:00", address_id: addr6.id, url: "http://www.google.fr" },
	{ user_id: a7.id, planification: "2016-03-01 00:00:00", address_id: addr7.id, url: nil }
])

##################
###   Social   ###
##################

Message.create!([
	# Discussion entre users
	{ msg: "Coucou, comment vas tu ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u2.id, dest_id: u1.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: u1.id, dest_id: u2.id, session: "web" },
	# ----
	{ msg: "Coucou, comment vas tu ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: u3.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: u3.id, dest_id: u4.id, session: "web" },
	# ----
	{ msg: "Coucou, comment vas tu ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u6.id, dest_id: u5.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: u5.id, dest_id: u6.id, session: "web" },
	# ----
	# Discussion avec des artistes
	{ msg: "Coucou, comment vas tu ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a2.id, dest_id: a1.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: a1.id, dest_id: a2.id, session: "web" },
	# ----
	{ msg: "Coucou, comment vas tu ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: a4.id, dest_id: a3.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: a3.id, dest_id: a4.id, session: "web" },
	# ----
	{ msg: "Coucou, comment vas tu ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Ca va, on fait aller, et toi ?", user_id: a5.id, dest_id: u4.id, session: "web" },
	{ msg: "Ca va et toi ?", user_id: u4.id, dest_id: a5.id, session: "web" },
	{ msg: "Bon, on arrête ?", user_id: a5.id, dest_id: u4.id, session: "web" },
])


Tweet.create!([
	{ msg: "Wow, nice tweet module :)", user_id: u1.id },
	{ msg: "Wow, nice tweet module :)", user_id: u2.id },
	{ msg: "Wow, nice tweet module :)", user_id: u3.id },
	{ msg: "Wow, nice tweet module :)", user_id: u4.id },
	{ msg: "Wow, nice tweet module :)", user_id: u5.id },
	{ msg: "Wow, nice tweet module :)", user_id: u6.id },
	{ msg: "I swear, it's cool", user_id: u1.id },
	{ msg: "I swear, it's cool", user_id: u2.id },
	{ msg: "I swear, it's cool", user_id: u3.id },
	{ msg: "I swear, it's cool", user_id: u4.id },
	{ msg: "I swear, it's cool", user_id: u5.id },
	{ msg: "I swear, it's cool", user_id: u6.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u1.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u2.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u3.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u4.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u5.id },
	{ msg: "Nice work @Kygo I love your musics", user_id: u6.id },
	{ msg: "There is a battle between @Skrillex and @Avicii omg =O", user_id: a1.id },
	{ msg: "There is a battle between @Skrillex and @Avicii omg =O", user_id: a2.id },
	{ msg: "There is a battle between @Skrillex and @Avicii omg =O", user_id: a3.id },
	{ msg: "There is a battle between @Skrillex and @Avicii omg =O", user_id: a4.id },
])

Vote.create!([
	{ user_id: a1.id, battle_id: battle.id, artist_id: a5.id },
	{ user_id: a2.id, battle_id: battle.id, artist_id: a6.id }
])

a3.albums.each do |album|
	album.commentaries << Commentary.create!({author_id: u4.id, content: "Je suis fan de ce que tu fais !" })
end
a4.albums.each do |album|
	album.commentaries << Commentary.create!({author_id: u4.id, content: "Je suis fan de ce que tu fais !" })
end

News.first.commentaries << Commentary.create!({author_id: u6.id, content: "J'adore les news de votre site" })

Music.all.each do |music|
	MusicNote.create!([
		{ user_id: u1.id, music_id: music.id, value: rand(5) },
		{ user_id: u2.id, music_id: music.id, value: rand(5) },
		{ user_id: u3.id, music_id: music.id, value: rand(5) },
		{ user_id: u4.id, music_id: music.id, value: rand(5) },
		{ user_id: u5.id, music_id: music.id, value: rand(5) }
	])
end

#################
###   Achat   ###
#################

p1 = Purchase.create!({ user_id: u5.id })
p2 = Purchase.create!({ user_id: u5.id })
p3 = Purchase.create!({ user_id: u5.id })
p4 = Purchase.create!({ user_id: u5.id })
p5 = Purchase.create!({ user_id: u6.id })
p6 = Purchase.create!({ user_id: u6.id })
p7 = Purchase.create!({ user_id: u6.id })
p8 = Purchase.create!({ user_id: u6.id })


# Pour le user 5
pa1 = PurchasedAlbum.create!({ album_id: a5.albums.first.id, purchased_pack_id: nil })
a5.albums.first.musics.each do |music|
	PurchasedMusic.create!({ music_id: music.id, purchase_id: p1.id, purchased_album_id: pa1.id })
end
PurchasedMusic.create!({ music_id: Music.first.id, purchase_id: p2.id, purchased_album_id: nil })
PurchasedMusic.create!({ music_id: Music.second.id, purchase_id: p3.id, purchased_album_id: nil })
PurchasedMusic.create!({ music_id: Music.third.id, purchase_id: p4.id, purchased_album_id: nil })

# Pour le user 6

PurchasedMusic.create!({ music_id: Music.fourth.id, purchase_id: p5.id, purchased_album_id: nil })
PurchasedMusic.create!({ music_id: Music.fifth.id, purchase_id: p6.id, purchased_album_id: nil })
PurchasedMusic.create!({ music_id: Music.offset(5).first.id, purchase_id: p7.id, purchased_album_id: nil })
PurchasedMusic.create!({ music_id: Music.offset(6).first.id, purchase_id: p8.id, purchased_album_id: nil })


# Listening

#48.8101 2.3569		Kremlin Bicetre
#48.8695 2.3315		Rue de la paix
Listening.create!([
	{ user_id: u1.id, music_id: Music.first.id, :when => Time.now, latitude: 48.81, longitude: 2.31 },
	{ user_id: u1.id, music_id: Music.second.id, :when => Time.now, latitude: 48.82, longitude: 2.33 },
	{ user_id: u1.id, music_id: Music.third.id, :when => Time.now, latitude: 48.83, longitude: 2.32 },
	{ user_id: u1.id, music_id: Music.fourth.id, :when => Time.now, latitude: 48.84, longitude: 2.34 },
	{ user_id: u2.id, music_id: Music.fifth.id, :when => Time.now, latitude: 48.85, longitude: 2.36 },
	{ user_id: u2.id, music_id: Music.offset(5).first.id, :when => Time.now, latitude: 48.86, longitude: 2.35 },
	{ user_id: u2.id, music_id: Music.offset(6).first.id, :when => Time.now, latitude: 48.87, longitude: 2.38 },
	{ user_id: u2.id, music_id: Music.offset(7).first.id, :when => Time.now, latitude: 48.88, longitude: 2.37 },

	{ user_id: u3.id, music_id: Music.first.id, :when => Time.now, latitude: 48.815, longitude: 2.28 },
	{ user_id: u3.id, music_id: Music.second.id, :when => Time.now, latitude: 48.845, longitude: 2.32 },
	{ user_id: u3.id, music_id: Music.third.id, :when => Time.now, latitude: 48.835, longitude: 2.29 },
	{ user_id: u3.id, music_id: Music.fourth.id, :when => Time.now, latitude: 48.825, longitude: 2.26 },
	{ user_id: u4.id, music_id: Music.fifth.id, :when => Time.now, latitude: 48.815, longitude: 2.36 },
	{ user_id: u4.id, music_id: Music.offset(5).first.id, :when => Time.now, latitude: 48.90, longitude: 2.40 },
	{ user_id: u4.id, music_id: Music.offset(6).first.id, :when => Time.now, latitude: 48.91, longitude: 2.39 },
	{ user_id: u4.id, music_id: Music.offset(7).first.id, :when => Time.now, latitude: 48.78, longitude: 2.42 },

	{ user_id: u5.id, music_id: Music.first.id, :when => Time.now, latitude: 48.4, longitude: 2.32 },
	{ user_id: u5.id, music_id: Music.second.id, :when => Time.now, latitude: 48.5, longitude: 2.39 },
	{ user_id: u5.id, music_id: Music.third.id, :when => Time.now, latitude: 48.45, longitude: 2.31 },
	{ user_id: u5.id, music_id: Music.fourth.id, :when => Time.now, latitude: 48.48, longitude: 2.25 },
	{ user_id: u6.id, music_id: Music.fifth.id, :when => Time.now, latitude: 48.54, longitude: 2.37 },
	{ user_id: u6.id, music_id: Music.offset(5).first.id, :when => Time.now, latitude: 48.56, longitude: 2.34 },
	{ user_id: u6.id, music_id: Music.offset(6).first.id, :when => Time.now, latitude: 48.49, longitude: 2.23 },
	{ user_id: u6.id, music_id: Music.offset(7).first.id, :when => Time.now, latitude: 48.52, longitude: 2.42 },
])