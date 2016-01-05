 # Apps.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

	tableName:		'apps'
  
	schema:			true
	
	attributes:
  
		path:
			type:		'string'
			required:	true
			unique: 	true

		servername:
			type:		'string'
			required:	true

		port:
			type:		'integer'
			required:	true
      
		createdAt:
			type:		'datetime'
			defaultsTo:	new Date()
			
		createdBy:
			type:		'string'
			required:	true
			
		updatedAt:
			type:		'datetime'
			defaultsTo:	new Date()      

	afterCreate: (values, cb) ->
		ConfigServices.createConfig(values)

		return cb null, values  
	
	afterDestroy: (values, cb) ->
		ConfigServices.deleteConfig(values)

		return cb null, values
	
	afterUpdate: (values, cb) ->
		ConfigServices.createConfig(values)

		return cb null, values
