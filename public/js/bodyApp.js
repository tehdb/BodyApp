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
    $s.exercises = es.getExercises();
    return $s.muscles = es.getMuscles();
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

angular.module("BodyApp").directive("thChosen", [
  "$q", "$timeout", "$compile", "$templateCache", function(q, to, cpl, tch) {
    return {
      restrict: "A",
      scope: true,
      controller: [
        "$scope", "$element", "$attrs", "$transclude", function(scope, elem, attrs, transclude) {
          return scope.unselect = function(index, event) {
            event.preventDefault();
            event.stopPropagation();
            scope.selected.splice(index, 1);
            return console.log("unselect");
          };
        }
      ],
      templateUrl: "tpl/chosen.tpl.html",
      link: function(scope, elem, attrs) {
        scope.options = scope[attrs.thChosen];
        scope.selected = [
          {
            name: "option 1"
          }, {
            name: "option 2"
          }, {
            name: "option 3"
          }, {
            name: "option 4"
          }, {
            name: "option 5"
          }
        ];
        return elem.click(function(event) {
          console.log("click");
          return false;
        });
      }
    };
  }
]);

angular.module("BodyApp").service("ExercisesService", [
  "Settings", function(st) {
    var _exercises, _muscles;
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
/* Begin: app/database/muscles.json */
    _muscles = [
	{
		"name" : "muscle 1",
		"group" : 1
	},{
		"name" : "muscle 2",
		"group" : 1
	},{
		"name" : "muscle 3",
		"group" : 1
	}
];/* End: app/database/muscles.json */
    return {
      getExercises: function() {
        return _exercises;
      },
      getMuscles: function() {
        return _muscles;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
