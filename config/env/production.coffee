path = '/apps'
agent = require 'https-proxy-agent'

module.exports =
	path:			path
	url:			"http://localhost:1337#{path}"
	port:			8023

	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
		
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'db'
			port:		27017
			user:		'proxyapprw'
			password:	'pass1234'
			database:	'proxyapp'	
	
	proxy:
		file:
			path:		'./conf.d/'
			extension:	'.conf'	
			
			