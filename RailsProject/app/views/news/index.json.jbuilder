json.array!(@news) do |news|
  json.extract! news, :id, :title, :date, :author_id
  json.url news_url(news, format: :json)
end
