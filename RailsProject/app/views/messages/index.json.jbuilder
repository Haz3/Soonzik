json.array!(@messages) do |message|
  json.extract! message, :id, :msg, :user_id, :dest_id, :session
  json.url message_url(message, format: :json)
end
