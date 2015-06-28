require 'nokogiri'
require 'rest-client'
class PoderJudicial 
	$cookies = {}

	def saveCookies(response)
	    response.cookies.each { | k, v |
	    	$cookies[k] = v
	    }
	end 

	def Get(url,iteracion,cant)
		
		#Mensaje
		tab = ""
		cant.times{ tab += "\t " }

		if url.size > 118
			puts tab + '[+] ' + iteracion +' -> ' + url[56..118].to_s + " ..."
		else
			puts tab + '[+] ' + iteracion +' -> ' + url 
		end

		response = RestClient.get(url,{ :cookies => $cookies })

		if (response.code == 200)
			#puts '[-] Cookies obtenidas: ' + response.cookies.to_s
		    saveCookies(response)
		    #puts '[-] Cookies Totales: ' + $cookies.to_s
		    response.to_s
		else
			puts 'Error'
		end
	end

	def Post(url,referer,iteracion,params,cant)
		#Mensaje
		tab = ""
		cant.times{ tab += "\t " }

		if url.size > 118
			puts tab + '[+] ' + iteracion +' -> ' + url[56..118].to_s + " ..."
		else
			puts tab + '[+] ' + iteracion +' -> ' + url 
		end

		response = RestClient::Request.execute(:method => :post,
			:url => url,
		  	:headers => {
		  		'Referer' => referer,
		  		'User-Agent' =>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
		  	},
		  	:payload => params,
		  	:cookies => $cookies,
			:timeout => 1200 # Esto se puede demorar kleta
		)

		if (response.code == 200)
			#puts '[-] Cookies obtenidas: ' + response.cookies.to_s
		    saveCookies(response)
		    response.to_s		
		else
			puts 'No Entro'
		end
	end

	def saveCase(caso,info_caso,listaLitigantes,listaReceptores,cant)
	   	probarNotificaciones = false
		
		tab = ""
		cant.times{ tab += "\t "}
	   	puts  tab + '[+] Agregando caso'
    	
    	# Escribir litigantes
    	puts  tab + "\t " + '[+] Agregando Litigantes'
    	if not probarNotificaciones
    		listaLitigantes.each do |litigante|
				l = caso.litigantes.build
				l.rut = litigante.rut
				l.persona = litigante.persona
				l.nombre = litigante.nombre
				l.participante = litigante.participante
				l.save
			end
		else
			if listaLitigantes.count > 0 
				litigante = listaLitigantes[0]
				l = caso.litigantes.build
				l.rut = litigante.rut
				l.persona = litigante.persona
				l.nombre = litigante.nombre
				l.participante = litigante.participante
				l.save
			end
		end

		info_caso.save	
		caso.info_id = info_caso.id
		
		# Guardar Caso
		caso.save!
		info_caso.case_id = caso.id
		info_caso.save!

		#ColocarReceptores
		if listaReceptores != nil
			if not probarNotificaciones
				listaReceptores.each do |receptor|
					l = info_caso.receptors.build
					l.notebook = receptor.notebook 
					l.dat = receptor.dat
					l.state = receptor.state
					l.save
				end
			else
				if listaReceptores.count > 0 
					receptor = listaReceptores[0]
					l = info_caso.receptors.build
					l.notebook = receptor.notebook 
					l.dat = receptor.dat
					l.state = receptor.state
					l.save
				end
			end
		end

		puts  tab + '[+] Caso Guardado'
	end

	def updateLitigantes(listaLitigantes,caso,user)
		if listaLitigantes.count > caso.litigantes.count
			anyNotification = false
			if caso.litigantes.count == 0
				listaLitigantes.each do |newLitigante|
					l = caso.litigantes.build
					l.rut = newLitigante.rut
					l.persona = newLitigante.persona
					l.nombre = newLitigante.nombre
					l.participante = newLitigante.participante
					l.save
					anyNotification = true
				end
			else
				listaLitigantes.each do |newLitigante|
					caso.litigantes.each do |oldLitigante|
						if not (newLitigante.rut.to_s == oldLitigante.rut.to_s && newLitigante.persona == oldLitigante.persona && newLitigante.nombre == oldLitigante.nombre && newLitigante.participante == oldLitigante.participante) 
							l = caso.litigantes.build
							l.rut = newLitigante.rut
							l.persona = newLitigante.persona
							l.nombre = newLitigante.nombre
							l.participante = newLitigante.participante
							l.save
							anyNotification = true
						end
					end
				end
			end

			if anyNotification
				message = "Nuevos Litigantes \n \t Rol: " + caso.rol.to_s + " \n \t Tribunal: " + caso.tribunal.to_s + " \n \t Tipo: " + caso.info_type.to_s
				sentNotification(user,caso,message)
			end
		end
	end

	def updateReceptores(listaReceptores,caso,user)
		info_caso = InfoCivil.find_by(case_id: caso.id)

		if listaReceptores.count > info_caso.receptors.count
			anyNotification = false
			if info_caso.receptors.count == 0
				listaReceptores.each do |receptor|
					l = info_caso.receptors.build
					l.notebook = receptor.notebook 
					l.dat = receptor.dat
					l.state = receptor.state
					l.save
					anyNotification = true
				end
			else
				listaReceptores.each do |newReceptor|
					info_caso.receptors.each do |oldReceptor|
						if not (newReceptor.notebook == oldReceptor.notebook && newReceptor.dat == oldReceptor.dat && newReceptor.state == oldReceptor.state)
							l = info_caso.receptors.build
							l.notebook = newReceptor.notebook 
							l.dat = newReceptor.dat
							l.state = newReceptor.state
							l.save
							anyNotification = true
						end
					end
				end
			end

			if anyNotification
				message = "Nuevos Receptores en \n \t Rol: " + caso.rol.to_s + " \n \t Tribunal: " + caso.tribunal.to_s + " \n \t Tipo: " + caso.info_type.to_s
				sentNotification(user,caso,message)
			end
		end
	end

	def sentNotification(user,caso,message)
		if user != nil
			url = 'cases/' + caso.id.to_s
			user.notifications.create!(read: false, text: message, url: url.to_s)
			puts "\t \t \t \t [+] Enviando Notificación"
		end
	end

end