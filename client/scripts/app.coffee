angular
	.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate", "ngSanitize"])
	.constant("Settings", {
		apis : {
			muscle : "/api/muscle"
			exercise : "/api/exercise"
		}
	})
	.config( ["$routeProvider", ( rpr ) ->
		rpr
			.when("/", {
				templateUrl: "tpl/views/home.html",
				controller: "HomeController"
			})

			.when("/exercises", {
				templateUrl: "tpl/views/exercises.html",
				controller: "ExercisesController"
			})

			.when("/exercise/:id", {
				templateUrl: "tpl/views/exercise.html",
				controller: "ExerciseCtrl"
			})

			.when("/muscles", {
				templateUrl: "tpl/views/muscles.html",
				controller: "MusclesController"
			})

			.when("/muscle/:id", {
				templateUrl : "tpl/views/muscle.html"
				controller : "MuscleController"
			})

			.when("/schedules/", {
				templateUrl : "tpl/views/schedules.html"
				controller : "SchedulesController"
			})

			.when("/features/", {
				templateUrl : "tpl/views/features.html"
				controller : "FeaturesController"
			})

			.otherwise({
				redirectTo: "/"
			})
	])
