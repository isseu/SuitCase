# encoding: UTF-8
# Crawler
#civil.poderjudicial.com
#corte.poderjudicial.com
#suprema.poderjudicial.com
#civil.poderjudicial.com
require 'nokogiri'
require 'rubygems'
require 'restclient'

REQUEST_URL = "http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do"

name_term = "GERONIMO"
lastname_term="ALVEAR"

initialize_session = RestClient.get("http://civil.poderjudicial.cl/CIVILPORWEB")
query_cookie = initialize_session.cookies
cookie_hash = query_cookie['JSESSIONID']
puts cookie_hash
cookie = {:SESSION_ID => cookie_hash}
puts cookie
hora_login = query_cookie['HORA_LOGIN']

headers= 
{
	'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	'Accept-Encoding' => 'gzip, deflate',
	'Accept-Language' => 'es-419,es;q=0.8',
	'Cache-Control' => 'max-age=0',
	'Connection' => 'keep-alive',
	'Content-Length' => '296',
	'Content-Type' => 'application/x-www-form-urlencoded',
	'Cookie' => 'FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Peña Perez; HORA_LOGIN=07:09; JSESSIONID=0000jNi37ufi5--ZZVULLC6mXip:-1',
	'Host' => 'civil.poderjudicial.cl',
	'Origin' => 'http://civil.poderjudicial.cl',
	'Referer' => 'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1',
	'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/41.0.2272.76 Chrome/41.0.2272.76 Safari/537.36'
}

if page = RestClient.post(REQUEST_URL, 
		{
		'TIP_Consulta' => '3',
		'TIP_Lengueta' => 'tdCuatro',
		'SeleccionL' => '0',
		'TIP_Causa' => '',
		'ROL_Causa' => '',
		'ERA_Causa' => '0',
		'RUC_Era' => '',
		'RUC_Tribunal' => '4',
		'RUC_Numero' => '',
		'RUC_Dv' => '',
		'FEC_Desde' => '20%2F04%2F2015',
		'FEC_Hasta' => '20%2F04%2F2015',
		'SEL_Trabajadores' => '0',
		'RUT_Consulta' => '',
		'RUT_DvConsulta' => '',
		'irAccionAtPublico' => 'Consulta',
		'NOM_Consulta' => '',
		'APE_Paterno' => '#{lastname_term}',
		'APE_Materno' => '',
		},headers)

	puts "#{REQUEST_URL}"
	puts "Success finding search term: #{name_term}"
	File.open("data-hold/fecimg-#{name_term}.html", 'w'){|f| f.write page.body}

	npage = Nokogiri::HTML(page)
	rows = npage.css('table#contentCellsAddTabla tbody tr')
  	puts "#{rows.length} rows"

  	rows.each do |row|
    	puts row.css('td').map{|td| td.text}.join(', ')
  	end
  
end  