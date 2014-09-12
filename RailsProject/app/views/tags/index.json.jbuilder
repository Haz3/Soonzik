json.array!(@tags) do |tag|
  json.extract! tag, :id, :tag, :news_id
  json.url tag_url(tag, format: :json)
end
