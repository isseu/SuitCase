json.array!(@receptores) do |receptor|
  json.extract! receptor, :id, :info_civil_id, :notebook, :dat, :state
end
