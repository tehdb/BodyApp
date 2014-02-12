angular.module("BodyApp", ["ngRoute", "ngResource"]).constant("Settings", {}).config([
  "$routeProvider", function(rpr) {
    return rpr.when("/", {
      templateUrl: "tpl/home.html",
      controller: "HomeCtrl"
    }).when("/exercises", {
      templateUrl: "tpl/exercises.html",
      controller: "ExercisesCtrl"
    }).when("/exercise/:id", {
      templateUrl: "tpl/exercise.html",
      controller: "ExerciseCtrl"
    }).otherwise({
      redirectTo: "/"
    });
  }
]);

angular.module("BodyApp").controller("ExerciseCtrl", [
  "$scope", "$routeParams", "ExercisesService", function(scp, rps, es) {
    scp.exercise = es.getExercise(rps.id);
    return scp.exercise.$promise.then(function(data) {
      return scp.muscles = es.getMusclesByIds(data.muscles);
    });
  }
]);

angular.module("BodyApp").controller("ExercisesCtrl", [
  "$scope", "ExercisesService", function(scp, es) {
    scp.title = "exercices";
    scp.exercises = es.getExercises('dynamic');
    scp.muscles = es.getMuscles('dynamic');
    scp.muscleGroups = es.getMuscleGroups();
    scp.temp = [
      {
        name: "bla"
      }
    ];
    scp.formData = {
      title: '',
      descr: '',
      muscles: null
    };
    scp.$on('chosen.update', function(event, data) {
      var muscle, muscleIds, _i, _len, _ref;
      event.preventDefault();
      event.stopPropagation();
      muscleIds = [];
      _ref = data[0];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        muscle = _ref[_i];
        muscleIds.push(muscle._id);
      }
      return scp.formData.muscles = muscleIds;
    });
    scp.$on('chosen.add', function(event, data) {
      event.preventDefault();
      event.stopPropagation();
      return es.addMuscle({
        "name": data[0].name,
        "group": data[0].group
      }).then(function(res) {
        return data[0]._id = res.message;
      });
    });
    return scp.submitForm = function() {
      if (scp.exrcForm.$valid && (scp.formData.muscles != null)) {
        scp.exercises.push(scp.formData);
        es.addExercise(scp.formData);
        scp.formData = {
          title: '',
          descr: '',
          muscles: null
        };
        $('#addExerciseModal').modal('hide');
        return scp.$broadcast('form.submit');
      }
    };
  }
]);

angular.module("BodyApp").controller("HomeCtrl", [
  "$scope", function($s) {
    return $s.title = "home";
  }
]);

angular.module("BodyApp").controller("MainCtrl", [
  "$scope", function(scp) {
    scp.title = "main ctrl title";
    scp.sidebarShow = false;
    scp.toggleSidebar = function(param) {
      if ((param != null) && typeof param === 'boolean') {
        return scp.sidebarShow = param;
      } else {
        return scp.sidebarShow = !scp.sidebarShow;
      }
    };
    return scp.safeApply = function(fn) {
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
  "$q", "$timeout", "$compile", "$templateCache", "$filter", function(q, to, cpl, tch, f) {
    return {
      restrict: "A",
      scope: true,
      controller: [
        "$scope", "$element", "$attrs", "$transclude", function(scp, elm, atr, trs) {
          var _selectedMuscleGroup;
          _selectedMuscleGroup = 0;
          scp.$on('dropdown.select', function(event, data) {
            event.preventDefault();
            event.stopPropagation();
            return _selectedMuscleGroup = data[0];
          });
          scp.unselect = function(index, event) {
            event.preventDefault();
            event.stopPropagation();
            scp.options.push(scp.selected[index]);
            return scp.selected.splice(index, 1);
          };
          scp.select = function(index, event) {
            var filtered, idx, opt, selected, _i, _len, _ref;
            event.preventDefault();
            event.stopPropagation();
            if (scp.searchText !== '') {
              filtered = f("filter")(scp.options, scp.searchText);
              selected = filtered[index];
              scp.selected.push(selected);
              _ref = scp.options;
              for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
                opt = _ref[idx];
                if (opt.$$hashKey === selected.$$hashKey) {
                  scp.options.splice(idx, 1);
                  break;
                }
              }
            } else {
              scp.selected.push(scp.options[index]);
              scp.options.splice(index, 1);
            }
            scp.showmenu = false;
            return scp.$emit('chosen.update', [scp.selected]);
          };
          scp.prevent = function(event) {
            event.preventDefault();
            return event.stopPropagation();
          };
          scp.clear = function(event) {
            event.preventDefault();
            event.stopPropagation();
            return scp.searchText = "";
          };
          return scp.add = function(event) {
            var opt;
            event.preventDefault();
            event.stopPropagation();
            if (scp.newElement !== '' && _selectedMuscleGroup !== 0) {
              opt = {
                name: scp.newElement,
                group: _selectedMuscleGroup
              };
              scp.options.push(opt);
              scp.newElement = '';
              return scp.$emit('chosen.add', [opt]);
            }
          };
        }
      ],
      templateUrl: "tpl/chosen.tpl.html",
      link: function(scp, elm, atr) {
        var Link;
        Link = (function() {
          function Link() {
            var that;
            that = this;
            that.menu = elm.find('.options');
            scp.options = scp[atr.thChosen];
            scp.addform = scp[atr.thChosenAddform];
            scp.selected = [];
            scp.searchText = '';
            scp.newElement = '';
            scp.showmenu = false;
            elm.click(function(event) {
              event.preventDefault();
              event.stopPropagation();
              return that.toggleMenu();
            });
            scp.$on('form.submit', function(event, data) {
              scp.options = scp.options.concat(scp.selected);
              return scp.selected = [];
            });
          }

          Link.prototype.toggleMenu = function() {
            var that;
            that = this;
            return scp.safeApply(function() {
              scp.searchText = "";
              scp.showmenu = !scp.showmenu;
              if (scp.showmenu) {
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
  function() {
    return {
      restrict: "A",
      scope: true,
      link: function(scp, elm, atr) {
        var Link;
        Link = (function() {
          function Link() {
            scp.selected = "button";
            elm.addClass('th-dropdown');
            this.label = angular.element("<span>").addClass("th-label").text(scp.selected);
            this.menu = angular.element("<ul>").addClass("th-menu").hide().appendTo(elm);
            this.initToggle();
            this.initMenu();
          }

          Link.prototype.initMenu = function() {
            var idx, opt, options, that, _i, _len, _results;
            that = this;
            options = scp[atr.thDropdown];
            if (!options) {
              return;
            }
            _results = [];
            for (idx = _i = 0, _len = options.length; _i < _len; idx = ++_i) {
              opt = options[idx];
              _results.push(angular.element("<li>").addClass("th-option").data('id', opt.id).text(opt.name).appendTo(this.menu).click(function(event) {
                var target;
                event.preventDefault();
                event.stopPropagation();
                target = $(this);
                scp.selected = target.text();
                that.label.text(scp.selected);
                scp.$emit('dropdown.select', [target.data('id')]);
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
            }).appendTo(elm);
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
  "$q", "$resource", function(q, rsr) {
    var _exercises, _muscleGroups, _muscles;
/* Begin: client/database/exercises.json */
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
;/* End: client/database/exercises.json */
/* Begin: client/database/muscles.json */
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
;/* End: client/database/muscles.json */
/* Begin: client/database/musclegroups.json */
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
;/* End: client/database/musclegroups.json */
    return {
      getExercises: function(type) {
        switch (type) {
          case 'dynamic':
            return rsr('/api/exercises/list').query();
          case 'static':
            return _exercises;
        }
      },
      getMuscles: function(type) {
        switch (type) {
          case 'dynamic':
            return rsr('/api/muscles/list').query();
          case 'static':
            return _muscles;
        }
      },
      getMusclesByIds: function(ids) {
        return rsr('/api/muscles/get/:ids').query({
          'ids': ids.join(',')
        });
      },
      getMuscleGroups: function() {
        return _muscleGroups;
      },
      getExercise: function(id) {
        return rsr('/api/exercises/get/:id').get({
          'id': id
        });
      },
      addExercise: function(exercise) {
        return rsr('/api/exercises/add').save(exercise);
      },
      addMuscle: function(muscle) {
        return rsr('api/muscles/add').save(muscle).$promise;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
