# encoding: UTF-8
# Crawler
# civil.poderjudicial.com
# corte.poderjudicial.com
# suprema.poderjudicial.com
# laboral.poderjudicial.com

require 'nokogiri'
require 'rest-client'

CRAWLER_PATH = File.dirname(__FILE__) + '/../../../crawler/' if not defined? CRAWLER_PATH
CRAWLER_PID_FILE = 'crawler.pid' if not defined? CRAWLER_PID_FILE

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
    puts "Hello from fork pid: #{Process.pid}"
    sleep 5.seconds
  end
end