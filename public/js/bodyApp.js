angular.module("BodyApp", ["ngRoute"]).constant("Settings", {}).config([
  "$routeProvider", function($rp) {
    return $rp.when("/", {
      templateUrl: "tpl/home.html",
      controller: "HomeCtrl"
    }).when("/exercises", {
      templateUrl: "tpl/exercises.html",
      controller: "ExercisesCtrl"
    }).otherwise({
      redirectTo: "/"
    });
  }
]);

angular.module("BodyApp").controller("ExercisesCtrl", [
  "$scope", "ExercisesService", function($s, es) {
    $s.title = "exercices";
    return $s.exercises = es.getAllExercises();
  }
]);

angular.module("BodyApp").controller("HomeCtrl", [
  "$scope", function($s) {
    return $s.title = "home";
  }
]);

angular.module("BodyApp").controller("MainCtrl", [
  "$scope", function($s) {
    return $s.title = "main ctrl title";
  }
]);

angular.module("BodyApp").service("ExercisesService", [
  "Settings", function(st) {
    var _exercises;
/* Begin: app/database/exercises.json */
    _exercises = [
	{
		"title" : "Lorem ipsum dolor sit.",
		"descr" : ""
	},{
		"title" : "Lorem ipsum dolor sit amet, consectetur.",
		"descr" : ""
	},{
		"title" : "Lorem ipsum dolor sit.",
		"descr" : ""
	}
]
;/* End: app/database/exercises.json */
    return {
      getAllExercises: function() {
        return _exercises;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
