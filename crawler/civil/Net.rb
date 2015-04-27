require 'net/http'

http = Net::HTTP.new("civil.poderjudicial.cl",80)
path = '/CIVILPORWEB/';
=begin
resp = http.get(path, nil) 
cook = resp.response['set-cookie'].split('; ')[0]
cook= 'FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Peña Perez; HORA_LOGIN=10:30;'+cook
puts cook


all_cookies = resp.get_fields('set-cookie')
cookies_array = Array.new
all_cookies.each { | cookie |
	cookies_array.push(cookie.split('; ')[0])
}
cookies = cookies_array.join('; ')
puts cookies

headers = 
	{'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	  'Accept-Encoding' => 'gzip, deflate',
	  'Content-Type' => 'application/x-www-form-urlencoded',
	  'Host' => 'civil.poderjudicial.cl',
	  'Origin' => 'http://civil.poderjudicial.cl',
	  'Referer' => 'http://civil.poderjudicial.cl/CIVILPORWEB/',
	  'User-Agent' => "Ruby/#{RUBY_VERSION}",
	  'Cookie' => cookies
	}
=end
#Aca Funciona

head = {'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
	  'Accept-Encoding' => 'gzip, deflate',
	  'Content-Type' => 'application/x-www-form-urlencoded',
	  'Host' => 'civil.poderjudicial.cl',
	  'Origin' => 'http://civil.poderjudicial.cl',
	  'Referer' => 'http://civil.poderjudicial.cl/CIVILPORWEB/',
	  'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36',
	  'Cookie' => 'FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Peña Perez; HORA_LOGIN=10:30;JSESSIONID=0000P9W7xpV0GZxIXaROmZL6ib9:-1'
	}

post_data = URI.encode_www_form({"TIP_Consulta"=>"3",
	"TIP_Lengueta"=>"tdCuatro",
	"SeleccionL"=>"0",
	"TIP_Causa"=>"",
	"ROL_Causa"=>"",
	"ERA_Causa"=>"",
	"RUC_Era"=>"",
	"RUC_Tribunal"=>"3",
	"RUC_Numero"=>"",
	"RUC_Dv"=>"",
	"FEC_Desde"=>"27/04/2015",
	"FEC_Hasta"=>"27/04/2015",
	"SEL_Litigantes"=>"0",
	"RUT_Consulta"=>"",
	"RUT_DvConsulta"=>"",
	"NOM_Consulta"=>"",
	"APE_Paterno"=>"ALVEAR",
	"APE_Materno"=>"",
	"irAccionAtPublico"=>"Consulta"})

http2 = Net::HTTP.new("civil.poderjudicial.cl",80)

path = '/CIVILPORWEB/AtPublicoDAction.do'
response = http2.post(path, 
	post_data,
	head)

File.open("R-Net.txt", 'w'){|f| f.write response.body}	