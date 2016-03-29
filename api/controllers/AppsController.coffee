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
			
		Model.create(data)
			.then (newInstance) ->
				ConfigServices.createConfig data
				ConfigServices.restartServer data.path
				res.ok(newInstance)
			.catch res.serverError
			
	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		
		Model.findOne({id: pk},data)
			.then (result) ->
				Model.update({id: pk},data)
					.then (updatedInstance) ->
						ConfigServices.deleteConfig result
						ConfigServices.createConfig data
						ConfigServices.restartServer data.path
						res.ok(data)			
			.catch (err) ->
				sails.log.error "err: #{err}"
				res.badRequest(data)
				
	destroy: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		
		Model.findOne({id: pk})
			.then (result) ->
				Model.destroy({id: pk})
					.then (data) ->
						ConfigServices.deleteConfig result
						ConfigServices.restartServer result.path
						res.ok(data)			
			.catch (err) ->
				sails.log.error "err: #{err}"
				res.badRequest(data)
