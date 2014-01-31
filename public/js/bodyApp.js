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
    _exercises = [
      {
        'title': "Exercise 1",
        'descr': "Description 1"
      }, {
        'title': "Exercise 2",
        'descr': "Description 2"
      }, {
        'title': "Exercise 3 Exercise 3 Exercise 3 Exercise 3 Exercise 3",
        'descr': "Description 3 Description 3 Description 3 Description 3 Description 3 Description 3 Description 3"
      }, {
        'title': "Exercise 4",
        'descr': "Description 4"
      }, {
        'title': "Exercise 5",
        'descr': "Description 5"
      }, {
        'title': "Exercise 6",
        'descr': "Description 6"
      }, {
        'title': "Exercise 7",
        'descr': "Description 7"
      }
    ];
    return {
      getAllExercises: function() {
        return _exercises;
      }
    };
  }
]);

//# sourceMappingURL=../../public/js/bodyApp.js.map
