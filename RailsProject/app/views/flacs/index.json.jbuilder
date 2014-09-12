json.array!(@flacs) do |flac|
  json.extract! flac, :id, :music_id, :file
  json.url flac_url(flac, format: :json)
end
