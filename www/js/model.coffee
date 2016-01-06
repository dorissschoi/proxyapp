env = require './env.coffee'

iconUrl = (type) ->
	icon = 
		"text/directory":				"img/dir.png"
		"text/plain":					"img/txt.png"
		"text/html":					"img/html.png"
		"application/javascript":		"img/js.png"
		"application/octet-stream":		"img/dat.png"
		"application/pdf":				"img/pdf.png"
		"application/excel":			"img/xls.png"
		"application/x-zip-compressed":	"img/zip.png"
		"application/msword":			"img/doc.png"
		"image/png":					"img/png.png"
		"image/jpeg":					"img/jpg.png"
	return if type of icon then icon[type] else "img/unknown.png"
		
model = (ActiveRecord, $rootScope, platform) ->
	
	class Model extends ActiveRecord
		constructor: (attrs = {}, opts = {}) ->
			@$initialize(attrs, opts)
			
		$changedAttributes: (diff) ->
			_.omit super(diff), '$$hashKey' 
		
		$save: (values, opts) ->
			if @$hasChanged()
				super(values, opts)
			else
				return new Promise (fulfill, reject) ->
					fulfill @
		
	class Collection extends Model
		constructor: (@models = [], opts = {}) ->
			super({}, opts)
			@length = @models.length
					
		add: (models, opts = {}) ->
			singular = not _.isArray(models)
			if singular and models?
				models = [models]
			_.each models, (item) =>
				if not @contains item 
					@models.push item
					@length++
		###		
		remove: (models, opts = {}) ->
			singular = not _.isArray(models)
			if singular and models?
				models = [models]
			_.each models, (model) =>
				model.$destroy().then =>
					@models = _.filter @models, (item) =>
						item[@$idAttribute] != model[@$idAttribute]
			@length = @models.length
		###
		remove: (models, opts = {}) ->
			return new Promise (fulfill, reject) =>
				singular = not _.isArray(models)
				if singular and models?
					models = [models]
				_.each models, (model) =>
						model.$destroy().then =>
							@models = _.filter @models, (item) =>
								item[@$idAttribute] != model[@$idAttribute]
							fulfill @models 
				@length = @models.length
						
					
		contains: (model) ->
			cond = (a, b) ->
				a == b
			if typeof model == 'object'
				cond = (a, b) =>
					a[@$idAttribute] == b[@$idAttribute]
			ret = _.find @models, (elem) =>
				cond(model, elem) 
			return ret?	
		
		$fetch: (opts = {}) ->
			return new Promise (fulfill, reject) =>
				@$sync('read', @, opts)
					.then (res) =>
						data = @$parse(res.data, opts)
						if _.isArray data
							@add data
							fulfill @
						else
							reject 'Not a valid response type'
					.catch reject
		
	class PageableCollection extends Collection
		constructor: (models = [], opts = {}) ->
			@state =
				count:		0
				skip:		0
				limit:		10
				total_page:	0
			super(models, opts)
				
		###
		opts:
			params:
				page:		page no to be fetched (first page = 1)
				per_page:	no of records per page
		###
		$fetch: (opts = {}) ->
			opts.params = opts.params || {}
			opts.params.skip = @state.skip
			opts.params.limit = opts.params.limit || @state.limit
			return new Promise (fulfill, reject) =>
				@$sync('read', @, opts)
					.then (res) =>
						data = @$parse(res.data, opts)
						if data.count? and data.results?
							@add data.results
							@state = _.extend @state,
								count:		data.count
								skip:		opts.params.skip + data.results.length
								limit:		opts.params.limit
								total_page:	Math.ceil(data.count / opts.params.limit)
							fulfill @
						else
							reject 'Not a valid response type'
					.catch reject
		
	class User extends Model
		$idAttribute: 'username'
		
		$urlRoot: "#{env.authUrl}/org/api/users/"
			
		@me: ->
			(new User(username: 'me/')).$fetch()	
			
		

	# ResLog model
	class Apps extends Model
		$idAttribute: 'id'
		$urlRoot: "#{env.serverUrl()}/api/apps"
		
	class AppsList extends PageableCollection
		$urlRoot: "#{env.serverUrl()}/api/apps"
		
		$parse: (res, opts) ->
			_.each res.results, (value, key) =>
				obj = new Apps res.results[key]
				#obj.createdAt = $filter('date') obj.createdAt, 'yyyy-MM-dd HH:mm'
				obj.createdAt = new Date(Date.parse(obj.createdAt))
				res.results[key] = obj 
			return res				
		
	Model:		Model
	Collection:	Collection
	User:		User
	Apps:		Apps
	AppsList:	AppsList
				
config = ->
	return
	
angular.module('starter.model', ['ionic', 'ActiveRecord']).config [config]

angular.module('starter.model').factory 'model', ['ActiveRecord', '$rootScope', 'platform', model]