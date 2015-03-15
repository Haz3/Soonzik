class ForeignKey < ActiveRecord::Migration
  def change
  	add_foreign_key :accesses, :groups , column: :group_id, primary_key: "id"

  	add_foreign_key :album_notes, :users , column: :user_id, primary_key: "id"
  	add_foreign_key :album_notes, :albums , column: :album_id, primary_key: "id"
  	
  	add_foreign_key :albums_commentaries, :albums , column: :album_id, primary_key: "id"
  	add_foreign_key :albums_commentaries, :commentaries , column: :commentary_id, primary_key: "id"
  	
  	add_foreign_key :albums_descriptions, :albums , column: :album_id, primary_key: "id"
  	add_foreign_key :albums_descriptions, :descriptions , column: :description_id, primary_key: "id"
  	
  	add_foreign_key :albums_genres, :albums , column: :album_id, primary_key: "id"
  	add_foreign_key :albums_genres, :genres , column: :genre_id, primary_key: "id"
  	
  	add_foreign_key :albums_packs, :albums , column: :album_id, primary_key: "id"
  	add_foreign_key :albums_packs, :packs , column: :pack_id, primary_key: "id"
  	
  	add_foreign_key :attachments_news, :attachments , column: :attachment_id, primary_key: "id"
  	add_foreign_key :attachments_news, :news , column: :news_id, primary_key: "id"
  	
  	add_foreign_key :battles, :users , column: :artist_one_id, primary_key: "id"
  	add_foreign_key :battles, :users , column: :artist_two_id, primary_key: "id"
  	
  	add_foreign_key :carts, :users , column: :user_id, primary_key: "id"
  	
  	add_foreign_key :commentaries, :users , column: :author_id, primary_key: "id"
  	
  	add_foreign_key :commentaries_musics, :commentaries , column: :commentary_id, primary_key: "id"
  	add_foreign_key :commentaries_musics, :musics , column: :music_id, primary_key: "id"
  	
  	add_foreign_key :commentaries_news, :commentaries , column: :commentaries_id, primary_key: "id"
  	add_foreign_key :commentaries_news, :news , column: :news_id, primary_key: "id"
  	
  	add_foreign_key :concerts, :users , column: :user_id, primary_key: "id"
  	add_foreign_key :concerts, :addresses , column: :address_id, primary_key: "id"
  	
  	add_foreign_key :descriptions_genres, :descriptions , column: :description_id, primary_key: "id"
  	add_foreign_key :descriptions_genres, :genres , column: :genre_id, primary_key: "id"
  	
  	add_foreign_key :descriptions_influences, :descriptions , column: :description_id, primary_key: "id"
  	add_foreign_key :descriptions_influences, :influences , column: :influence_id, primary_key: "id"
  	
  	add_foreign_key :descriptions_musics, :descriptions , column: :description_id, primary_key: "id"
  	add_foreign_key :descriptions_musics, :musics , column: :music_id, primary_key: "id"
  	
  	add_foreign_key :flacs, :musics , column: :music_id, primary_key: "id"
  	
  	add_foreign_key :follows, :users , column: :user_id, primary_key: "id"
  	add_foreign_key :follows, :users , column: :follow_id, primary_key: "id"
  	
  	add_foreign_key :friends, :users , column: :user_id, primary_key: "id"
  	add_foreign_key :friends, :users , column: :friend_id, primary_key: "id"

		add_foreign_key :genres_influences, :genres , column: :genre_id, primary_key: "id"
		add_foreign_key :genres_influences, :influences , column: :influence_id, primary_key: "id"

		add_foreign_key :genres_musics, :genres , column: :genre_id, primary_key: "id"
		add_foreign_key :genres_musics, :musics , column: :music_id, primary_key: "id"

		add_foreign_key :gifts, :users , column: :to_user, primary_key: "id"
		add_foreign_key :gifts, :users , column: :from_user, primary_key: "id"

		add_foreign_key :groups_users, :groups , column: :group_id, primary_key: "id"
		add_foreign_key :groups_users, :users , column: :user_id, primary_key: "id"

		add_foreign_key :listenings, :users , column: :user_id, primary_key: "id"
		add_foreign_key :listenings, :musics , column: :music_id, primary_key: "id"

		add_foreign_key :messages, :users , column: :user_id, primary_key: "id"
		add_foreign_key :messages, :users , column: :dest_id, primary_key: "id"

		add_foreign_key :music_notes, :musics , column: :music_id, primary_key: "id"
		add_foreign_key :music_notes, :users , column: :user_id, primary_key: "id"

		add_foreign_key :musics, :users , column: :user_id, primary_key: "id"
		add_foreign_key :musics, :albums , column: :album_id, primary_key: "id"

		add_foreign_key :musics_playlists, :musics , column: :music_id, primary_key: "id"
		add_foreign_key :musics_playlists, :playlists , column: :playlist_id, primary_key: "id"

		add_foreign_key :news, :users , column: :author_id, primary_key: "id"

		add_foreign_key :newstexts, :news , column: :news_id, primary_key: "id"

		add_foreign_key :notifications, :users , column: :user_id, primary_key: "id"

		add_foreign_key :playlists, :users , column: :user_id, primary_key: "id"

		add_foreign_key :propositions, :users , column: :artist_id, primary_key: "id"
		add_foreign_key :propositions, :albums , column: :album_id, primary_key: "id"

		add_foreign_key :purchases, :purchases , column: :user_id, primary_key: "id"

		add_foreign_key :tags, :news , column: :news_id, primary_key: "id"

		add_foreign_key :tweets, :users , column: :user_id, primary_key: "id"

		add_foreign_key :users, :addresses , column: :address_id, primary_key: "id"

		add_foreign_key :votes, :users , column: :user_id, primary_key: "id"
		add_foreign_key :votes, :battles , column: :battle_id, primary_key: "id"
		add_foreign_key :votes, :users , column: :artist_id, primary_key: "id"

		#PACK STYLE TO REMOVE

  	create_table :genres_packs, id: false do |t|
      t.integer :pack_id, :null => false
      t.integer :genre_id, :null => false
    end
		remove_column :packs, :style
  end
end
