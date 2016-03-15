 # AppsController
 #
 # @description :: Server-side logic for managing apps
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
Promise = require 'promise'
module.exports =
			      	
	create: (req, res) ->
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		cond = 
			path:	data.path
		
		Model
			.findOne()
			.where(path: data.path)
			.populateAll()
			.then (result) ->
				if result
					return res.status(409).send("Apps already exists.")
				else
					Model.create(data)
						.then (newInstance) ->
							res.ok({id: newInstance.id})
						.catch res.serverError
			.catch res.serverError

	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		
		count = Model.count()
			.where( path: data.path )
			.toPromise()
		query = Model.find()
			.where( path: data.path )
			.populateAll()
			.limit( actionUtil.parseLimit(req) )
			.skip( actionUtil.parseSkip(req) )
			.sort( actionUtil.parseSort(req) )
			.toPromise()
		
		new Promise (fulfill, reject) ->
			Promise.all([count, query])
				.then (result) ->
					if result[0] == 0 or result[1][0].id == data.id
						# del file by ID
						Model
							.findOne({id: pk},data)
							.then (updatedInstance) ->
								ConfigServices.deleteConfig(updatedInstance)
								res.ok()
							.catch res.serverError
						Model
							.update({id: pk},data)
							.then (updatedInstance) ->
								res.ok()
							.catch res.serverError
					else 	
						return res.status(409).send("Apps already exists.")	
					fulfill
						count:		result[0]
						results:	result[1]
				.catch reject
		
		