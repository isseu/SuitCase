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
	response = RestClient::Request.execute(:method => :post, :url => 
	  'http://laboral.poderjudicial.cl/SITLAPORWEB/InicioAplicacionPortal.do',
	  :headers => {
	  	'Referer' => 'http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp',
	  	'User-Agent' =>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
	  },
	  :payload => {   
			"FLG_Autoconsulta" => 1},
	  :timeout => 90000000 # Esto se puede demorar kleta
	)
	#puts response.to_s
	if (response.code == 200)
		puts '[-] Cookies obtenidas: ' + response.cookies.to_s
	    guardarCookies(response)
	else
		puts 'Error'
	end
end

# Actualizamos informacion de la session al lado del servidor
def actualizarSession(url,iteracion)
	puts '[+] ' + iteracion +' consulta'
	response = RestClient.get(url,{ :cookies => $cookies })

	if (response.code == 200)
		puts '[-] Cookies obtenidas: ' + response.cookies.to_s
	    guardarCookies(response)
	    puts '[-] Cookies Totales: ' + $cookies.to_s
	else
		puts 'Error'
	end
end

begin
	# Obtenemos cookies iniciales
	getCookiesIniciales

	# Vamos al Primer Recorrido de la Pagina
	#actualizarSession('http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/Menu/Comun/LAB_MNU_BlancoPortal.jsp','Segunda')

	actualizarSession('http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1/','Tercera')

rescue Exception => e
	puts "[!] Error al intentar hacer consulta: " + e.resposnse
	exit
end


#Consulta
puts '[+] Ejecutando consulta nombre'
begin
	response = RestClient::Request.execute(:method => :post, :url => 
	  'http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoDAction.do',
	  :headers => {
	  	'Referer' => 'http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1',
	  	'User-Agent' =>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
	  },
	  :payload => {   
			"TIP_Consulta" => 3,
			"TIP_Lengueta" => "tdCuatro",
			"SeleccionL" => 0,
			"TIP_Causa" => "",
			"ROL_Causa" => "",
			"ERA_Causa" => 0,
			"RUC_Era" => "",
			"RUC_Tribunal" => 4,
			"RUC_Numero" => "",
			"RUC_Dv" => "",
			"FEC_Desde" => "27/04/2015",
			"FEC_Hasta" => "27/04/2015",
			"SEL_Trabajadores" => 0,
			"RUT_Consulta" => "",
			"RUT_DvConsulta" => "",
			"irAccionAtPublico" => "Consulta",
			"NOM_Consulta" => "",
			"APE_Paterno" => "ALVEAR",
			"APE_Materno" => "",
			"GLS_Razon" => "",
			"COD_Tribunal" => 1336},
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
puts "[+] Guardando resultado en tmp/Resultado_Laboral.html"
Dir.mkdir('tmp') unless File.exists?('tmp')
File.write('tmp/Resultado_Laboral.html', response.to_str)