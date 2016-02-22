 # AppsController
 #
 # @description :: Server-side logic for managing apps
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
			      	
	create: (req, res) ->
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		cond = 
			path:	data.path
		
		sails.models.apps
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