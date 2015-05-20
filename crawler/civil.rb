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

		return getCases(respuesta)	

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def getCases(respuesta)
		
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCellsAddTabla']/tbody/tr")		
		listaCasos = []

		rows[0..2].each_with_index do |row,case_number|
			caso = Case.new
			puts "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					caso.rol = td.content.strip 
				elsif i == 1
					caso.fecha = td.content.strip
				elsif i == 2
					caso.caratula = td.content.strip					
				elsif i ==3
					caso.tribunal = td.content.strip
				else
					palabra += "?: "
				end
				#palabra += td.content.strip + " "  			
			end
			#puts palabra.to_s
			puts 'ROL:'
			puts caso.rol.to_s
			#Litigantes
			href = row.xpath("td/a").attr('href')
			listaLitigantes = getLitigantes(href,case_number)
			
			listaLitigantes.each do |litigante|
				l = caso.litigantes.build
				l.rut = litigante.rut
				l.persona = litigante.persona
				l.nombre = litigante.nombre
				l.participante = litigante.participante
			end

			listaCasos << caso

		end

		return listaCasos
	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host + href.to_s,'Consultando Litigantes Caso N° ' + case_number.to_s))
		rows = doc.xpath("//*[@id='Litigantes']/table[2]/tbody/tr")
		listaLitigantes = []
		#Litigantes
		puts "Litigantes: "			
		rows[0..-1].each_with_index do |row,i|
			litigante = Litigante.new
			(row.xpath("td"))[0..-1].each_with_index do |td,j| 
				if j == 0
					litigante.participante = td.content.strip
				elsif j == 1
					litigante.rut = td.content.strip
				elsif j == 2
					litigante.persona = td.content.strip
				elsif j ==3
					litigante.nombre = td.content.strip
				else
					puts "\t ?: " + td.content.strip
				end
			end
			listaLitigantes << litigante
		end

		#getRetiros(doc)
		return listaLitigantes
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
