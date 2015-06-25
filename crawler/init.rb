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
require_relative 'suprema.rb'
require_relative 'laboral.rb'

class Busqueda 

	def AgregarCasos(listaCasos)		
		listaCasos.each_with_index do |caso,i|
	    	if Case.exists?(:rol => caso.rol, :info_type => caso.info_type)
				puts '[-] Caso ya Existe'
	    	else 
			   	puts '[+] Agregando caso N°' + i.to_s
		    	
		    	# Escribir litigantes
		    	puts  "\t" + '[+] Agregando Litigantes'
		    	if caso.litigantes.count > 0 
			    	caso.litigantes.each_with_index do |litigantes,j|
			    		puts "\t \t " + j.to_s + ".- " + litigantes.nombre
			    	end
			    else
			    	puts "\t [-] No encontro litigantes"
				end
				
				# Guardar Caso
				puts '[+] Guardando Caso'
	    		caso.save!
	    	end
		end

	end

	def BusquedaLista(lista, pagina)
		
=begin		puts "\t [+] Buscando por Rut" 
		lista.each_with_index do |user,number|
			
			# Por RUT
			if ['Civil', 'Laboral'].include? pagina.class.name.to_s
				if user.rut != nil
					rut = user.rut.split('-')
					puts "\t \t " + number.to_s + ") " + rut[0].to_s + rut[1].to_s
					listaCasos = pagina.Search(rut[0],rut[1],'','','')
					AgregarCasos(listaCasos)
				end
			end
=end		

		puts "\t [+] Buscando por Posibles Nombres"	
		lista.each_with_index do |user,number|	
			
			puts "\t \t [+]" + user.name.to_s + " "+  user.first_lastname + " (" + user.rut.to_s + ")"
			
			#Nombres Posibles
			listaNombres = user.possible_names
			listaNombres.each_with_index do |lista,j|
				puts "\t \t \t " + j.to_s + ") Nombre: " +  lista.name.to_s + " Apellidos: " + lista.first_lastname + " " + lista.second_lastname.to_s
				listaCasos = pagina.Search('','',lista.name.to_s,lista.first_lastname,lista.second_lastname.to_s)
				AgregarCasos(listaCasos)
			end
		
		end	
	end
end

CRAWLER_PATH = File.dirname(__FILE__) if not defined? CRAWLER_PATH
CRAWLER_PID_FILE = 'crawler.pid' if not defined? CRAWLER_PID_FILE

buscar = Busqueda.new

listaClientes = Client.all
listaUsuarios = User.all
civil = Civil.new
corte = Corte.new
suprema = Suprema.new
laboral = Laboral.new

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
	puts '[+] Buscando en Civil -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, civil)
=begin	
	puts 'buscando en corte -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, corte)

	puts 'buscando en suprema -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, suprema)
	
	puts 'buscando en laboral -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, laboral)

	# Segundo Buscamos Casos de Clientes
	puts 'buscando en civil -> Usuarios'
	buscar.BusquedaLista(listaClientes, civil)
	puts 'buscando en corte -> Usuarios'
	buscar.BusquedaLista(listaClientes, corte)
	puts 'buscando en suprema -> Clientes'
	buscar.BusquedaLista(listaClientes, suprema)
	puts 'buscando en laboral -> Clientes'
	buscar.BusquedaLista(listaClientes, laboral)
=end

	puts "[+] Iteracion Terminada"

end



