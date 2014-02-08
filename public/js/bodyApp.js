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
    $s.title = "main ctrl title";
    return $s.safeApply = function(fn) {
      var phase;
      phase = this.$root.$$phase;
      if (phase === '$apply' || phase === '$digest') {
        if (fn && typeof fn === 'function') {
          return fn();
        }
      } else {
        return this.$apply(fn);
      }
    };
  }
]);

angular.module("BodyApp").directive("thChosen", [
  "$q", "$timeout", "$compile", "$templateCache", function(q, to, cpl, tch) {
    return {
      restrict: "A",
      scope: true,
      controller: [
        "$scope", "$element", "$attrs", "$transclude", function(scope, elem, attrs, transclude) {
          scope.unselect = function(index, event) {
            event.preventDefault();
            event.stopPropagation();
            scope.options.push(scope.selected[index]);
            return scope.selected.splice(index, 1);
          };
          scope.select = function(index, event) {
            event.preventDefault();
            event.stopPropagation();
            scope.selected.push(scope.options[index]);
            scope.options.splice(index, 1);
            return scope.showmenu = false;
          };
          scope.prevent = function(event) {
            event.preventDefault();
            return event.stopPropagation();
          };
          scope.clear = function(event) {
            event.preventDefault();
            event.stopPropagation();
            return scope.searchText = "";
          };
          scope.add = function(event) {
            event.preventDefault();
            event.stopPropagation();
            if (scope.newElement !== '') {
              scope.options.push({
                name: scope.newElement,
                group: 1
              });
              return scope.newElement = '';
            }
          };
          return scope.dropdown = function(event) {
            event.preventDefault();
            event.stopPropagation();
            return console.log($(event.currentTarget));
          };
        }
      ],
      templateUrl: "tpl/chosen.tpl.html",
      link: function(scope, elem, attrs) {
        scope.options = scope[attrs.thChosen];
        scope.selected = [];
        scope.searchText = '';
        scope.newElement = '';
        scope.showmenu = false;
        return elem.click(function(event) {
          scope.safeApply(function() {
            scope.searchText = "";
            return scope.showmenu = !scope.showmenu;
          });
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
	},{
		"name" : "muscle 4",
		"group" : 1
	},{
		"name" : "muscle 5 muscle 5 muscle 5 muscle 5 muscle 5",
		"group" : 1
	},{
		"name" : "muscle6muscle6muscle6muscle6muscle6muscle6muscle6muscle6muscle6muscle6muscle6",
		"group" : 1
	}
]
;/* End: app/database/muscles.json */
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
