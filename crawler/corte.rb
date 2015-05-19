require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Corte < PoderJudicial

	$host = 'http://corte.poderjudicial.cl'
	
	def Search(rut,rut_dv,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Get($host + "/SITCORTEPORWEB/",'Primera')

			#Get("http://corte.poderjudicial.cl/SITCORTEPORWEB/jsp/Menu/Comun/COR_MNU_BlancoAutoconsulta.jsp",'Segunda')

			#Setear Camino
			Get($host + '/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			respuesta = Post($host + '/SITCORTEPORWEB/AtPublicoDAction.do',
				 $host + '/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera',
				{"TIP_Consulta"=> "3", 
				 "TIP_Lengueta"=> "tdNombre",
				 "TIP_Causa"=> " ",
				 "COD_Libro"=> "null",
				 "COD_Corte"=> "0",
				 "COD_LibroCmb"=> "",
				 "ROL_Recurso"=> "",
				 "ERA_Recurso"=> "",
				 "FEC_Desde"=> "29/04/2015",
				 "FEC_Hasta"=> "29/04/2015",
				 "NOM_Consulta"=> nombre.upcase,
				 "APE_Paterno"=> apellido_paterno.upcase,
				 "APE_Materno"=> apellido_materno.upcase,
				 "selConsulta"=> "0",
				 "ROL_Causa"=> "",
				 "ERA_Causa"=> "",
				 "RUC_Era"=> "",
				 "RUC_Tribunal"=> "",
				 "RUC_Numero"=> "",
				 "RUC_Dv"=> "",
				 "irAccionAtPublico"=> "Consulta" })

		getCase(respuesta)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end	

	def getCase(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='divRecursos']/table/tbody/tr")		
		
		#Primer tr es Encabezado Tabla
		rows[1..-1].each_with_index do |row,case_number|

			palabra = "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					palabra += "N° Ingreso: " 
				elsif i == 1
					palabra += "Fecha Ing.: "
				elsif i == 2
					palabra += "Ubicación: "					
				elsif i == 3
					palabra += "Fecha Ub.: "
				elsif i == 4
					palabra += "Corte: "
				elsif i == 5
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

ola = Corte.new
ola.Search("","","","Alvear","Castillo")
#ola.Search('10696737','7','','','')