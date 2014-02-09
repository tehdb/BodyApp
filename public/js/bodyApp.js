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
    $s.muscles = es.getMuscles();
    return $s.muscleGroups = es.getMuscleGroups();
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
          return scope.add = function(event) {
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
        }
      ],
      templateUrl: "tpl/chosen.tpl.html",
      link: function(scope, elem, attrs) {
        var Link;
        Link = (function() {
          function Link() {
            var that;
            that = this;
            that.menu = elem.find('.options');
            scope.options = scope[attrs.thChosen];
            scope.addform = scope[attrs.thChosenAddform];
            scope.selected = [];
            scope.searchText = '';
            scope.newElement = '';
            scope.showmenu = false;
            elem.click(function(event) {
              event.preventDefault();
              event.stopPropagation();
              return that.toggleMenu();
            });
          }

          Link.prototype.toggleMenu = function() {
            var that;
            that = this;
            return scope.safeApply(function() {
              scope.searchText = "";
              scope.showmenu = !scope.showmenu;
              if (scope.showmenu) {
                return to(function() {
                  var mh, mot, wh, wot, y;
                  wh = $(window).height() - 60;
                  wot = $(document).scrollTop();
                  mh = that.menu.outerHeight();
                  mot = that.menu.parent().offset().top;
                  if (mot + mh > wot + wh) {
                    y = -((mot + mh) - (wot + wh));
                    return that.menu.css('top', y + "px");
                  } else {
                    return that.menu.css('top', "100%");
                  }
                }, 0);
              }
            });
          };

          return Link;

        })();
        return (function() {
          return new Link;
        })();
      }
    };
  }
]);

angular.module("BodyApp").directive("thDropdown", [
  "$q", "$timeout", function($q, $to) {
    return {
      restrict: "A",
      scope: true,
      link: function($s, $e, $a) {
        var Link;
        Link = (function() {
          function Link() {
            $s.selected = "button";
            $e.addClass('th-dropdown');
            this.label = angular.element("<span>").addClass("th-label").text($s.selected);
            this.menu = angular.element("<ul>").addClass("th-menu").hide().appendTo($e);
            this.initToggle();
            this.initMenu();
          }

          Link.prototype.initMenu = function() {
            var idx, opt, options, that, _i, _len, _results;
            that = this;
            options = $s[$a.thDropdown];
            _results = [];
            for (idx = _i = 0, _len = options.length; _i < _len; idx = ++_i) {
              opt = options[idx];
              _results.push(angular.element("<li>").addClass("th-option").text(opt.name).appendTo(this.menu).click(function(event) {
                var target;
                event.preventDefault();
                event.stopPropagation();
                target = $(this);
                $s.selected = target.text();
                that.label.text($s.selected);
                return that.menu.hide();
              }));
            }
            return _results;
          };

          Link.prototype.initToggle = function() {
            var that;
            that = this;
            return angular.element("<button>").addClass('btn btn-default dropdown-toggle th-toggle').attr("type", "button").append(that.label).append('<span class="caret"></span>').click(function(event) {
              event.preventDefault();
              event.stopPropagation();
              return that.toggleMenu();
            }).appendTo($e);
          };

          Link.prototype.toggleMenu = function() {
            var mh, mot, mw, that, wh, wot, y;
            that = this;
            if (that.menu.is(':visible')) {
              return that.menu.hide();
            } else {
              that.menu.show();
              mw = that.menu.outerWidth();
              mh = that.menu.outerHeight();
              mot = that.menu.parent().offset().top;
              wh = $(window).height() - 60;
              wot = $(document).scrollTop();
              if (mot + mh > wot + wh) {
                y = -((mot + mh) - (wot + wh));
                return that.menu.css('top', y + "px");
              } else {
                return that.menu.css('top', "100%");
              }
            }
          };

          return Link;

        })();
        return (function() {
          return new Link();
        })();
      }
    };
  }
]);

angular.module("BodyApp").service("ExercisesService", [
  "Settings", function(st) {
    var _exercises, _muscleGroups, _muscles;
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
		"name" : "muscle 5",
		"group" : 1
	},{
		"name" : "muscle 6",
		"group" : 1
	}
]
;/* End: app/database/muscles.json */
/* Begin: app/database/musclegroups.json */
    _muscleGroups = [
	{
		"id" : 1,
		"name" : "shoulders"
	},{
		"id" : 2,
		"name" : "chest"
	},{
		"id" : 3,
		"name" : "arms"
	},{
		"id" : 4,
		"name" : "abdomen"
	},{
		"id" : 5,
		"name" : "back"
	},{
		"id" : 6,
		"name" : "buttocks"
	},{
		"id" : 7,
		"name" : "legs"
	}
]
;/* End: app/database/musclegroups.json */
    return {
      getExercises: function() {
        return _exercises;
      },
      getMuscles: function() {
        return _muscles;
      },
      getMuscleGroups: function() {
        return _muscleGroups;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
