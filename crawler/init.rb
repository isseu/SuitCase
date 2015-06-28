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

  def searchUser(lista, pagina)

    puts "\t [+] Buscando por Rut"
    lista.each_with_index do |user, number|
      # Por RUT
      if ['Civil', 'Laboral'].include? pagina.class.name.to_s
        if user.rut != nil
          puts "\t \t " + number.to_s + ") " + user.rut.to_s
          begin
            pagina.Search('', nil, user.rut, '', '', '', 2, "tdTres", false)
          rescue Exception => e
            puts "[!] Error al intentar: " + e.to_s
          end
        end
      end
    end

    puts "\t [+] Buscando por Posibles Nombres"
    lista.each_with_index do |user, number|

      puts "\t \t [+] " + user.name.to_s + " "+ user.first_lastname + " (" + user.rut.to_s + ")"

      #Nombres Posibles
      listaNombres = user.possible_names
      listaNombres.each_with_index do |lista, j|
        puts "\t \t \t " + j.to_s + ") Nombre: " + lista.name.to_s + " Apellidos: " + lista.first_lastname + " " + lista.second_lastname.to_s

        begin
          if ['Corte', 'Suprema'].include? pagina.class.name.to_s
            pagina.Search('', nil, '', lista.name.to_s, lista.first_lastname, lista.second_lastname.to_s, 3, "tdNombre", false)
          elsif ['Civil', 'Laboral'].include? pagina.class.name.to_s
            pagina.Search('', nil, '', lista.name.to_s, lista.first_lastname, lista.second_lastname.to_s, 3, "tdCuatro", false)
          end
        rescue Exception => e
          puts "[!] Error al intentar: " + e.to_s
        end
      end
    end
  end

  def searchClient(lista, pagina)
    puts "\t [+] Buscando por Nombres Clientes"

  end

  def searchTracking(lista, pagina)

    puts "\t [+] Trackeando Casos por Usuarios"

    lista.each_with_index do |user, i|
      puts "\t \t [+] " + user.name.to_s + " "+ user.first_lastname + " (" + user.rut.to_s + ")"
      user.case_records.each_with_index do |case_record, j|
        caso = Case.find(case_record.case_id)
        if caso != nil
          if (caso.info_type == 'InfoCorte' && (['Corte'].include? pagina.class.name.to_s)) || (caso.info_type == 'InfoSuprema'&& (['Suprema'].include? pagina.class.name.to_s))
            puts "\t \t \t " + j.to_s + ") Caso: " + caso.rol.to_s
            pagina.Search(caso.rol, user, '', user.name.to_s, user.first_lastname.to_s, user.second_lastname.to_s, 1, 'tdRecurso', true)
          elsif (caso.info_type == 'InfoLaboral' && (['Laboral'].include? pagina.class.name.to_s)) || (caso.info_type == 'InfoCivil' && (['Civil'].include? pagina.class.name.to_s))
            puts "\t \t \t " + j.to_s + ") Caso: " + caso.rol.to_s
            pagina.Search(caso.rol, user, '', user.name.to_s, user.first_lastname.to_s, user.second_lastname.to_s, 1, 'tdUno', true)
          end
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
f = File.new(CRAWLER_PATH + CRAWLER_PID_FILE, "w")
f.puts(Process.pid)
f.close

while true
  # Terminamos ejecucion si se elimina archivo
  if not File.exist?(CRAWLER_PATH + CRAWLER_PID_FILE)
    puts "[+] Cerrando crawler PID #{Process.pid}"
    exit
  end

  #Primero todos los Trackeados
  puts '[+] Trackear Civil'
  buscar.searchTracking(listaUsuarios, civil)

  puts '[+] Trackear Corte'
  buscar.searchTracking(listaUsuarios, corte)

  puts '[+] Trackear Laboral'
  buscar.searchTracking(listaUsuarios, laboral)

  puts '[+] Trackear Suprema'
  buscar.searchTracking(listaUsuarios, suprema)

  # Primero Buscamos Casos del Usuario
  puts '[+] Buscando en Civil -> Usuarios'
  buscar.searchUser(listaUsuarios, civil)

  puts '[+] Buscando en Corte -> Usuarios'
  #buscar.searchUser(listaUsuarios, corte)

  puts '[+] Buscando en Laboral -> Usuarios'
  #buscar.searchUser(listaUsuarios, laboral)

  puts '[+] Buscando en Suprema -> Usuarios'
  #buscar.searchUser(listaUsuarios, suprema)

=begin		
	# Segundo Buscamos Casos de Clientes
	puts '[+] Buscando en Civil -> Usuarios'
	buscar.searchClient(listaClientes, civil)

	puts '[+] Buscando en Corte -> Usuarios'
	buscar.searchClient(listaClientes, corte)

	puts '[+] Buscando en Suprema -> Usuarios'
	buscar.searchClient(listaClientes, suprema)

	puts '[+] Buscando en Laboral -> Usuarios'
	buscar.searchClient(listaClientes, laboral)

	puts "[+] Iteracion Terminada"
=end

end