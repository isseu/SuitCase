require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Laboral < PoderJudicial

	$host_laboral = 'http://laboral.poderjudicial.cl'

	def Search(rol,user,rut,nombre,apellido_paterno,apellido_materno,tip_consulta,tip_lengueta,tracking)
		begin
			#Iniciar para Obtener Cookie
			Post($host_laboral + '/SITLAPORWEB/InicioAplicacionPortal.do',
				 $host_laboral + '/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp','Primera',
				{"FLG_Autoconsulta" => 1},4)

			#Actualizar Sesión
			#Get($host_laboral + '/SITLAPORWEB/jsp/Menu/Comun/LAB_MNU_BlancoPortal.jsp','Segunda')
			Get($host_laboral + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1/','Tercera',4)

			#Dividir el Rol
			aux = rol.split('-')
		
			#Dividir el Rut
			aux2 = rut.split('-')

			#Consulta a AtPublicoDAction.do
			respuesta = Post($host_laboral + '/SITLAPORWEB/AtPublicoDAction.do',
				 $host_laboral + '/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta',
				{"TIP_Consulta" => tip_consulta,
				 "TIP_Lengueta" => tip_lengueta,
				 "SeleccionL" => 0,
				 "TIP_Causa" => aux[0].to_s.strip,
				 "ROL_Causa" => aux[1].to_s.strip,
				 "ERA_Causa" => aux[2].to_s.strip,
				 "RUC_Era" => "",
				 "RUC_Tribunal" => 4,
				 "RUC_Numero" => "",
				 "RUC_Dv" => "",
				 "FEC_Desde" => Time.now.strftime("%d/%m/%Y").to_s,
				 "FEC_Hasta" => Time.now.strftime("%d/%m/%Y").to_s,
				 "SEL_Trabajadores" => 0,
				 "RUT_Consulta" => aux[0].to_s,
				 "RUT_DvConsulta" => aux[1].to_s,
				 "irAccionAtPublico" => "Consulta",
				 "NOM_Consulta" => nombre.upcase,
				 "APE_Paterno" => apellido_paterno.upcase,
				 "APE_Materno" => apellido_materno.upcase,
				 "GLS_Razon" => "",
				 "COD_Tribunal" => 0},4) #0 Son todos los Tribunales

		return getCases(respuesta,user,tracking)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def getCases(respuesta,user,tracking)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='filaSel']/tbody/tr")		
		
		if rows.size > 0
			rows[0..-1].each_with_index do |row,case_number|
				begin	
					caso = Case.new
					info_caso = InfoLaboral.new

					palabra = "" 	
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

					puts "\t \t \t "  + case_number.to_s + ") Rol: " + caso.rol.to_s

					if not tracking

						#Litigantes
						href = row.xpath("td/a").attr('href')
						listaLitigantes = getLitigantes(href.to_s,case_number)

						caso.info_type = 'InfoLaboral'

						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula,:tribunal => caso.tribunal,:info_type => "InfoLaboral")
							puts  "\t \t \t " + '[-] Caso ya Existe'
				    	else 
							saveCase(caso,info_caso,listaLitigantes,3)
						end

					else
						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula,:tribunal => caso.tribunal,:info_type => "InfoLaboral")
							caso = Case.find_by(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula,:tribunal => caso.tribunal,:info_type => "InfoLaboral")

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
