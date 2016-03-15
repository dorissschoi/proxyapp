env = require './env.coffee'
require 'PageableAR'
		
angular.module 'starter.model', ['PageableAR']
	
	.factory 'resources', (pageableAR) ->

		
		#  model
		class Apps extends pageableAR.Model
			$urlRoot: "api/apps"
			
		class AppsList extends pageableAR.PageableCollection
			model: Apps
		
			$urlRoot: "api/apps"
			
		Apps:	Apps
		AppsList:	AppsList
		