json.array!(@propositions) do |proposition|
  json.extract! proposition, :id, :artist_id, :album_id, :state, :date_posted
  json.url proposition_url(proposition, format: :json)
end
