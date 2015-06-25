require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Laboral < PoderJudicial

	$host_laboral = 'http://laboral.poderjudicial.cl'

	def Search(rut,rut_dv,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Post($host_laboral + '/SITLAPORWEB/InicioAplicacionPortal.do',
				 $host_laboral + '/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp','Primera',
				{"FLG_Autoconsulta" => 1},4)

			#Actualizar Sesión
			#Get($host_laboral + '/SITLAPORWEB/jsp/Menu/Comun/LAB_MNU_BlancoPortal.jsp','Segunda')
			Get($host_laboral + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1/','Tercera',4)

			#Consulta a AtPublicoDAction.do
			respuesta = Post($host_laboral + '/SITLAPORWEB/AtPublicoDAction.do',
				 $host_laboral + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta',
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
				 "COD_Tribunal" => 0},4) #0 Son todos los Tribunales

		return getCase(respuesta)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def getCase(respuesta)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='filaSel']/tbody/tr")		
		listaCasos = []
		
		rows[0..20].each_with_index do |row,case_number|
			caso = Case.new
			info_caso = InfoLaboral.new

			palabra = "\n " + case_number.to_s + ") "			
			row.xpath("td").each_with_index do |td,i|
				if i == 0
					info_caso.rit = td.content.strip
					caso.rol = info_caso.rit
				elsif i == 1
					info_caso.ruc = td.content.strip
				elsif i == 2
					caso.fecha = td.content.strip
				elsif i == 3
					caso.caratula = td.content.strip
				elsif i == 4
					caso.tribunal = td.content.strip
				else
					palabra += "?: "
				end
			end


			#Litigantes
			href = row.xpath("td/a").attr('href')
			listaLitigantes = getLitigantes(href.to_s,case_number)
			
			listaLitigantes.each do |litigante|
				l = caso.litigantes.build
				l.rut = litigante.rut
				l.persona = litigante.persona
				l.nombre = litigante.nombre
				l.participante = litigante.participante
				l.save
			end

			caso.info_type = 'Laboral'

			listaCasos << caso

			GuardarInfoCaso(info_caso, caso,4)

		end

		return listaCasos
	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host_laboral + href.to_s.strip,'Consultando Litigantes Caso N° ' + case_number.to_s,4))
		rows = doc.xpath("//*[@id='Litigantes']/table[2]/tbody/tr")
		listaLitigantes = []

		#Litigantes
		puts "\t \t \t \t " + "Litigantes: "		
		rows.each_with_index do |row,i|
			litigante = Litigante.new
			row.xpath("td").each_with_index do |td,j| 
				if j == 2
					litigante.participante = td.content.strip
				elsif j == 3
					litigante.rut = td.content.strip
				elsif j == 4
					litigante.persona = td.content.strip
				elsif j == 5
					litigante.nombre = td.content.strip
				end
			end
			puts "\t \t \t \t \t " + i.to_s + ") " + litigante.rut + " " + litigante.nombre

			listaLitigantes << litigante
		end
	
		return listaLitigantes
	end

end
