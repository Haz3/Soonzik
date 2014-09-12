json.array!(@album_notes) do |album_note|
  json.extract! album_note, :id, :user_id, :album_id, :value
  json.url album_note_url(album_note, format: :json)
end
