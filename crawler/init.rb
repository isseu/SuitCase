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
require_relative 'busqueda.rb'

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

  # Primero todos los Trackeados
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
  buscar.searchUser(listaUsuarios, corte)

  puts '[+] Buscando en Laboral -> Usuarios'
  buscar.searchUser(listaUsuarios, laboral)

  puts '[+] Buscando en Suprema -> Usuarios'
  buscar.searchUser(listaUsuarios, suprema)

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

end