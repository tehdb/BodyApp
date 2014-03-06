angular.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate"]).constant("Settings", {}).config([
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
  "$scope", "$routeParams", "$location", "ExercisesService", "SetsService", function(scp, rps, lcn, es, ss) {
    var _hideEditExerciseModal, _init;
    scp.data = {
      exercise: null,
      muscles: null,
      completable: false,
      sets: null,
      set: {
        value: null,
        index: 0
      },
      upsertModal: {
        show: false,
        pos: null,
        confirmed: false,
        set: null
      }
    };
    (_init = function() {
      return es.getExercise(rps.id).then(function(exercise) {
        scp.data.exercise = exercise;
        es.getMuscles().then(function(muscles) {
          return scp.data.muscles = muscles;
        });
        return ss.getLast(scp.data.exercise._id).then(function(sets) {
          scp.data.sets = sets;
          scp.data.set.value = scp.data.sets[scp.data.set.index];
          return scp.data.upsertModal.set = angular.copy(scp.data.set.value);
        });
      });
    })();
    scp.$watch("data.upsertModal.confirmed", function(nv, ov) {
      if (nv === true) {
        if (scp.data.completable === false) {
          scp.data.completable = true;
        }
        scp.data.set.value.heft = scp.data.upsertModal.set.heft;
        scp.data.set.value.reps = scp.data.upsertModal.set.reps;
        scp.data.set.value.type = "complete";
        if (++scp.data.set.index > scp.data.sets.length - 1) {
          scp.data.sets.push({
            idx: scp.data.set.index + 1,
            heft: scp.data.set.value.heft,
            reps: scp.data.set.value.reps
          });
        }
        scp.data.set.value = scp.data.sets[scp.data.set.index];
        scp.data.upsertModal.set = angular.copy(scp.data.set.value);
        scp.data.upsertModal.show = false;
        return scp.data.upsertModal.confirmed = false;
      }
    });
    _hideEditExerciseModal = function(cb) {
      var modal;
      modal = $('#editExerciseModal').modal('hide');
      if (_.isFunction(cb)) {
        return modal.one('hidden.bs.modal', function() {
          return cb();
        });
      }
    };
    scp.toggleUpsertModal = function(event) {
      event.preventDefault();
      event.stopPropagation();
      scp.data.upsertModal.show = !scp.data.upsertModal.show;
      return scp.data.upsertModal.pos = [event.pageX, event.pageY];
    };
    scp.complete = function() {
      var c, completed, i, _i, _len;
      completed = _.where(scp.data.sets, {
        type: "complete"
      });
      for (i = _i = 0, _len = completed.length; _i < _len; i = ++_i) {
        c = completed[i];
        completed[i] = _.pick(c, "idx", "heft", "reps");
      }
      return ss.add(scp.data.exercise._id, completed).then(function(sets) {
        scp.data.sets = sets;
        scp.data.set.index = 0;
        scp.data.set.value = scp.data.sets[scp.data.set.index];
        scp.data.upsertModal.set = angular.copy(scp.data.set.value);
        return scp.data.completable = false;
      });
    };
    scp.submitForm = function() {
      var exercise;
      exercise = _.pick(scp.data.exercise, '_id', 'title', 'descr');
      exercise.muscles = _.pluck(scp.data.exercise.muscles, '_id');
      return es.updateExercise(exercise).then(function(data) {
        return _hideEditExerciseModal();
      });
    };
    return scp.deleteExercise = function(event) {
      event.preventDefault();
      event.stopPropagation();
      return es.deleteExercise(scp.data.exercise._id).then(function(data) {
        return _hideEditExerciseModal(function() {
          return scp.safeApply(function() {
            return lcn.path('/exercises');
          });
        });
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
      filtered: [],
      searchText: '',
      addExerciseModal: {
        show: false,
        confirmed: false
      }
    };
    scp.data.muscleGroup = scp.data.muscleGroups[0];
    scp.addForm = {
      title: '',
      descr: '',
      muscles: []
    };
    es.getExercises().then(function(data) {
      console.log(data);
      return scp.data.exercises = data;
    })["catch"](function() {
      return console.log("cant load data");
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
          filtered: null,
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
          var idx, opt, selected, _i, _len, _ref;
          event.preventDefault();
          event.stopPropagation();
          if (scp.data.searchText !== '') {
            selected = scp.data.filtered[index];
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

angular.module("BodyApp").directive("thModal", [
  "$q", "$timeout", function(q, tmt) {
    return {
      restrict: "E",
      scope: {
        title: "@",
        show: "=",
        pos: "=",
        confirm: "="
      },
      replace: true,
      transclude: true,
      templateUrl: "tpl/th-modal.tpl.html",
      link: function(scp, elm, atr) {
        var _$content;
        _$content = elm.find('.th-modal-content:first');
        scp.data = {
          confirmable: false
        };
        scp.apply = function(event) {
          event.preventDefault();
          event.stopPropagation();
          if (scp.confirm != null) {
            scp.confirm = true;
          }
          return scp.show = false;
        };
        scp.cancel = function(event) {
          event.preventDefault();
          event.stopPropagation();
          if (scp.confirm != null) {
            scp.confirm = false;
          }
          return scp.show = false;
        };
        return scp.$watch("show", function(nv, ov) {
          var y, _ref;
          if (nv === true) {
            if (_.isBoolean(scp.confirm)) {
              scp.data.confirmable = true;
            }
            y = (_ref = scp.pos) != null ? _ref[1] : void 0;
            if (_.isNumber(y) && y > 10) {
              y -= Math.round(_$content.height() / 2);
              return _$content.css({
                y: y
              });
            }
          }
        });
      }
    };
  }
]);

angular.module("BodyApp").directive("thNumberInput", [
  "$q", "$timeout", function(q, tmt) {
    return {
      restrict: "E",
      scope: {
        value: "=",
        "class": "@",
        step: "@"
      },
      replace: true,
      transclude: false,
      templateUrl: "tpl/th-number-input.tpl.html",
      link: function(scp, elm, atr) {
        scp.increment = function() {
          if (!_.isNumber(scp.value)) {
            scp.value = parseFloat(scp.value, 10);
          }
          return scp.value += parseFloat(scp.step, 10) || 1;
        };
        return scp.decrement = function() {
          if (!_.isNumber(scp.value)) {
            scp.value = parseFloat(scp.value, 10);
          }
          return scp.value -= parseFloat(scp.step, 10) || 1;
        };
      }
    };
  }
]);

angular.module("BodyApp").filter("heft", function() {
  return function(val, type) {
    return "" + val + " kg";
  };
});

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
  "$q", "$timeout", "$http", function(q, tmt, htp) {
    var ExercisesService, _es, _muscleGroups;
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
              return exercise.muscles = _.clone(_.filter(muscles, function(val) {
                return _.contains(exercise.muscles, val._id);
              }));
            });
            return that.$.trigger('data.loaded', {
              exercises: exercises,
              muscles: muscles
            });
          });
        })["catch"](function() {
          return console.log("was nun?");
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

      ExercisesService.prototype.apply = function(cb) {
        if (this.initialized) {
          return cb();
        } else {
          return this.$.one('data.ready', function() {
            return cb();
          });
        }
      };

      ExercisesService.prototype.upsert = function(action, exercise, deferred) {
        var that;
        that = this;
        return htp({
          method: "POST",
          url: "/api/exercises/upsert",
          data: exercise,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json, text/plain, */*'
          }
        }).success(function(exercise, status, headers, config) {
          var e, eidx, _i, _len, _ref;
          exercise.muscles = angular.copy(_.filter(_es.data.muscles, function(val) {
            return _.contains(exercise.muscles, val._id);
          }));
          switch (action) {
            case 'insert':
              that.data.exercises.push(exercise);
              break;
            case 'update':
              _ref = that.data.exercises;
              for (eidx = _i = 0, _len = _ref.length; _i < _len; eidx = ++_i) {
                e = _ref[eidx];
                if (e._id === exercise._id) {
                  that.data.exercises[eidx] = exercise;
                  break;
                }
              }
          }
          return deferred.resolve(exercise);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
      };

      ExercisesService.prototype["delete"] = function(id, deferred) {
        var that;
        that = this;
        return htp({
          method: "POST",
          url: "/api/exercises/delete/" + id,
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json, text/plain, */*'
          }
        }).success(function(data, status, headers, config) {
          var e, eidx, _i, _len, _ref;
          _ref = that.data.exercises;
          for (eidx = _i = 0, _len = _ref.length; _i < _len; eidx = ++_i) {
            e = _ref[eidx];
            if (e._id === id) {
              that.data.exercises.splice(eidx, 1);
              break;
            }
          }
          return deferred.resolve(true);
        }).error(function(data, status, headers, config) {
          return deferred.reject(false);
        });
      };

      return ExercisesService;

    })();
    _es = new ExercisesService();
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
          return deferred.resolve(_es.data.exercises);
        });
        return deferred.promise;
      },
      getExercise: function(id) {
        var deferred;
        deferred = q.defer();
        _es.apply(function() {
          return deferred.resolve(_.findWhere(_es.data.exercises, {
            _id: id
          }));
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
          return deferred.resolve(muscle);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      },
      addExercise: function(exercise) {
        var deferred;
        deferred = q.defer();
        _es.upsert("insert", exercise, deferred);
        return deferred.promise;
      },
      updateExercise: function(exercise) {
        var deferred;
        deferred = q.defer();
        _es.upsert("update", exercise, deferred);
        return deferred.promise;
      },
      deleteExercise: function(id) {
        var deferred;
        deferred = q.defer();
        _es["delete"](id, deferred);
        return deferred.promise;
      },
      getMuscles: function() {
        var deferred;
        deferred = q.defer();
        _es.apply(function() {
          return tmt(function() {
            return deferred.resolve(_es.data.muscles);
          }, 0);
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

angular.module("BodyApp").service("SetsService", [
  "$q", "$timeout", "$http", function(q, tmt, htp) {
    var Service, _s;
    Service = (function() {
      function Service() {}

      Service.prototype.getExerciseSets = function() {
        return [
          {
            idx: 1,
            heft: 50,
            reps: 10
          }
        ];
      };

      return Service;

    })();
    _s = new Service();
    return {
      getLast: function(exerciseId) {
        var deferred;
        deferred = q.defer();
        tmt(function() {
          console.log(exerciseId);
          return deferred.resolve(_s.getExerciseSets());
        }, 0);
        return deferred.promise;
      },
      add: function(exerciseId, sets) {
        var deferred;
        deferred = q.defer();
        tmt(function() {
          console.log("save set", exerciseId, sets);
          return deferred.resolve(sets);
        }, 0);
        return deferred.promise;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
