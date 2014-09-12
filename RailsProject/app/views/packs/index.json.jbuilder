json.array!(@packs) do |pack|
  json.extract! pack, :id, :title, :style
  json.url pack_url(pack, format: :json)
end
