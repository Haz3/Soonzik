json.array!(@concerts) do |concert|
  json.extract! concert, :id, :user_id, :planification, :address_id, :url
  json.url concert_url(concert, format: :json)
end
