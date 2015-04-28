json.array!(@possible_names) do |possible_name|
  json.extract! possible_name, :id, :user_id, :name, :first_lastname, :second_lastname
  json.url possible_name_url(possible_name, format: :json)
end
