
require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Suprema < PoderJudicial

	$host_suprema = 'http://suprema.poderjudicial.cl'

	def Search(rol,user,rut,nombre,apellido_paterno,apellido_materno,tip_consulta,tip_lengueta,tracking)
		begin

			Get($host_suprema + '/SITSUPPORWEB/','Primera',4)

			Post($host_suprema + '/SITSUPPORWEB/InicioAplicacion.do','http://suprema.poderjudicial.cl/SITSUPPORWEB/', 'Segunda',
				{ "username" => "autoconsulta",
				  "password" => "amisoft",
				  "Aceptar" => "Ingresar"
					},4)

			#Get($host_suprema + '/SITSUPPORWEB/jsp/Menu/Comun/SUP_MNU_BlancoAutoconsulta.jsp', 'Tercera')

			Get($host_suprema + '/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta',4)

			#Dividir el Rol
			aux = rol.split('-')
		
			#Dividir el Rut
			aux2 = rut.split('-')

			#Consulta a AtPublicoDAction.do			
			respuesta = Post($host_suprema + '/SITSUPPORWEB/AtPublicoDAction.do',
				$host_suprema + '/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Quinta',
				{"TIP_Consulta" => tip_consulta,
				 "TIP_Lengueta" => tip_lengueta,
				 "SeleccionL" => 0,
				 "COD_Libro" => 0,
				 "COD_Corte" => 1,
				 "COD_Corte_AP" => 0,
				 "ROL_Recurso" => aux[0].to_s.strip,
				 "ERA_Recurso" => aux[1].to_s.strip,
				 "FEC_Desde" => Time.now.strftime("%d/%m/%Y").to_s,
				 "FEC_Hasta" => Time.now.strftime("%d/%m/%Y").to_s,
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
				 "RUC_Numero" => aux2[0].to_s,
				 "RUC_Dv" => aux2[1].to_s,
				 "COD_CorteAP_Pra" => 0,
				 "GLS_Caratulado_Recurso" => "",
				 "irAccionAtPublico" =>"Consulta"},4)

		return getCases(respuesta,user,tracking)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end


	def getCases(respuesta,user,tracking)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCells']/tbody/tr")	

		if rows.size > 0
			rows[0..-1].each_with_index do |row,case_number|
				begin
					caso = Case.new
					info_caso = InfoSuprema.new

					palabra = "\n " + case_number.to_s + ") "			
					row.xpath("td").each_with_index do |td,i|
						
						if i == 0
							caso.rol = td.content.strip
						elsif i == 1
							info_caso.tipo_recurso = td.content.strip
						elsif i == 2
							caso.fecha = td.content.strip
						elsif i == 3
							info_caso.ubicacion = td.content.strip
						elsif i == 4
							info_caso.fecha_ubicacion = td.content.strip
						elsif i == 5
							info_caso.corte = td.content.strip
						elsif i == 6
							caso.caratula = td.content.strip
						else
							palabra += "?: "
						end
					end

					puts "\t \t \t "  + case_number.to_s + ") Rol: " + caso.rol.to_s

					if not tracking

						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoSuprema")
							puts  "\t \t \t " + '[-] Caso ya Existe'
				    	else 
							#Litigantes
							href = row.xpath("td/a").attr('href')
							listaLitigantes = getLitigantes(href,case_number)

							caso.info_type = 'InfoSuprema'

							saveCase(caso,info_caso,listaLitigantes,nil,3)
						end	
					else
						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoSuprema")
							caso = Case.find_by(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoSuprema")

							#Litigantes
							href = row.xpath("td/a").attr('href')
							listaLitigantes = getLitigantes(href,case_number)

							updateLitigantes(listaLitigantes,caso,user)
						end
					end

				rescue Exception => e
					puts "[!] Error adentro: " + e.to_s
				end
			end
		end

	end

	def getLitigantes(href,case_number)
		doc = Nokogiri::HTML(Get($host_suprema + href.to_s.strip,'Consultando Litigantes Caso N° ' + case_number.to_s,4))
		rows = doc.xpath("//*[@id='contentCellsLitigantes']/tbody/tr")
		listaLitigantes = []
		
		#Litigantes
		puts "\t \t \t \t " + "Litigantes: "
		rows.each_with_index do |row,i|
			litigante = Litigante.new
			row.xpath("td").each_with_index do |td,j| 
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
			puts "\t \t \t \t \t " + i.to_s + ") " + litigante.rut + " " + litigante.nombre

			listaLitigantes << litigante
		end

		return listaLitigantes
	end

end

