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
				puts  "\t \t " + '[-] Caso ya Existe'
	    	else 
			   	puts  "\t \t " + '[+] Agregando caso N°' + i.to_s
		    	
		    	# Escribir litigantes
		    	puts  "\t \t \t " + '[+] Agregando Litigantes'
		    	if caso.litigantes.count > 0 
			    	caso.litigantes.each_with_index do |litigantes,j|
			    		puts "\t \t \t \t " + j.to_s + ".- " + litigantes.nombre
			    	end
			    else
			    	puts "\t \t \t [-] No encontro litigantes"
				end
				
				# Guardar Caso
				puts  "\t \t " + '[+] Guardando Caso'
	    		caso.save!
	    	end
		end

	end

	def BusquedaLista(lista, pagina)
		
		puts "\t [+] Buscando por Rut" 
		lista.each_with_index do |user,number|
			
			# Por RUT
			if ['Civil', 'Laboral'].include? pagina.class.name.to_s
				if user.rut != nil
					rut = user.rut.split('-')
					puts "\t \t " + number.to_s + ") " + rut[0].to_s + rut[1].to_s
					
					begin
						listaCasos = pagina.Search(rut[0],rut[1],'','','')
						AgregarCasos(listaCasos)
					rescue Exception => e
						puts "[!] Error al intentar: " + e.to_s
					end
				end
			end
		

		puts "\t [+] Buscando por Posibles Nombres"	
		lista.each_with_index do |user,number|	
			
			puts "\t \t [+] " + user.name.to_s + " "+  user.first_lastname + " (" + user.rut.to_s + ")"
			
			#Nombres Posibles
			listaNombres = user.possible_names
			listaNombres.each_with_index do |lista,j|
				puts "\t \t \t " + j.to_s + ") Nombre: " +  lista.name.to_s + " Apellidos: " + lista.first_lastname + " " + lista.second_lastname.to_s
				
				begin
					listaCasos = pagina.Search('','',lista.name.to_s,lista.first_lastname,lista.second_lastname.to_s)
					AgregarCasos(listaCasos)
				rescue Exception => e
					puts "[!] Error al intentar: " + e.to_s
				end
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

	
	puts '[+] Buscando en Corte -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, corte)


	puts '[+] Buscando en Suprema -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, suprema)

	puts '[+] Buscando en Laboral -> Usuarios'
	buscar.BusquedaLista(listaUsuarios, laboral)

	
	# Segundo Buscamos Casos de Clientes
	puts '[+] Buscando en Civil -> Usuarios'
	buscar.BusquedaLista(listaClientes, civil)

	puts '[+] Buscando en Corte -> Usuarios'
	buscar.BusquedaLista(listaClientes, corte)

	puts '[+] Buscando en Suprema -> Usuarios'
	buscar.BusquedaLista(listaClientes, suprema)

	puts '[+] Buscando en Laboral -> Usuarios'
	buscar.BusquedaLista(listaClientes, laboral)


	puts "[+] Iteracion Terminada"

end



