json.array!(@commentaries) do |commentary|
  json.extract! commentary, :id, :author_id, :content
  json.url commentary_url(commentary, format: :json)
end
