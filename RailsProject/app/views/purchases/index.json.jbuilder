json.array!(@purchases) do |purchase|
  json.extract! purchase, :id, :user_id, :typeObj, :obj_id, :date
  json.url purchase_url(purchase, format: :json)
end
