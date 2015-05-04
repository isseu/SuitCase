require 'nokogiri'
require 'rest-client'

require_relative 'poderjudicial.rb'

class Civil < PoderJudicial

	def Iniciar(rut,nombre,apellido_paterno,apellido_materno)
		begin
			#Iniciar para Obtener Cookie
			Get("http://civil.poderjudicial.cl/CIVILPORWEB/",'Primera')

			#Setear Camino
			Get('http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Segunda')

			#Consulta a AtPublicoDAction.do
			puts '[+] Ejecutando consulta '+ nombre + ' ' + apellido_paterno + ' ' + apellido_materno
			Post('http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do',
				'http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1','Tercera',
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
					"irAccionAtPublico" => "Consulta" },true,'Civil_'+nombre + '_' + apellido_paterno + '_' + apellido_materno)

		rescue Exception => e 
			puts "[!] Error al intentar hacer consulta: " + e.to_s
			exit
		end
	end
end

ola = Civil.new
ola.Iniciar('','','Aguirre','')
