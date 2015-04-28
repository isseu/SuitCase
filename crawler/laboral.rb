#$LOAD_PATH << '.'

require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Laboral < PoderJudicial

	def Iniciar(rut,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Post('http://laboral.poderjudicial.cl/SITLAPORWEB/InicioAplicacionPortal.do',
				'http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp','Primera',
				{"FLG_Autoconsulta" => 1},false,'')

			#Actualizar Sesión
			#Get('http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/Menu/Comun/LAB_MNU_BlancoPortal.jsp','Segunda')
			Get('http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1/','Tercera')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta #{nombre}'
			Post('http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoDAction.do',
				'http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta',
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
				 "FEC_Desde" => "27/04/2015",
				 "FEC_Hasta" => "27/04/2015",
				 "SEL_Trabajadores" => 0,
				 "RUT_Consulta" => "",
				 "RUT_DvConsulta" => "",
				 "irAccionAtPublico" => "Consulta",
				 "NOM_Consulta" => '"' + nombre.upcase + '"',
				 "APE_Paterno" => '"' + apellido_paterno.upcase+ '"',
				 "APE_Materno" => '"' + apellido_materno.upcase+ '"',
				 "GLS_Razon" => "",
				 "COD_Tribunal" => 1336},true,'Laboral_#{nombre}_#{apellido_paterno}_#{apellido_materno}')

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end
end

ola = Laboral.new
ola.Iniciar('','','Aguirre','')