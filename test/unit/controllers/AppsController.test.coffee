request = require('supertest')
assert = require('assert')

describe 'AppsController', ->
	id = undefined
	describe ' POST /api/apps', ->
		it 'responds with create success', (done) ->
			request(sails.hooks.http.app).post('/api/apps').set('Authorization',"Bearer #{sails.token}").send(path: 'apps1',servername: 'a', port:'1').end (err, res) ->
				#console.log 'res:' + JSON.stringify(res)
				assert.equal err, null
				assert.equal res.status, '200'
				
				body = JSON.parse(res.text)
				id = body.id
				#console.log 'created id:' + id
				
				done()
				return
			return
		return  

	describe ' GET /api/apps', ->
		it 'responds with list data', (done) ->
			request(sails.hooks.http.app).get('/api/apps').set('Authorization',"Bearer #{sails.token}").end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return

	describe ' POST /api/apps', ->
		it 'responds with create duplication fail', (done) ->
			request(sails.hooks.http.app).post('/api/apps').set('Authorization',"Bearer #{sails.token}").send(path: 'apps1',servername: 'a', port:'1').end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '409'
				done()
				return
			return
		return 
		
	describe ' PUT /api/apps', ->
		it 'responds with update success', (done) ->
			request(sails.hooks.http.app).put('/api/apps/' + id).set('Authorization',"Bearer #{sails.token}").send(path: 'apps2',servername: 'b', port:'1').end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return 
	
	describe ' DELETE /api/apps', ->
		it 'responds with delete success', (done) ->
			request(sails.hooks.http.app).delete('/api/apps/' + id).set('Authorization',"Bearer #{sails.token}").end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return 		
	
