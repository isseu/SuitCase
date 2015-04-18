json.array!(@clients) do |client|
  json.extract! client, :id, :name, :rut, :first_lastname, :second_lastname, :is_company
  json.url client_url(client, format: :json)
end
