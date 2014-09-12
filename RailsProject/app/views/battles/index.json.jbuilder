json.array!(@battles) do |battle|
  json.extract! battle, :id, :date_begin, :date_end, :artist_one_id, :artist_two_id
  json.url battle_url(battle, format: :json)
end
