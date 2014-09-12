json.array!(@newstexts) do |newstext|
  json.extract! newstext, :id, :content, :title, :language, :news_id
  json.url newstext_url(newstext, format: :json)
end
