angular
	.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate"])
	.constant("Settings", {
		apis : {
			muscle : "/api/muscle/"
			exercise : "/api/exercise/"
		}
	})
	.config( ["$routeProvider", ( rpr ) ->
		rpr
			.when("/", {
				templateUrl: "tpl/home.html",
				controller: "HomeCtrl"
			})

			.when("/exercises", {
				templateUrl: "tpl/exercises.html",
				controller: "ExercisesController"
			})

			.when("/exercise/:id", {
				templateUrl: "tpl/exercise.html",
				controller: "ExerciseCtrl"
			})

			.when("/muscles", {
				templateUrl: "tpl/muscles.html",
				controller: "MusclesController"
			})

			.when("/muscle/:id", {
				templateUrl : "tpl/muscle.html"
				controller : "MuscleController"
			})

			.otherwise({
				redirectTo: "/"
			})
	])
