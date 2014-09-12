json.array!(@music_notes) do |music_note|
  json.extract! music_note, :id, :user_id, :album_id, :value
  json.url music_note_url(music_note, format: :json)
end
