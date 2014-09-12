json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :link, :description
  json.url notification_url(notification, format: :json)
end
