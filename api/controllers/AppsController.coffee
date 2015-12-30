 # AppsController
 #
 # @description :: Server-side logic for managing apps
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =

			
	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		
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