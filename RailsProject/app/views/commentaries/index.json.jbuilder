json.array!(@commentaries) do |commentary|
  json.extract! commentary, :id, :author_id, :content, :create_at
  json.url commentary_url(commentary, format: :json)
end
