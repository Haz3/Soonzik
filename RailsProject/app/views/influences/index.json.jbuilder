json.array!(@influences) do |influence|
  json.extract! influence, :id, :name
  json.url influence_url(influence, format: :json)
end
