require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Laboral < PoderJudicial

	$host = 'http://laboral.poderjudicial.cl'

	def Search(rut,rut_dv,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Post($host + '/SITLAPORWEB/InicioAplicacionPortal.do',
				 $host + '/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp','Primera',
				{"FLG_Autoconsulta" => 1})

			#Actualizar Sesión
			#Get($host + '/SITLAPORWEB/jsp/Menu/Comun/LAB_MNU_BlancoPortal.jsp','Segunda')
			Get($host + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1/','Tercera')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			respuesta = Post($host + '/SITLAPORWEB/AtPublicoDAction.do',
				 $host + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta',
				{"TIP_Consulta" => 3,
				 "TIP_Lengueta" => "tdCuatro",
				 "SeleccionL" => 0,
				 "TIP_Causa" => "",
				 "ROL_Causa" => "",
				 "ERA_Causa" => 0,
				 "RUC_Era" => "",
				 "RUC_Tribunal" => 4,
				 "RUC_Numero" => "",
				 "RUC_Dv" => "",
				 "FEC_Desde" => Time.now.strftime("%d/%m/%Y").to_s,
				 "FEC_Hasta" => Time.now.strftime("%d/%m/%Y").to_s,
				 "SEL_Trabajadores" => 0,
				 "RUT_Consulta" => rut.to_s,
				 "RUT_DvConsulta" => rut_dv.to_s,
				 "irAccionAtPublico" => "Consulta",
				 "NOM_Consulta" => nombre.upcase,
				 "APE_Paterno" => apellido_paterno.upcase,
				 "APE_Materno" => apellido_materno.upcase,
				 "GLS_Razon" => "",
				 "COD_Tribunal" => 0}) #0 Son todos los Tribunales

		getCase(respuesta)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def getCase(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='filaSel']/tbody/tr")		
		
		rows.each_with_index do |row,case_number|

			palabra = "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					palabra += "Rit: " 
				elsif i == 1
					palabra += "Ruc: "
				elsif i == 2
					palabra += "Fecha Ing.: "					
				elsif i == 3
					palabra += "Caratulado: "
				elsif i == 4
					palabra += "Tribunal: "
				else
					palabra += "?: "
				end
				palabra += td.content.strip + " "  			
			end
			puts palabra.to_s
		end
	end
end
