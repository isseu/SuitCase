require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Corte < PoderJudicial

	def Iniciar(rut,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Get("http://corte.poderjudicial.cl/SITCORTEPORWEB/",'Primera')

			#Get("http://corte.poderjudicial.cl/SITCORTEPORWEB/jsp/Menu/Comun/COR_MNU_BlancoAutoconsulta.jsp",'Segunda')

			#Setear Camino
			Get('http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			Post('http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoDAction.do',
				'http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera',
				{"TIP_Consulta"=> "3", 
				 "TIP_Lengueta"=> "tdNombre",
				 "TIP_Causa"=> " ",
				 "COD_Libro"=> "null",
				 "COD_Corte"=> "0",
				 "COD_LibroCmb"=> "",
				 "ROL_Recurso"=> "",
				 "ERA_Recurso"=> "",
				 "FEC_Desde"=> "29/04/2015",
				 "FEC_Hasta"=> "29/04/2015",
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
				 "irAccionAtPublico"=> "Consulta" },true,'Corte_'+nombre + '_' + apellido_paterno + '_' + apellido_materno)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end
end

ola = Corte.new
ola.Iniciar('','','Aguirre','')
