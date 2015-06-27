require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Corte < PoderJudicial

	$host_corte = 'http://corte.poderjudicial.cl'
	
	def Search(rol,user,rut,nombre,apellido_paterno,apellido_materno,tip_consulta,tip_lengueta,tracking)
		begin
			#Iniciar para Obtener Cookie
			Get($host_corte + "/SITCORTEPORWEB/",'Primera',4)

			#Get("http://corte.poderjudicial.cl/SITCORTEPORWEB/jsp/Menu/Comun/COR_MNU_BlancoAutoconsulta.jsp",'Segunda')

			#Setear Camino
			Get($host_corte + '/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda',4)

			#Dividir el Rol
			aux = rol.split('-')
			#puts aux[1].to_s + " " + aux[2].to_s

			#Consulta a AtPublicoDAction.do
			respuesta = Post($host_corte + '/SITCORTEPORWEB/AtPublicoDAction.do',
				 $host_corte + '/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera',
				{"TIP_Consulta"=> tip_consulta, 
				 "TIP_Lengueta"=> tip_lengueta.to_s,
				 "TIP_Causa"=> " ",
				 "COD_Libro"=> "",
				 "COD_Corte"=> "0",
				 "COD_LibroCmb"=> "",
				 "ROL_Recurso"=> aux[1].to_s.strip,
				 "ERA_Recurso"=> aux[2].to_s.strip,
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
				 "irAccionAtPublico"=> "Consulta"},4)

		return getCases(respuesta,user,tracking)


		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end	

	def getCases(respuesta,user,tracking)
		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='divRecursos']/table/tbody/tr")				

		#Primer tr es Encabezado Tabla
		if rows.size > 1
			rows[1..-1].each_with_index do |row,case_number|
				begin
					caso = Case.new
					info_caso = InfoCorte.new

					palabra = "\n " + case_number.to_s + ") "			
					(row.xpath("td"))[0..-1].each_with_index do |td,i|
						if i == 0
							caso.rol = td.content.strip
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

					puts "\t \t \t "  + case_number.to_s + ") Rol: " + caso.rol.to_s

					if not tracking

						#Litigantes
						href = row.xpath("td/a").attr('href')
						listaLitigantes = getLitigantes(href,case_number)
						
						#Colocar Tipo
						caso.info_type = 'InfoCorte'
					
						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoCorte")
							puts  "\t \t \t " + '[-] Caso ya Existe'
				    	else 
							saveCase(caso,info_caso,listaLitigantes,3)
						end
					else
						if Case.exists?(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoCorte")
							caso = Case.find_by(:rol => caso.rol, :fecha => caso.fecha, :caratula=> caso.caratula, :info_type => "InfoCorte")

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
		doc = Nokogiri::HTML(Get($host_corte + href.to_s.strip,'Consultando Litigantes Caso N° ' + case_number.to_s,4))
		rows = doc.xpath("//*[@id='divLitigantes']/table[2]/tbody/tr")
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
					puts "\t ?: " + td.content.strip
				end
			end
			puts "\t \t \t \t \t " + i.to_s + ") " + litigante.rut + " " + litigante.nombre
			
			listaLitigantes << litigante
		end
		return listaLitigantes
	end
end
