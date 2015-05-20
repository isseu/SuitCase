# encoding: UTF-8
# Crawler
# civil.poderjudicial.com
# corte.poderjudicial.com
# suprema.poderjudicial.com
# laboral.poderjudicial.com

require 'nokogiri'
require 'rest-client'
require_relative 'civil.rb'

CRAWLER_PATH = File.dirname(__FILE__) + '/../../../crawler/' if not defined? CRAWLER_PATH
CRAWLER_PID_FILE = 'crawler.pid' if not defined? CRAWLER_PID_FILE
civil = Civil.new

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

	    listaCasos = civil.Search('10696737','7','','','')
	    puts 'iniciando lista de casos'
	    listaCasos.each do |caso|
	    	puts caso.rol
	    	caso.litigantes.each do |litigantes|
	    		puts "\t" + litigantes.nombre
	    	end
	    	if Case.find_by(id: caso.id)
	    		
	    	else 
	    		puts 'Guardando Caso'
	    		caso.save
	    	end
	    end
		puts "[+] Iteracion Terminada"
	end
end

