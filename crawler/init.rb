# encoding: UTF-8
# Crawler
# civil.poderjudicial.com
# corte.poderjudicial.com
# suprema.poderjudicial.com
# civil.poderjudicial.com
require 'nokogiri'
require 'net/http'
$uri = URI("http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoDAction.do")
$http = Net::HTTP.new("laboral.poderjudicial.cl", 80)
$cookies = {}

def guardarCookies(response)
    all_cookies = response.get_fields('set-cookie')
    cookies_array = Array.new
    all_cookies.each { | cookie |
        cookies_array.push((cookie.split('; ')[0]))
        cook = (cookie.split('; ')[0]).split('=').map { |e| e.strip }
        $cookies[cook[0]] = cook[1]
    }
end 

def recuperarCookies(request)
	request['Cookie'] = $cookies.map{ |k , v| "#{k}=#{v}" }.join('; ')
end 

def getLoginPortal
	request = Net::HTTP::Get.new(URI("http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp"))
	response = $http.request(request)
	puts response.body
	if (response.code == '200')
		guardarCookies(response)
	end
end

def getSessionCookies
	request = Net::HTTP::Post.new(URI("http://laboral.poderjudicial.cl/SITLAPORWEB/InicioAplicacionPortal.do "))
	request.content_type = 'application/x-www-form-urlencoded'
	request.set_form_data( { 'FLG_Autoconsulta' => 1 } )
	response = $http.request(request)
	puts response.body
	if (response.code == '200')
	    guardarCookies(response)
	end
end

getLoginPortal
getSessionCookies

request = Net::HTTP::Post.new($uri)
recuperarCookies(request)
puts $cookies

request.content_type = 'application/x-www-form-urlencoded'
request.set_form_data({   
	    "TIP_Consulta" => 3,
		"TIP_Lengueta" => "tdCuatro",
		"SeleccionL" => "0",
		"TIP_Causa" => "",
		"ROL_Causa" => "",
		"ERA_Causa" => 0,
		"RUC_Era" => "",
		"RUC_Tribunal" => 4,
		"RUC_Numero" => "",
		"RUC_Dv" => "",
		"FEC_Desde" => "20%2F04%2F2015",
		"FEC_Hasta" => "20%2F04%2F2015",
		"SEL_Trabajadores" => 0,
		"RUT_Consulta" => "",
		"RUT_DvConsulta" => "",
		"NOM_Consulta" => "ENRIQUE",
		"APE_Paterno" => "",
		"APE_Materno" => "",
		"GLS_Razon" => "",
		"COD_Tribunal" => 1336,
		"irAccionAtPublico" => "Consulta" })

response = $http.request(request)
puts response.body
