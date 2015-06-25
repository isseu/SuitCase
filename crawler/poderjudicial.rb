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

	def GuardarInfoCaso(info_caso, caso,cant)
		tab = ""
		cant.times{ tab += "\t " }

		if Case.exists?(rol: caso.rol) or Case.exists?(fecha: caso.fecha, caratula: caso.caratula)
			puts tab + '[+] Informacion del caso ya existe'
		else
			puts tab + '[+] Guardando informacion del caso'
			info_caso.case_id = caso.id
			info_caso.save
		end 
	end

end