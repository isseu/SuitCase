require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Civil < PoderJudicial

	$host_civil = 'http://civil.poderjudicial.cl'

	def Search(rol,user,rut,nombre,apellido_paterno,apellido_materno,tip_consulta,tip_lengueta,tracking)
		begin
			#Iniciar para Obtener Cookie
			Get($host_civil + "/CIVILPORWEB/",'Primera Consulta',4)

			#Setear Camino
			Get($host_civil +'/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda Consulta',4)

			#Dividir el Rol
			aux = rol.split('-')
			#puts aux[0].to_s.strip + " " + aux[1].to_s.strip + " " + aux[2].to_s.strip

			#Dividir el Rut
			aux2 = rut.split('-')

			#Consulta a AtPublicoDAction.do
			respuesta = Post($host_civil + '/CIVILPORWEB/AtPublicoDAction.do',
				$host_civil +'/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera Consulta',
				{"TIP_Consulta" => tip_consulta,
					"TIP_Lengueta" => tip_lengueta,
					"SeleccionL" => 0,
					"TIP_Causa" => aux[0].to_s.strip,
					"ROL_Causa" => aux[1].to_s.strip,
					"ERA_Causa" => aux[2].to_s.strip,
					"RUC_Era" => "",
					"RUC_Tribunal" => 3,
					"RUC_Numero" => "",
					"RUC_Dv" => "",
					"FEC_Desde" => Time.now.strftime("%d/%m/%Y").to_s,
					"FEC_Hasta" => Time.now.strftime("%d/%m/%Y").to_s,
					"SEL_Litigantes" => 0,
					"RUT_Consulta" => aux2[0].to_s.strip,
					"RUT_DvConsulta" => aux2[1].to_s.strip,
					"NOM_Consulta" => nombre.upcase,
					"APE_Paterno" => apellido_paterno.upcase,
					"APE_Materno" => apellido_materno.upcase,
					"irAccionAtPublico" => "Consulta" },4)

		return getCases(respuesta,user,tracking)
		
		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
		end
	end

	def getCases(respuesta,user,tracking)	
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCellsAddTabla']/tbody/tr")		

		if rows.size > 0
			rows.each_with_index do |row,case_number|
				begin
					caso = Case.new
					info_caso = InfoCivil.new

					row.xpath("td").each_with_index do |td,i|
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
					end

					puts "\t \t \t "  + case_number.to_s + ") Rol: " + caso.rol.to_s

					if not tracking

						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :tribunal => caso.tribunal, :info_type => "InfoCivil")
							puts  "\t \t \t " + '[-] Caso ya Existe'
				    	else 
							
							#Litigantes
							href = row.xpath("td/a").attr('href')
							resp = getLitigantes(href,case_number)
							listaLitigantes = resp[0]
							listaReceptores = resp[1]

							#Colocar Tipo
							caso.info_type = 'InfoCivil'					
						
							saveCase(caso,info_caso,listaLitigantes,listaReceptores,3)
						
						end
					else
						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :tribunal => caso.tribunal, :info_type => "InfoCivil")
							caso = Case.find_by(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :tribunal => caso.tribunal, :info_type => "InfoCivil")

							#Litigantes
							href = row.xpath("td/a").attr('href')

							resp = getLitigantes(href,case_number)
							listaLitigantes = resp[0]
							listaReceptores = resp[1]

							updateLitigantes(listaLitigantes,caso,user)
							updateReceptores(listaReceptores,caso,user)
						end
					end
				rescue Exception => e
					puts "[!] Error al intentar hacer consulta: " + e.to_s
				end	
			end
		end
	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host_civil + href.to_s.strip,'Consultando Litigantes Caso N° ' + case_number.to_s,4))
		rows = doc.xpath("//*[@id='Litigantes']/table[2]/tbody/tr")
		listaLitigantes = []

		#Litigantes
		puts "\t \t \t \t " + "Litigantes: "			
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
					puts "\t \t \t \t ?: " + td.content.strip
				end
			end
			puts "\t \t \t \t \t " + i.to_s + ") " + litigante.rut + " " + litigante.nombre

			listaLitigantes << litigante
		end

		listaReceptores = getRetiros(doc)
		return listaLitigantes, listaReceptores
	end

	def getRetiros(doc)
		rows = doc.xpath("//*[@id='ReceptorDIV']/table[4]/tbody/tr")
		listaReceptores = []

		puts "\t \t \t \t Retiros del Receptor: "			
		rows[0..-1].each_with_index do |row,i|
			receptor = Receptor.new
			auxReceptor = true
			(row.xpath("td")).each_with_index do |td,j| 
				if td.content.strip.include? "no presenta"
					auxReceptor = false
				else
					if j == 0
						receptor.notebook =  td.content.strip 
					elsif j == 1
						receptor.dat =  td.content.strip
					elsif j == 2
						receptor.state = td.content.strip	
					end
				end
			end

			if auxReceptor
				puts "\t \t \t \t \t " + i.to_s + ") " + receptor.dat.to_s + " - " + receptor.state.to_s		
				listaReceptores << receptor
			else
				puts "\t \t \t \t \t No existen Retiros del Receptor" 		
			end
		end

		return listaReceptores
	end
end