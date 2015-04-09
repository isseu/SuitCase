namespace :crawler do
  desc "Inicia el funcionamiento del crawler"
  task start: :environment do
  	puts "[+] Iniciando crawler"
  	load 'File.dirname(__FILE__)/../../../crawler/init.rb'
  end

  desc "Detiene el funcionamiento del crawler"
  task stop: :environment do
  	puts "[+] Deteniendo crawler"
  end

  desc "Reinicia el funcionamiento del crawler"
  task restart: :environment do
  	Rake::Task["crawler:stop"].invoke
  	Rake::Task["crawler:start"].invoke
  end

end
