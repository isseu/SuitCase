require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Civil < PoderJudicial

	$host = 'http://civil.poderjudicial.cl'

	def Search(rut,rut_dv,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Get($host + "/CIVILPORWEB/",'Primera Consulta')

			#Setear Camino
			Get($host +'/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda Consulta')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			respuesta = Post($host + '/CIVILPORWEB/AtPublicoDAction.do',
				$host +'/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera Consulta',
				{"TIP_Consulta" => 3,
					"TIP_Lengueta" => "tdCuatro",
					"SeleccionL" => 0,
					"TIP_Causa" => "",
					"ROL_Causa" => "",
					"ERA_Causa" => "",
					"RUC_Era" => "",
					"RUC_Tribunal" => 3,
					"RUC_Numero" => "",
					"RUC_Dv" => "",
					"FEC_Desde" => "15/05/2015",
					"FEC_Hasta" => "15/05/2015",
					"SEL_Litigantes" => 0,
					"RUT_Consulta" => rut.to_s,
					"RUT_DvConsulta" => rut_dv.to_s,
					"NOM_Consulta" => nombre.upcase,
					"APE_Paterno" => apellido_paterno.upcase,
					"APE_Materno" => apellido_materno.upcase,
					"irAccionAtPublico" => "Consulta" })

		getCase(respuesta)	

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def getCase(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCellsAddTabla']/tbody/tr")		
		
		rows[0..-1].each_with_index do |row,case_number|

			palabra = "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					palabra += "Rol: " 
				elsif i == 1
					palabra += "Fecha: "
				elsif i == 2
					palabra += "Caratulado: "					
				elsif i ==3
					palabra += "Tribunal: "
				else
					palabra += "?: "
				end
				palabra += td.content.strip + " "  			
			end
			puts palabra.to_s


			#Litigantes
			href = row.xpath("td/a").attr('href')
			getLitigantes(href,case_number)
		end
	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host + href.to_s,'Consultando Litigantes Caso N° ' + case_number.to_s))
		rows = doc.xpath("//*[@id='Litigantes']/table[2]/tbody/tr")

		#Litigantes
		puts " Litigantes: "			
		rows[0..-1].each_with_index do |row,i|
			(row.xpath("td"))[0..-1].each_with_index do |td,j| 
				if j == 0
					puts "\t Participante: " + td.content.strip
				elsif j == 1
					puts "\t Rut: " + td.content.strip
				elsif j == 2
					puts "\t Persona: " + td.content.strip		
				elsif j ==3
					puts "\t Nombre: " + td.content.strip
				else
					puts "\t ?: " + td.content.strip
				end
			end
			puts ""
		end

		getRetiros(doc)
	end

	def getRetiros(doc)
		rows = doc.xpath("//*[@id='ReceptorDIV']/table[4]/tbody/tr")
		puts " Retiros del Receptor: "			
		rows[0..-1].each_with_index do |row,i|
			puts "\t Receptor N° " + i.to_s
			(row.xpath("td"))[0..-1].each_with_index do |td,j| 
				if j == 0
					puts "\t\t Cuaderno: " + td.content.strip 
				elsif j == 1
					puts "\t\t Datos del Retiro: " + td.content.strip
				elsif j == 2
					puts "\t\t Estado: " + td.content.strip	
				else
					puts "\t\t ?: " + td.content.strip
				end
			end
		end
	end
end

ola = Civil.new
ola.Search('10696737','7','','','')
