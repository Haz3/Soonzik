json.array!(@addresses) do |address|
  json.extract! address, :id, :numberStreet, :complement, :street, :city, :country, :zipcode
  json.url address_url(address, format: :json)
end
