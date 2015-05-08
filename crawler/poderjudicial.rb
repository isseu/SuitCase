require 'nokogiri'
require 'rest-client'
class PoderJudicial 
	$cookies = {}

	def saveCookies(response)
	    response.cookies.each { | k, v |
	    	$cookies[k] = v
	    }
	end 

	def Get(url,iteracion)
		puts '[+] ' + iteracion +' -> ' + url
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

	def Post(url,referer,iteracion,params)
		puts '[+] ' + iteracion +' -> ' + url 
		response = RestClient::Request.execute(:method => :post,
			:url => url,
		  	:headers => {
		  		'Referer' => referer,
		  		'User-Agent' =>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
		  	},
		  	:payload => params,
		  	:cookies => $cookies,
			:timeout => 90000000 # Esto se puede demorar kleta
		)

		if (response.code == 200)
			#puts '[-] Cookies obtenidas: ' + response.cookies.to_s
		    saveCookies(response)
		    response.to_s		
		else
			puts 'No Entro'
		end
	end
end