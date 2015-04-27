require 'restclient'

REQUEST_URL = "http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do"

name_term = 'dan'

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
		"FEC_Desde"=>"27%2F04%2F2015",
		"FEC_Hasta"=>"27%2F04%2F2015",
		"SEL_Litigantes"=>"0",
		"RUT_Consulta"=>"",
		"RUT_DvConsulta"=>"",
		"NOM_Consulta"=>"",
		"APE_Paterno"=>"AGUIRRE",
		"APE_Materno"=>"",
		"irAccionAtPublico"=>"Consulta"})

if page = RestClient.post(REQUEST_URL, {"TIP_Consulta"=>"3",
		"TIP_Lengueta"=>"tdCuatro",
		"SeleccionL"=>"0",
		"TIP_Causa"=>"",
		"ROL_Causa"=>"",
		"ERA_Causa"=>"",
		"RUC_Era"=>"",
		"RUC_Tribunal"=>"3",
		"RUC_Numero"=>"",
		"RUC_Dv"=>"",
		"FEC_Desde"=>"27%2F04%2F2015",
		"FEC_Hasta"=>"27%2F04%2F2015",
		"SEL_Litigantes"=>"0",
		"RUT_Consulta"=>"",
		"RUT_DvConsulta"=>"",
		"NOM_Consulta"=>"",
		"APE_Paterno"=>"AGUIRRE",
		"APE_Materno"=>"",
		"irAccionAtPublico"=>"Consulta"})
  puts "Success finding search term: #{name_term}"
  File.open("fecimg.html", 'w'){|f| f.write page.body}

end  