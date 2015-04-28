json.array!(@case_records) do |case_record|
  json.extract! case_record, :id, :case_id, :user_id
  json.url case_record_url(case_record, format: :json)
end
