module	Methods
	COOKIES = {}

	#Save Cookies in the global variable
	def Methods.saveCookies(response)
	    response.cookies.each { | k, v |
	    	COOKIES[k] = v
	    }
	end 

	#Update Session by passing through the site indicate (url)
	def Methods.updateSession(url,iteracion)
		puts '[+] ' + iteracion +' consulta'
		response = RestClient.get(url,{ :cookies => COOKIES })

		if (response.code == 200)
			puts '[-] Cookies obtenidas: ' + response.cookies.to_s
		    Methods.saveCookies(response)
		    puts '[-] Cookies Totales: ' + COOKIES.to_s
		else
			puts 'Error'
		end
	end
end