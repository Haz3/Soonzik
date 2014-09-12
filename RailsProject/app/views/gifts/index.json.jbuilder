json.array!(@gifts) do |gift|
  json.extract! gift, :id, :to_user, :from_user, :typeObj, :obj_id
  json.url gift_url(gift, format: :json)
end
