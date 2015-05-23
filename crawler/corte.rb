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
				 "FEC_Desde"=> Time.now.strftime("%d/%m/%Y").to_s,
				 "FEC_Hasta"=> Time.now.strftime("%d/%m/%Y").to_s,
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

		return getCases(respuesta)


		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end	

	def getCases(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='divRecursos']/table/tbody/tr")		
		listaCasos = []
		
		#Primer tr es Encabezado Tabla
		rows[1..20].each_with_index do |row,case_number|
			caso = Case.new
			info_caso = InfoCorte.new(case_id: caso.id)
			palabra = "\n " + case_number.to_s + ") "			
			(row.xpath("td"))[0..-1].each_with_index do |td,i|
				if i == 0
					info_caso.numero_ingreso = td.content.strip
				elsif i == 1
					caso.fecha = td.content.strip
				elsif i == 2
					info_caso.ubicacion = td.content.strip
				elsif i == 3
					info_caso.fecha_ubicacion = td.content.strip
				elsif i == 4
					info_caso.corte = td.content.strip
				elsif i == 5
					caso.caratula = td.content.strip
				else
					palabra += "?: "
				end
			end
			#puts palabra.to_s

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

			##guardar la informacion del caso
			#info_caso.case_id = caso.id
			#if InfoCorte.exists?(:ruc => info_caso.ruc)
			#	puts 'caso existe'
			#else
			#	info_caso.save
			#end

			listaCasos << caso

		end
		return listaCasos
	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host + href.to_s,'Consultando Litigantes Caso N° ' + case_number.to_s))
		rows = doc.xpath("//*[@id='divLitigantes']/table[2]/tbody/tr")
		listaLitigantes = []
		#Litigantes
		puts "Litigantes: "			
		rows.each_with_index do |row,i|
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
end
