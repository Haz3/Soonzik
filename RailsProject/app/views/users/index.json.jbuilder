json.array!(@users) do |user|
  json.extract! user, :id, :email, :password, :salt, :fname, :lname, :username, :birthday, :image, :description, :phoneNumber, :adress_id, :facebook, :twitter, :googlePlus, :signin, :idAPI, :secureKey, :activated, :newsletter, :language
  json.url user_url(user, format: :json)
end
