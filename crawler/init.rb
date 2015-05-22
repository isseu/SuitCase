# encoding: UTF-8
# Crawler
# civil.poderjudicial.com
# corte.poderjudicial.com
# suprema.poderjudicial.com
# laboral.poderjudicial.com

require 'nokogiri'
require 'rest-client'
require_relative 'civil.rb'
require_relative 'corte.rb'

class Busqueda 

	def AgregarCasos(listaCasos)
		 listaCasos.each do |caso|
		    	puts caso.rol
		    	caso.litigantes.each do |litigantes|
		    		puts "\t" + litigantes.nombre
		    	end
		    	if Case.exists?(:rol => caso.rol) 
		    		puts 'Caso ya Existe'
		    	else 
		    		puts 'Guardando Caso'
		    		caso.save
		    	end
		    end
	end

	def BusquedaLista(lista, pagina)
		lista.each do |user|

			##Por RUT
			rut = user.rut.split('-')
			puts rut[0] + rut[1]
			listaCasos = pagina.Search(rut[0],rut[1],'','','')
			AgregarCasos(listaCasos)

			##Por Nombre + Apellido_Paterno
			listaCasos = pagina.Search('','',user.name, user.first_lastname, '')
			AgregarCasos(listaCasos)

			##Por Nombres Posibles
			listaNombres = user.possible_names
			listaNombres.each do |nombre|
				listaCasos = pagina.Search('','',nombre, user.first_lastname, '')
			end
			
		end
	end

end

CRAWLER_PATH = File.dirname(__FILE__) + '/../../../crawler/' if not defined? CRAWLER_PATH
CRAWLER_PID_FILE = 'crawler.pid' if not defined? CRAWLER_PID_FILE

buscar = Busqueda.new

listaClientes = Client.all
listaUsuarios = User.all
civil = Civil.new
corte = Corte.new

fork do

  puts "[+] Crawler iniciado PID #{Process.pid}"
  # Creamos archivo de pid
  f = File.new( CRAWLER_PATH + CRAWLER_PID_FILE , "w")
  f.puts(Process.pid)
  f.close
	while true
	    # Terminamos ejecucion si se elimina archivo
	    if not File.exist?( CRAWLER_PATH + CRAWLER_PID_FILE )
	      puts "[+] Cerrando crawler PID #{Process.pid}"
	      exit
	    end

		# Primero Buscamos Casos del Usuario 
		puts 'buscando en civil -> Usuarios'
		buscar.BusquedaLista(listaUsuarios, civil)
		puts 'buscando en corte -> Usuarios'
		buscar.BusquedaLista(listaUsuarios, corte)

		# Segundo Buscamos Casos de Clientes
		puts 'buscando en civil -> Usuarios'
		buscar.BusquedaLista(listaClientes, civil)
		puts 'buscando en corte -> Usuarios'
		buscar.BusquedaLista(listaClientes, corte)

		puts "[+] Iteracion Terminada"

	end
end


