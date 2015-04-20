# encoding: UTF-8
# Crawler
#civil.poderjudicial.com
#corte.poderjudicial.com
#suprema.poderjudicial.com
#civil.poderjudicial.com
require 'nokogiri'
require 'rubygems'
require 'restclient'

BASE_CIVIL_URL = "http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do"

name_term = "GERONIMO"

if page = RestClient.post(BASE_CIVIL_URL, {
	'TIP_Consulta'=> '3',
	'TIP_Lengueta'=> 'tdCuatro',
	'SeleccionL'=>'0',
	'TIP_Causa'=>'',
	'ROL_Causa'=>'',
	'ERA_Causa'=>'',
	'RUC_Era'=>'',
	'RUC_Tribunal'=>'3',
	'RUC_Numero'=>'',
	'RUC_Dv'=>'',
	'FEC_Desde'=>'19/04/2015',
	'FEC_Hasta'=>'19/04/2015',
	'SEL_Litigantes'=>'0',
	'RUT_Consulta'=>'',
	'RUT_DvConsulta'=>'',
	'NOM_Consulta'=>name_term, 
	'APE_Paterno'=>'',
	'APE_Materno'=>'',
	'irAccionAtPublico'=>'Consulta'})
	puts "#{BASE_CIVIL_URL}"
	puts "Success finding search term: #{name_term}"
	File.open("data-hold/fecimg-#{name_term}.html", 'w'){|f| f.write page.body}

	npage = Nokogiri::HTML(page)
	rows = npage.css('table#contentCellsAddTabla tbody tr')
  	puts "#{rows.length} rows"

  	rows.each do |row|
    puts row.css('td').map{|td| td.text}.join(', ')
  end
  
end  