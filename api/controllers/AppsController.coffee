 # AppsController
 #
 # @description :: Server-side logic for managing apps
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
Promise = require 'promise'
module.exports =

	update: (req, res) ->
		pk = actionUtil.requirePk(req)
		Model = actionUtil.parseModel(req)
		data = actionUtil.parseValues(req)
		
		Model.findOne({id: pk},data)
			.then (result) ->
				Model
					.update({id: pk},data)
					.then (updated) ->
						ConfigServices.deleteConfig result
						ConfigServices.createConfig updated[0]
						res.ok()
			.catch res.serverError	
		