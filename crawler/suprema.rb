
require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Suprema < PoderJudicial

	$host = 'http://suprema.poderjudicial.cl'

	def Search(rut,rut_dv,nombre,apellido_paterno,apellido_materno)
		begin

			Get($host + '/SITSUPPORWEB/','Primera')

			Post($host + '/SITSUPPORWEB/InicioAplicacion.do','http://suprema.poderjudicial.cl/SITSUPPORWEB/', 'Segunda',
				{ "username" => "autoconsulta",
				  "password" => "amisoft",
				  "Aceptar" => "Ingresar"
					})

			#Get($host + '/SITSUPPORWEB/jsp/Menu/Comun/SUP_MNU_BlancoAutoconsulta.jsp', 'Tercera')

			Get($host + '/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta')

			#Consulta a AtPublicoDAction.do			
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			respuesta = Post($host + '/SITSUPPORWEB/AtPublicoDAction.do',
				$host + '/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Quinta',
				{"TIP_Consulta" => 3,
				 "TIP_Lengueta" => "tdNombre",
				 "SeleccionL" => 0,
				 "COD_Libro" => 0,
				 "COD_Corte" => 1,
				 "COD_Corte_AP" => 0,
				 "ROL_Recurso" => "",
				 "ERA_Recurso" => "",
				 "FEC_Desde" => "28/04/2015",
				 "FEC_Hasta" => "28/04/2015",
				 "TIP_Litigante" => 999,
				 "TIP_Persona" => "N",
				 "APN_Nombre" => nombre.upcase,
				 "APE_Paterno" => apellido_paterno.upcase,
				 "APE_Materno" => apellido_materno.upcase,
				 "COD_CorteAP_Sda" => 0,
				 "COD_Libro_AP" => 0,
				 "ROL_Recurso_AP" => "",
				 "ERA_Recurso_AP" => "",
				 "selConsulta" => 0,
				 "ROL_Causa" => "",
				 "ERA_Causa" => "",
				 "RUC_Era" => "",
				 "RUC_Tribunal" => "",
				 "RUC_Numero" => rut.to_s,
				 "RUC_Dv" => rut_dv.to_s,
				 "COD_CorteAP_Pra" => 0,
				 "GLS_Caratulado_Recurso" => "",
				 "irAccionAtPublico" =>"Consulta"})

			getCase(respuesta)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end


	def getCase(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCells']/tbody/tr")		
		
		rows[0..-1].each_with_index do |row,case_number|

			palabra = "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					palabra += "N° Ingreso: " 
				elsif i == 1
					palabra += "Tipo Recurso: "
				elsif i == 2
					palabra += "Fecha Ing.: "					
				elsif i == 3
					palabra += "Ubicación: "
				elsif i == 4
					palabra += "Fecha Ub.: "
				elsif i == 5
					palabra += "Corte: "					
				elsif i == 6
					palabra += "Caratulado: "
				else
					palabra += "?: "
				end
				palabra += td.content.strip + " "  			
			end
			puts palabra.to_s
		end
	end

end

test = Suprema.new
test.Search('','','','Alvear','Castillo')
