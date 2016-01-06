env = require './env.coffee'

MenuCtrl = ($scope) ->
	$scope.env = env
	$scope.navigator = navigator

EditCtrl = ($rootScope, $scope, $state, $stateParams, $location, model, $filter) ->
	class EditView  			
		constructor: (opts = {}) ->
			_.each @events, (handler, event) =>
				$scope.$on event, @[handler]
			
		update: ->
			@model = $scope.model		
			@model.path = $scope.model.newpath
			@model.servername = $scope.model.newservername
			@model.port = $scope.model.newport
			@model.$save().then =>
				$state.go 'app.list', {}, { reload: true }

		edit: (selectedModel) ->
			$state.go 'app.editTodo', { SelectedTodo: selectedModel, myTodoCol: null, backpage: 'app.weekList' }, { reload: true }
	
	$scope.model = $stateParams.editRec
	$scope.model.newpath = $scope.model.path
	$scope.model.newservername = $scope.model.servername
	$scope.model.newport = $scope.model.port
		
	$scope.controller = new EditView model: $scope.model	

CreateCtrl = ($rootScope, $scope, $state, $stateParams, $location, model) ->
	class CreateView  			

		constructor: (opts = {}) ->
			_.each @events, (handler, event) =>
				$scope.$on event, @[handler]
			@model = opts.model
			$scope.apps = {path: ''}
				
		add: ->
			@model = new model.Apps
			@model.path = $scope.apps.path
			@model.servername = $scope.apps.servername
			@model.port = $scope.apps.port
			@model.$save().then =>
				$state.go 'app.list', {}, { reload: true }
		
	$scope.controller = new CreateView model: $scope.model
	
AppsListCtrl = ($rootScope, $scope, $state, $stateParams, $location, $filter, model ) ->
	class AppsListCtrlView
		constructor: (opts = {}) ->
			_.each @events, (handler, event) =>
				$scope.$on event, @[handler]
			@collection = opts.collection
		
		remove: (rec) ->
			@collection.remove(rec).then ->
				$state.go 'app.list', {}, { reload: true }
				
		edit: (rec) ->
			$state.go 'app.edit', { editRec: rec }, { reload: true }
	  				
	$scope.getAppsListView = ->
		#start
		$scope.collection = new model.AppsList()
		$scope.collection.$fetch().then ->
			$scope.$apply ->
				$scope.controller = new AppsListCtrlView collection: $scope.collection
		#end		
				
	$scope.getAppsListView()
	
	
config = ->
	return
	
angular.module('starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']).config [config]
	
angular.module('starter.controller').controller 'MenuCtrl', ['$scope', MenuCtrl]
angular.module('starter.controller').controller 'EditCtrl', ['$rootScope', '$scope', '$state', '$stateParams', '$location', 'model', EditCtrl]
angular.module('starter.controller').controller 'CreateCtrl', ['$rootScope', '$scope', '$state', '$stateParams', '$location', 'model', CreateCtrl]
angular.module('starter.controller').controller 'AppsListCtrl', ['$rootScope', '$scope', '$state', '$stateParams', '$location', '$filter', 'model', AppsListCtrl]


