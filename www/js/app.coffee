env = require './env.coffee'

angular.module 'starter', ['ionic', 'starter.controller', 'starter.model', 'util.auth', 'ActiveRecord', 'ngTouch', 'ngFancySelect', 'pascalprecht.translate', 'locale']

	.run (authService) ->
		authService.login env.oauth2.opts
		
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()
						
	.config ($stateProvider, $urlRouterProvider) ->
		$stateProvider.state 'app',
			url: ""
			abstract: true
			templateUrl: "templates/menu.html"
	
		# Apps
		$stateProvider.state 'app.Apps',
			url: "/proxyapp/list?createdBy&sort"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/proxyapp/list.html"
					controller: 'ListCtrl'
			resolve:
				createdBy: ($stateParams) ->
					return $stateParams.createdBy
				resources: 'resources'
				collection: (resources, createdBy) ->
					ret = new resources.AppsList()
					ret.$fetch({params: {createdBy: createdBy, sort: 'path asc'}})
					
		$stateProvider.state 'app.AppsCreate',
			url: "/proxyapp/create"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/proxyapp/create.html"
					controller: 'AppsCtrl'
			resolve:
				resources: 'resources'	
				model: (resources) ->
					ret = new resources.Apps()
					
		$stateProvider.state 'app.AppsEdit',
			url: "/proxyapp/edit/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/proxyapp/edit.html"
					controller: 'AppsCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				resources: 'resources'	
				model: (resources, id) ->
					ret = new resources.Apps({id: id})
					ret.$fetch()			
	
		$urlRouterProvider.otherwise('/proxyapp/list?createdBy=me&sort=path')