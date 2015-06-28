json.count @cases.count
json.total_count @cases.count

json.records(@cases) do |cas|
  json.rol '<a href="' + case_url(cas) + '">' + cas.rol + '</a>'
  json.fecha date_format( cas.fecha )
  json.extract! cas, :id, :tribunal, :caratula, :info_id
  json.set! 'portal', cas.info_type
  json.acciones render partial: 'shared/actions_case.html.erb',
                       locals: {
                           data: cas,
                       }
  json.url case_url(cas, format: :json)
end
