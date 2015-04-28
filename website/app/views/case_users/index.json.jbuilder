json.array!(@case_users) do |case_user|
  json.extract! case_user, :id, :case_id, :user_id
  json.url case_user_url(case_user, format: :json)
end
