json.array!(@albums) do |album|
  json.extract! album, :id, :user_id, :title, :style, :price, :file, :yearProd
  json.url album_url(album, format: :json)
end
