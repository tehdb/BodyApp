angular
	.module('BodyApp', ['ngRoute', 'ngAnimate', 'ngSanitize', 'ui.bootstrap'])
	.constant('SETTINGS', {
		apis : {
			muscle : '/api/muscle'
			exercise : '/api/exercise'
		}

		, dialog : {
			
		}
	})
	.config( ['$routeProvider', ( rpr ) ->
		rpr
			.when('/', {
				# templateUrl: 'tpl/views/home.html',
				template: 	'"{{templates/views/home.html}}"'
				controller: 'HomeController'
			})

			.when('/exercises', {
				# templateUrl: 'tpl/views/exercises.html',
				template: 	'"{{templates/views/exercises.html}}"'
				controller: 'ExercisesController'
			})

			.when('/exercise/:id', {
				# templateUrl: 'tpl/views/exercise.html',
				template: 	'"{{templates/views/exercise.html}}"'
				controller: 'ExerciseCtrl'
			})

			.when('/muscles', {
				# templateUrl: 'tpl/views/muscles.html',
				template: 	'"{{templates/views/muscles.html}}"'
				controller: 'MusclesController'
			})

			.when('/muscle/:id', {
				# templateUrl : 'tpl/views/muscle.html'
				template: 	'"{{templates/views/muscle.html}}"'
				controller : 'MuscleController'
			})

			.when('/schedules/', {
				# templateUrl : 'tpl/views/schedules.html'
				template: 	'"{{templates/views/schedules.html}}"'
				controller: 'SchedulesController'
			})

			.when('/features/', {
				#templateUrl : 'tpl/views/features.html'
				template: 	'"{{templates/views/features.html}}"'
				controller: 'FeaturesController'
			})

			.otherwise({
				redirectTo: '/'
			})
	])
