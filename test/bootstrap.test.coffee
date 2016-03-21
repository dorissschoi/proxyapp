Sails = require 'sails'

sails = null

before (done) ->
	@timeout(90000)
	Sails.lift {
		environment: process.env.NODE_ENV
		hooks:
			grunt:false
		log:
        	level: "silly"
		models:
			connection: "mongo"
			migrate: "alter"
		
	}, (error, server) ->
		console.log "process env: #{process.env.NODE_ENV}"
		sails = server
		Sails.services.rest.token 'https://mob.myvnc.com/org/oauth2/token/', {id:'todomsgDEVAuth', secret:'pass1234'}, {id:'todoadmin', secret:'pass1234'}, ['https://mob.myvnc.com/org/users']
			.then (res) ->
				sails.token = res.body.access_token
				done error
    	
after (done) ->
	Sails.lower(done)