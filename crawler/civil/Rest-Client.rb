require 'rest-client'

response = RestClient.get "http://civil.poderjudicial.cl/CIVILPORWEB/"

cookie = response.cookies
puts cookie

response2 = RestClient.post(
  'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do',
  {:TIP_Consulta=>"3",
	:TIP_Lengueta=>"tdCuatro",
	:SeleccionL=>"0",
	:TIP_Causa=>"",
	:ROL_Causa=>"",
	:ERA_Causa=>"",
	:RUC_Era=>"",
	:RUC_Tribunal=>"3",
	:RUC_Numero=>"",
	:RUC_Dv=>"",
	:FEC_Desde=>"27%2F04%2F2015",
	:FEC_Hasta=>"27%2F04%2F2015",
	:SEL_Litigantes=>"0",
	:RUT_Consulta=>"",
	:RUT_DvConsulta=>"",
	:NOM_Consulta=>"",
	:APE_Paterno=>"",
	:APE_Materno=>"",
	:irAccionAtPublico=>"Consulta"},
  {:Cookie => 'FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Peña Perez; HORA_LOGIN=10:30;JSESSIONID=0000P9W7xpV0GZxIXaROmZL6ib9:-1'}
)

puts response2.code
File.open("Respuesta.html", 'w'){|f| f.write response2.body}
