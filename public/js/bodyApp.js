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
    scp.data = {
      exercise: null,
      muscles: null
    };
    es.getExercise(rps.id).then(function(exercise) {
      return scp.data.exercise = exercise;
    });
    es.getMuscles().then(function(muscles) {
      return scp.data.muscles = muscles;
    });
    return scp.submitForm = function() {
      var exercise;
      exercise = _.pick(scp.data.exercise, '_id', 'title', 'descr');
      exercise.muscles = _.pluck(scp.data.exercise.muscles, '_id');
      return es.updateExercise(exercise).then(function(data) {
        return $('#editExerciseModal').modal('hide');
      });
    };
  }
]);

angular.module("BodyApp").controller("ExercisesCtrl", [
  "$scope", "ExercisesService", function(scp, es) {
    scp.title = "exercices";
    scp.data = {
      muscleGroups: es.getMuscleGroups(),
      muscleGroup: null,
      muscles: null,
      exercises: null,
      filtered: null,
      searchText: ''
    };
    scp.data.muscleGroup = scp.data.muscleGroups[0];
    scp.addForm = {
      title: '',
      descr: '',
      muscles: []
    };
    es.getExercises().then(function(data) {
      return scp.data.exercises = data;
    });
    es.getMuscles().then(function(data) {
      return scp.data.muscles = data;
    });
    return scp.submitForm = function() {
      var muscleIds;
      if (scp.exrcForm.$valid && scp.addForm.muscles.length > 0) {
        muscleIds = [];
        _.each(scp.addForm.muscles, function(muscle) {
          return muscleIds.push(muscle._id);
        });
        scp.addForm.muscles = muscleIds;
        return es.addExercise(scp.addForm).then(function(data) {
          scp.data.exercises.push(data);
          scp.addForm = {
            title: '',
            descr: '',
            muscles: []
          };
          return $('#addExerciseModal').modal('hide');
        });
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

angular.module("BodyApp").directive("thDropdown", [
  function() {
    return {
      restrict: "E",
      replace: true,
      scope: {
        options: "=options",
        selected: "=selected",
        "class": "@class"
      },
      templateUrl: "tpl/dropdown.tpl.html",
      link: function(scp, elm, atr) {
        var _$menu;
        scp.hideMenu = true;
        _$menu = $(elm).find('.th-menu');
        scp.select = function(event, idx) {
          event.preventDefault();
          event.stopPropagation();
          scp.selected = scp.options[idx];
          return scp.hideMenu = true;
        };
        return scp.toggle = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.hideMenu = !scp.hideMenu;
        };
      }
    };
  }
]);

angular.module("BodyApp").directive("muscleChosen", [
  "$q", "$timeout", "$compile", "$templateCache", "ExercisesService", function(q, tmt, cpl, tch, es) {
    return {
      restrict: "E",
      scope: {
        options: "=",
        selected: "="
      },
      replace: true,
      templateUrl: "tpl/muscle-chosen.tpl.html",
      link: function(scp, elm, atr) {
        var _$menu, _adjustMenu, _watchForChanges, _watchOptionChanges, _watchSelectedChanges;
        scp.data = {
          available: null,
          searchText: '',
          newMuscle: '',
          muscleGroups: es.getMuscleGroups(),
          muscleGroup: null
        };
        scp.data.muscleGroup = scp.data.muscleGroups[0];
        scp.toggles = {
          showMenu: false,
          showFilter: false,
          showAddForm: false
        };
        _$menu = $(elm).find('.options');
        _adjustMenu = function() {
          var dif, mh, wh;
          _$menu.css('y', 0);
          wh = $(window).height() + $(document).scrollTop();
          mh = _$menu.outerHeight() + _$menu.offset().top + 10;
          dif = wh - mh;
          if (dif < 0) {
            return _$menu.css('y', dif);
          }
        };
        (_watchOptionChanges = function() {
          return scp.$watch('options', function(nv, ov) {
            var filtered;
            if ((nv != null) && (ov == null)) {
              if (_.isArray(scp.selected) && scp.selected.length > 0) {
                filtered = _.filter(nv, function(o) {
                  return !_.contains(_.pluck(scp.selected, '_id'), o._id);
                });
                return scp.data.available = angular.copy(filtered);
              } else {
                return scp.data.available = angular.copy(nv);
              }
            } else if ((nv != null) && (ov != null) && nv !== ov) {
              return scp.data.available.push(angular.copy(_.last(nv)));
            }
          }, true);
        })();
        (_watchSelectedChanges = function() {
          return scp.$watch('selected', function(nv, ov) {
            if ((nv != null ? nv.length : void 0) === 0 && (ov != null ? ov.length : void 0) > 0) {
              return scp.data.available = angular.copy(scp.options);
            }
          }, true);
        })();
        _watchForChanges = function() {
          scp.$watch('[toggles.showMenu, toggles.showFilter, toggles.showAddForm]', function(nv, ov) {
            if (_.contains(nv, true)) {
              return _adjustMenu();
            }
          }, true);
          return scp.$watch('options', function(nv, ov) {
            return _adjustMenu();
          }, true);
        };
        scp.add = function(event) {
          event.preventDefault();
          event.stopPropagation();
          if (scp.data.newMuscle !== '') {
            return es.addMuscle({
              name: scp.data.newMuscle,
              group: scp.data.muscleGroup.id
            }).then(function(data) {
              scp.options.push(data);
              return scp.data.newMuscle = '';
            });
          }
        };
        scp.toggleMenu = function(event) {
          event.preventDefault();
          event.stopPropagation();
          scp.data.searchText = "";
          return scp.toggles.showMenu = !scp.toggles.showMenu;
        };
        scp.toggleFilter = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.toggles.showFilter = !scp.toggles.showFilter;
        };
        scp.toggleAddForm = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.toggles.showAddForm = !scp.toggles.showAddForm;
        };
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
          if (scp.data.searchText !== '') {
            filtered = f("filter")(scp.data.available, scp.data.searchText);
            selected = filtered[index];
            scp.selected.push(selected);
            _ref = scp.data.available;
            for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
              opt = _ref[idx];
              if (opt.$$hashKey === selected.$$hashKey) {
                scp.data.available.splice(idx, 1);
                break;
              }
            }
          } else {
            scp.selected.push(scp.data.available[index]);
            scp.data.available.splice(index, 1);
          }
          return scp.toggles.showMenu = false;
        };
        scp.prevent = function(event) {
          event.preventDefault();
          return event.stopPropagation();
        };
        return scp.clear = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.data.searchText = "";
        };
      }
    };
  }
]);

angular.module("BodyApp").filter("musclegroup", function() {
  return function(exercises, musclegroup) {
    var filtered;
    if ((musclegroup != null ? musclegroup.id : void 0) !== 0) {
      filtered = _.filter(exercises, function(e) {
        return _.contains(_.pluck(e.muscles, 'group'), musclegroup.id);
      });
      return filtered;
    }
    return exercises;
  };
});

angular.module("BodyApp").service("ExercisesService", [
  "$q", "$resource", "$timeout", "$http", "$log", function(q, rsr, tmt, htp, lg) {
    var ExercisesService, _es, _exercises, _muscleGroups, _muscles;
    ExercisesService = (function() {
      function ExercisesService() {
        var that;
        that = this;
        that.$ = $(that);
        that.initialized = false;
        that.$.one('data.loaded', function(event, data) {
          that.data = data;
          that.initialized = true;
          return that.$.trigger('data.ready');
        });
        that.initData();
      }

      ExercisesService.prototype.initData = function() {
        var that;
        that = this;
        return that.getExercisesFromServer().then(function(exercises) {
          return that.getMusclesFromServer().then(function(muscles) {
            _.each(exercises, function(exercise) {
              return exercise.muscles = _.filter(muscles, function(val) {
                return _.contains(exercise.muscles, val._id);
              });
            });
            return that.$.trigger('data.loaded', {
              exercises: exercises,
              muscles: muscles
            });
          });
        });
      };

      ExercisesService.prototype.getExercisesFromServer = function() {
        var deferred;
        deferred = q.defer();
        htp({
          method: "GET",
          url: '/api/exercises/list'
        }).success(function(exercises, status, headers, config) {
          return deferred.resolve(exercises);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      };

      ExercisesService.prototype.getMusclesFromServer = function() {
        var deferred;
        deferred = q.defer();
        htp({
          method: "GET",
          url: '/api/muscles/list'
        }).success(function(muscles, status, headers, config) {
          return deferred.resolve(muscles);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      };

      ExercisesService.prototype.exercises = function(param) {
        var deferred, that;
        that = this;
        deferred = q.defer();
        if (_.isUndefined(param)) {
          if (!that.initialized) {
            that.$.one('data.ready', function(event) {
              return deferred.resolve(that.data.exercises);
            });
          } else {
            deferred.resolve(that.data.exercises);
          }
        } else if (_.isString(param)) {
          if (!that.initialized) {
            that.$.one('data.ready', function(event) {
              var exercise;
              exercise = _.findWhere(that.data.exercises, {
                _id: param
              });
              return deferred.resolve(exercise);
            });
          } else {
            deferred.resolve(that.data.exercises);
          }
        }
        return deferred.promise;
      };

      ExercisesService.prototype.muscles = function(param) {
        var deferred, that;
        that = this;
        deferred = q.defer();
        if (_.isUndefined(param)) {
          if (!that.initialized) {
            that.$.one('data.ready', function(event) {
              return deferred.resolve(that.data.muscles);
            });
          } else {
            deferred.resolve(that.data.muscles);
          }
        }
        return deferred.promise;
      };

      ExercisesService.prototype.exercise12 = function(param) {
        var deferred, e, that;
        if (param == null) {
          param = void 0;
        }
        that = this;
        deferred = q.defer();
        switch (typeof param) {
          case 'string':
            if (that.data.exercises == null) {
              that.exercises().then(function() {
                var e;
                if ((function() {
                  var _i, _len, _ref, _results;
                  _ref = that.data.exercises;
                  _results = [];
                  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    e = _ref[_i];
                    _results.push(e._id === param);
                  }
                  return _results;
                })()) {
                  return deferred.resolve(e);
                }
              });
            } else {
              if ((function() {
                var _i, _len, _ref, _results;
                _ref = that.data.exercises;
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  e = _ref[_i];
                  _results.push(e._id === param);
                }
                return _results;
              })()) {
                deferred.resolve(e);
              }
            }
            break;
          case 'undefined':
            if (that.data.exercises == null) {
              htp({
                method: "GET",
                url: '/api/exercises/list'
              }).success(function(data, status, headers, config) {
                that.data.exercises = data;
                return that.muscles().then(function() {
                  var idx, mid, muscles, _i, _j, _len, _len1, _ref, _ref1;
                  _ref = that.data.exercises;
                  for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
                    e = _ref[idx];
                    muscles = [];
                    _ref1 = e.muscles;
                    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                      mid = _ref1[_j];
                      muscles.push(that.muscle(mid));
                    }
                    that.data.exercises[idx].muscles = muscles;
                  }
                  return deferred.resolve(that.data.exercises);
                });
              }).error(function(data, status, headers, config) {
                return deferred.reject(status);
              });
            } else {
              tmt(function() {
                return deferred.resolve(that.data.exercises);
              }, 0);
            }
            break;
          case 'object':
            if (param instanceof Object) {
              htp({
                method: "POST",
                url: "/api/exercises/add",
                data: param,
                headers: {
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Accept': 'application/json, text/plain, */*'
                }
              }).success(function(exercise, status, headers, config) {
                var mid, muscles, _i, _len, _ref;
                muscles = [];
                _ref = exercise.muscles;
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  mid = _ref[_i];
                  muscles.push(that.muscle(mid));
                }
                exercise.muscles = muscles;
                return deferred.resolve(exercise);
              }).error(function(data, status, headers, config) {
                return deferred.reject(status);
              });
            } else if (param instanceof Array) {
              console.log('get exercises by ids');
            }
        }
        return deferred.promise;
      };

      ExercisesService.prototype.muscle = function(id) {
        var muscle, that, _i, _len, _ref;
        if (id == null) {
          id = null;
        }
        that = this;
        if (id != null) {
          _ref = that.data.muscles;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            muscle = _ref[_i];
            if (muscle._id === id) {
              return {
                _id: muscle._id,
                name: muscle.name,
                group: muscle.group
              };
            }
          }
          return null;
        } else {
          return null;
        }
      };

      ExercisesService.prototype.apply = function(cb) {
        if (this.initialized) {
          return cb();
        } else {
          return this.$.one('data.ready', function() {
            return cb();
          });
        }
      };

      ExercisesService.prototype.upsertExercise = function(action, exercise, deferred) {
        var that;
        that = this;
        return htp({
          method: "POST",
          url: "/api/exercises/add",
          data: exercise,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json, text/plain, */*'
          }
        }).success(function(exercise, status, headers, config) {
          exercise.muscles = _.filter(_es.data.muscles, function(val) {
            return _.contains(exercise.muscles, val._id);
          });
          switch (action) {
            case 'insert':
              that.data.exercises.push(exercise);
              break;
            case 'update':
              _.each(that.data.exercises, function(element, index) {
                if (element._id === exercise._id) {
                  return that.data.exercises[index] = exercise;
                }
              });
          }
          return deferred.resolve(_.clone(exercise));
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
      };

      return ExercisesService;

    })();
    _es = new ExercisesService();
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
		"id" : 0,
		"name" : "entire"
	},{
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
      getExercises: function() {
        var deferred;
        deferred = q.defer();
        _es.apply(function() {
          return deferred.resolve(_.clone(_es.data.exercises));
        });
        return deferred.promise;
      },
      getExercise: function(id) {
        var deferred;
        deferred = q.defer();
        _es.apply(function() {
          return deferred.resolve(_.clone(_.findWhere(_es.data.exercises, {
            _id: id
          })));
        });
        return deferred.promise;
      },
      addMuscle: function(muscle) {
        var deferred;
        deferred = q.defer();
        htp({
          method: "POST",
          url: "/api/muscles/add",
          data: muscle,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json, text/plain, */*'
          }
        }).success(function(muscle, status, headers, config) {
          _es.data.muscles.push(muscle);
          return deferred.resolve(_.clone(muscle));
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      },
      addExercise: function(exercise) {
        var deferred;
        deferred = q.defer();
        _es.upsertExercise("insert", exercise, deferred);
        return deferred.promise;
      },
      updateExercise: function(exercise) {
        var deferred;
        deferred = q.defer();
        _es.upsertExercise("update", exercise, deferred);
        return deferred.promise;
      },
      getMuscles: function() {
        var deferred;
        deferred = q.defer();
        _es.apply(function() {
          return deferred.resolve(_.clone(_es.data.muscles));
        });
        return deferred.promise;
      },
      getMuscle: function(id) {
        return _es.muscles(id);
      },
      getMuscleGroups: function() {
        return _muscleGroups;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
