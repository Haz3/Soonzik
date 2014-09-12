json.array!(@genres) do |genre|
  json.extract! genre, :id, :style_name, :color_name, :color_hexa
  json.url genre_url(genre, format: :json)
end
