env = require './env.coffee'

module = angular.module('starter', ['ionic', 'util.auth', 'starter.controller', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngTouch', 'ngAnimate', 'pascalprecht.translate', 'locale'])

module
.run (authService) ->
	authService.login env.oauth2.opts
        
.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
	$ionicPlatform.ready ->
		if (window.cordova && window.cordova.plugins.Keyboard)
			cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
		if (window.StatusBar)
			StatusBar.styleDefault()
					
.config ($stateProvider, $urlRouterProvider, $translateProvider) ->

	$stateProvider.state 'app',
		url: ""
		abstract: true
		templateUrl: "templates/menu.html"

	$stateProvider.state 'app.create',
		url: "/apps/create"
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/apps/create.html"
				controller: 'CreateCtrl'									

	$stateProvider.state 'app.edit',
		url: "/apps/edit"
		params: editRec: null
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/apps/edit.html"
				controller: 'EditCtrl'		
	
	$stateProvider.state 'app.list',
		url: "/apps/list"
		cache: false
		views:
			'menuContent':
				templateUrl: "templates/apps/list.html"
				controller: 'AppsListCtrl'		
					
	$urlRouterProvider.otherwise('/apps/list')				
	
	
	