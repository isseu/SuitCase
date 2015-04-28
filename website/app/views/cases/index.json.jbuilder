json.array!(@cases) do |case|
  json.extract! case, :id, :rol, :fecha, :tribunal, :caratula, :info_id, :info_type
  json.url case_url(case, format: :json)
end
