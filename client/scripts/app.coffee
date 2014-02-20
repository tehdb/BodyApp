angular
	.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate"])
	.constant("Settings", {

	})
	.config( ["$routeProvider", ( rpr ) ->
		rpr
			.when("/", {
				templateUrl: "tpl/home.html",
				controller: "HomeCtrl"
			})

			.when("/exercises", {
				templateUrl: "tpl/exercises.html",
				controller: "ExercisesCtrl"
			})

			.when("/exercise/:id", {
				templateUrl: "tpl/exercise.html",
				controller: "ExerciseCtrl"
			})

			.otherwise({
				redirectTo: "/"
			})
	])
