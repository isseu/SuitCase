json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :text, :read, :url
  json.url notification_url(notification, format: :json)
end
