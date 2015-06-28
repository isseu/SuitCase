namespace :crawler do

  CRAWLER_PATH = File.dirname(__FILE__) + '/../../../crawler/'
  CRAWLER_PID_FILE = 'crawler.pid'
  CRAWLER_INIT_FILE = 'init.rb'

  desc "Inicia el funcionamiento del crawler"
  task start: :environment do
  	puts "[+] Iniciando crawler"
  	load CRAWLER_PATH + CRAWLER_INIT_FILE
  end

  desc "Detiene el funcionamiento del crawler"
  task stop: :environment do
  	puts "[+] Deteniendo crawler"
    File.delete(CRAWLER_PATH + CRAWLER_PID_FILE) if File.exist?(CRAWLER_PATH + CRAWLER_PID_FILE)
  end

  desc "Reinicia el funcionamiento del crawler"
  task restart: :environment do
  	Rake::Task["crawler:stop"].invoke
  	Rake::Task["crawler:start"].invoke
  end

  desc "Inicia la busqueda de un search especifico"
  task search: :environment do
    search_id = ENV["SEARCH_ID"]
    puts "[+] Buscando search con ID: #{search_id}"
    require CRAWLER_PATH + 'busqueda.rb'
    b = Busqueda.new
    b.do_search(search_id)
  end


end
