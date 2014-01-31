angular
	.module("BodyApp", ["ngRoute"])
	.constant("Settings", {

	})
	.config( ["$routeProvider", ( $rp ) ->
		$rp.when("/", {
			templateUrl: "tpl/home.html",
			controller: "HomeCtrl"
		}).when("/exercises", {
			templateUrl: "tpl/exercises.html",
			controller: "ExercisesCtrl"
		}).otherwise({
			redirectTo: "/"
 		})
	])
