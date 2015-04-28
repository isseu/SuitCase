# encoding: UTF-8
# Crawler
# civil.poderjudicial.com
# corte.poderjudicial.com
# suprema.poderjudicial.com
# civil.poderjudicial.com
require 'nokogiri'
require 'rest-client'

# Aqui guardaremos las cookies
$cookies = {}

def guardarCookies(response)
    response.cookies.each { | k, v |
    	$cookies[k] = v
    }
end 

# Esta consulta podria ser innecesaria si se setean algunas cookies con anterioridad
def getCookiesIniciales
	puts '[+] Obteniendo cookies'
	response = RestClient.get "http://civil.poderjudicial.cl/CIVILPORWEB/"
	#puts response.to_s
	if (response.code == 200)
		puts '[-] Cookies obtenidas: ' + response.cookies.to_s
	    guardarCookies(response)
	else
		puts 'Error'
	end
end

# Actualizamos informacion de la session al lado del servidor
def actualizarSession
	puts '[+] Segunda consulta'
	response = RestClient.get(
		'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1', 
		{ :cookies => $cookies }
	)
	#puts response.to_s
	if (response.code == 200)
		puts '[-] Cookies obtenidas: ' + response.cookies.to_s
	    guardarCookies(response)
	else
		puts 'Error'
	end
end

begin
	# Obtenemos cookies iniciales
	getCookiesIniciales

	# Visitamos web para actualizar cookie session en servidor
	actualizarSession
rescue Exception => e
	puts "[!] Error al intentar hacer consulta: " + e.response
	exit
end

puts '[+] Ejecutando consulta nombre'
puts "[-] Cookies:" + $cookies.to_s

begin
	response = RestClient::Request.execute(:method => :post, :url => 
	  'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do',
	  :headers => {
	  	'Referer' => 'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1',
	  	'User-Agent' =>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
	  },
	  :payload => {   
		    "TIP_Consulta" => 3,
			"TIP_Lengueta" => "tdCuatro",
			"SeleccionL" => 0,
			"TIP_Causa" => "",
			"ROL_Causa" => "",
			"ERA_Causa" => "",
			"RUC_Era" => "",
			"RUC_Tribunal" => 3,
			"RUC_Numero" => "",
			"RUC_Dv" => "",
			"FEC_Desde" => "27/04/2015",
			"FEC_Hasta" => "27/04/2015",
			"SEL_Litigantes" => 0,
			"RUT_Consulta" => "",
			"RUT_DvConsulta" => " ",
			"NOM_Consulta" => "ENRIQUE",
			"APE_Paterno" => "CORREA",
			"APE_Materno" => "",
			"irAccionAtPublico" => "Consulta" },
	  :cookies => $cookies,
	  :timeout => 90000000 # Esto se puede demorar kleta
	)
rescue Exception => e
	puts "[!] Error al intentar hacer consulta: " + e.response
	exit
end

# Guardamos resultado
puts "[+] Cookies devueltas: " + response.cookies.to_s

# Guardamos en un archivo
# Porfavor dentro de la carpeta tmp
puts "[+] Guardando resultado en tmp/resultado.html"
Dir.mkdir('tmp') unless File.exists?('tmp')
File.write('tmp/resultado.html', response.to_str)
