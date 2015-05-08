require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Civil < PoderJudicial

	$host = 'http://civil.poderjudicial.cl'

	def Iniciar(rut,nombre,apellido_paterno,apellido_materno)
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
					"FEC_Desde" => "27/04/2015",
					"FEC_Hasta" => "27/04/2015",
					"SEL_Litigantes" => 0,
					"RUT_Consulta" => "",
					"RUT_DvConsulta" => " ",
					"NOM_Consulta" => nombre.upcase,
					"APE_Paterno" => apellido_paterno.upcase,
					"APE_Materno" => apellido_materno.upcase,
					"irAccionAtPublico" => "Consulta" })


			puts '
         _______  _______  _______  ______  _________ _        _______ 
        (  ____ )(  ____ \(  ___  )(  __  \ \__   __/( (    /|(  ____ \
        | (    )|| (    \/| (   ) || (  \  )   ) (   |  \  ( || (    \/
        | (____)|| (__    | (___) || |   ) |   | |   |   \ | || |      
        |     __)|  __)   |  ___  || |   | |   | |   | (\ \) || | ____ 
        | (\ (   | (      | (   ) || |   ) |   | |   | | \   || | \_  )
        | ) \ \__| (____/\| )   ( || (__/  )___) (___| )  \  || (___) |
        |/   \__/(_______/|/     \|(______/ \_______/|/    )_)(_______)
                                                                       
                  _______  _______  _______  _______  _______ 
                 (  ____ \(  ___  )(  ____ \(  ____ \(  ____ \
                 | (    \/| (   ) || (    \/| (    \/| (    \/
                 | |      | (___) || (_____ | (__    | (_____ 
                 | |      |  ___  |(_____  )|  __)   (_____  )
                 | |      | (   ) |      ) || (            ) |
                 | (____/\| )   ( |/\____) || (____/\/\____) |
                 (_______/|/     \|\_______)(_______/\_______)
                                                              '
			SearchCases(respuesta)	

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end

	def SearchCases(respuesta)

		doc = Nokogiri::HTML(respuesta)
		rows = doc.xpath("//*[@id='contentCellsAddTabla']/tbody/tr")
		
		case_number = 1
		
		#For each tag <tr>
		rows[1..-2].each do |row|

			href = row.xpath("td/a").attr('href')

			#################################################
			#Solo hacer el get si es necesario !!! Falta eso#
			#################################################
			getMoreInfo(href,case_number)

			palabra = ""			
			(row.xpath("td"))[1..-2].each do |td|
				palabra += palabra + "/ "+ td.content + "/ "
			end
			puts palabra.to_s
			
			File.write('tmp/'+case_number.to_s+'.txt', palabra.to_s)		
			case_number = case_number + 1
		end
	end

	#La idea es que se llame a este metodo si y solo se sigue el caso
	def getMoreInfo(href,case_number)
		res = Get($host + href.to_s,'Consultando Caso N° ' + case_number.to_s)
			
			#######
			#Falta#
			#######

		File.write('tmp/litigantes/'+case_number.to_s+'.txt', res.to_s)		
		res
	end
end


#Directorios de Prueba
Dir.mkdir('tmp') unless File.exists?('tmp')
Dir.mkdir('tmp/litigantes') unless File.exists?('tmp/litigantes')

ola = Civil.new
ola.Iniciar('','','Alvear','Castillo')
