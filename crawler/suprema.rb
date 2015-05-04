##REF1 http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoDAction.do
##REF2 http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1 GET
##REF3 http://suprema.poderjudicial.cl/SITSUPPORWEB/jsp/Menu/Comun/SUP_MNU_BlancoAutoconsulta.jsp GET
##REF4 http://suprema.poderjudicial.cl/SITSUPPORWEB/InicioAplicacion.do POST
##REF5 http://suprema.poderjudicial.cl/SITSUPPORWEB/ GET


require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Suprema < PoderJudicial

	def Iniciar(rut,nombre,apellido_paterno,apellido_materno)
		begin

			Get('http://suprema.poderjudicial.cl/SITSUPPORWEB/','Primera')

			Post('http://suprema.poderjudicial.cl/SITSUPPORWEB/InicioAplicacion.do','http://suprema.poderjudicial.cl/SITSUPPORWEB/', 'Segunda',
				{ "username" => "autoconsulta",
				  "password" => "amisoft",
				  "Aceptar" => "Ingresar"
					}, false, '')

			##Get('http://suprema.poderjudicial.cl/SITSUPPORWEB/jsp/Menu/Comun/SUP_MNU_BlancoAutoconsulta.jsp', 'Tercera')

			Get('http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Cuarta')

			#Consulta a AtPublicoDAction.do			
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			Post('http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoDAction.do',
				'http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Quinta',
				{"TIP_Consulta" => 3,
				 "TIP_Lengueta" => "tdNombre",
				 "SeleccionL" => 0,
				 "COD_Libro" => 0,
				 "COD_Corte" => 1,
				 "COD_Corte_AP" => 0,
				 "ROL_Recurso" => "",
				 "ERA_Recurso" => "",
				 "FEC_Desde" => "28/04/2015",
				 "FEC_Hasta" => "28/04/2015",
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
				 "RUC_Numero" => "",
				 "RUC_Dv" => "",
				 "COD_CorteAP_Pra" => 0,
				 "GLS_Caratulado_Recurso" => "",
				 "irAccionAtPublico" => "Consulta"},true,'Suprema_'+nombre + '_' + apellido_paterno + '_' + apellido_materno)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end
end

test = Suprema.new
test.Iniciar('','','Aguirre','')
