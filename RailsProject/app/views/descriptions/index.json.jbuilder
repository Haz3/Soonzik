json.array!(@descriptions) do |description|
  json.extract! description, :id, :description, :language
  json.url description_url(description, format: :json)
end
