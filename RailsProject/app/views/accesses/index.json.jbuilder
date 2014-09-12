json.array!(@accesses) do |access|
  json.extract! access, :id, :group_id, :controllerName, :actionName
  json.url access_url(access, format: :json)
end
