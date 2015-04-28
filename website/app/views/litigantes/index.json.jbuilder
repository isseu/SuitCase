json.array!(@litigantes) do |litigante|
  json.extract! litigante, :id, :case_id, :participante, :rut, :persona, :nombre
  json.url litigante_url(litigante, format: :json)
end
