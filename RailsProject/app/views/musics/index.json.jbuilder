json.array!(@musics) do |music|
  json.extract! music, :id, :user_id, :album_id, :title, :duration, :style, :price, :file, :limited
  json.url music_url(music, format: :json)
end
