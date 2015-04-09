# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


residence = Address.create(numberStreet: 9, street: 'Rue des sciences', city: 'Paris', country: 'France', zipcode: '95000')
pub = Address.create(numberStreet: 21, street: 'Rue Solférino', city: 'Lille', country: 'France', zipcode: '59000')

common_user = User.create(email: "utilisateur@commun.com", password: "azertyuiop", fname: "Utilisateur", lname: "Commun", username: "Utilisateur Commun", birthday: "1990-01-01 00:00:00", address_id: residence.id, language: "FR")
artist = User.create(email: "utilisateur@artist.com", password: "qwertyuiop", fname: "Artiste", lname: "Hors du Commun", username: "KeenV Lol", birthday: "1985-01-01 00:00:00", language: "FR")
artist2 = User.create(email: "utilisateur2@artist.com", password: "qwertyuiop", fname: "Artiste", lname: "Hors du Commun", username: "KeenV Lol 2", birthday: "1985-01-01 00:00:00", language: "FR")

albums = Album.create([
	{ user_id: artist.id, title: "Album 1", image: "album1", price: 10.0, file: "/lolOsef", yearProd: 2000 },
	{ user_id: artist.id, title: "Album 2", image: "album2", price: 11.0, file: "/lolOsefPas", yearProd: 2003 },
	{ user_id: artist.id, title: "Album 3", image: "album3", price: 12.0, file: "/lolOsefUnPeu", yearProd: 2006 }
])

AlbumNote.create([
	{ user_id: artist.id, album_id: albums[0].id, value: 5 },
	{ user_id: artist.id, album_id: albums[1].id, value: 4 },
	{ user_id: artist.id, album_id: albums[2].id, value: 3 }
])

attachment = Attachment.create({ url: "/imageRandom", file_size: 1024, content_type: "application/ms-doc" })

Battle.create({ date_begin: "2015-04-01 00:00:00", date_end: "2015-04-10 00:00:00", artist_one_id: artist.id, artist_two_id: artist2.id })

comment = Commentary.create({author_id: common_user.id, content: "Ceci est un commentaire" })
albums[0].commentaries << comment

Concert.create({ user_id: artist2.id, planification: "2016-01-01 00:00:00", address_id: pub.id, url: "/UrlDeConcert" })

Follow.create([
	{ user_id: common_user.id, follow_id: artist.id },
	{ user_id: common_user.id, follow_id: artist2.id },
	{ user_id: artist.id, follow_id: artist2.id }
])

Friend.create({ user_id: common_user.id, friend_id: artist.id })

genres = Genre.create([
	{ style_name: "Rock", color_name: "red", color_hexa: "#FF0000" },
	{ style_name: "Rap", color_name: "green", color_hexa: "#00FF00" },
	{ style_name: "Techno", color_name: "blue", color_hexa: "#0000FF" }
])

albums[0].genres << genres[0]
albums[1].genres << genres[1]
albums[2].genres << genres[2]

groups = Group.create([
	{ name: "User" },
	{ name: "Artist" }
])

groups[0].users << common_user
groups[1].users << artist
groups[1].users << artist2


influ = Influence.create([
	{ name: "Electronic" },
	{ name: "Vocal" }
])

influ[0].genres << genres[2]
influ[1].genres << genres[0]
influ[1].genres << genres[1]

musics = Music.create([
	{ user_id: artist.id, album_id: albums[0].id, title: "Music 1", duration: 60, price: 2.0, file: "music1", limited: true },
	{ user_id: artist.id, album_id: albums[1].id, title: "Music 2", duration: 61, price: 2.0, file: "music2", limited: true },
	{ user_id: artist.id, album_id: albums[2].id, title: "Music 3", duration: 62, price: 2.0, file: "music3", limited: true },
	{ user_id: artist.id, album_id: albums[0].id, title: "Music 4", duration: 63, price: 2.0, file: "music4", limited: true },
	{ user_id: artist.id, album_id: albums[1].id, title: "Music 5", duration: 64, price: 2.0, file: "music5", limited: true },
	{ user_id: artist.id, album_id: albums[2].id, title: "Music 6", duration: 65, price: 2.0, file: "music6", limited: true },
	{ user_id: artist.id, album_id: albums[0].id, title: "Music 7", duration: 66, price: 2.0, file: "music7", limited: true },
	{ user_id: artist.id, album_id: albums[1].id, title: "Music 8", duration: 67, price: 2.0, file: "music8", limited: true },
	{ user_id: artist.id, album_id: albums[2].id, title: "Music 9", duration: 68, price: 2.0, file: "music9", limited: true }
])

genres[0].musics << musics[0]
genres[1].musics << musics[1]
genres[2].musics << musics[2]
genres[0].musics << musics[3]
genres[1].musics << musics[4]
genres[2].musics << musics[5]
genres[0].musics << musics[6]
genres[1].musics << musics[7]
genres[2].musics << musics[8]

news = News.create({title: "titre de ma news", date: "2015-04-10 20:30:55", author_id: common_user.id})

attachment.news << news

newsTexts = Newstext.create([
	{content: "Le contenu de ma news en français", title: "Paragraphe 1", language: "FR", news_id: news.id },
	{content: "The content of my english news", title: "First block", language: "EN", news_id: news.id }
])

pack = Pack.create({title: "Unique pack"})

pack.albums << albums[0]
pack.albums << albums[1]

