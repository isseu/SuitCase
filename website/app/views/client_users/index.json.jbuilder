json.array!(@client_users) do |client_user|
  json.extract! client_user, :id, :user_id, :client_id
  json.url client_user_url(client_user, format: :json)
end
