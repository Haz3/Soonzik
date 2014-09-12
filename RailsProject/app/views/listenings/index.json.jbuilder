json.array!(@listenings) do |listening|
  json.extract! listening, :id, :user_id, :music_id, :when, :latitude, :longitude
  json.url listening_url(listening, format: :json)
end
