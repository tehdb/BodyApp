angular.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate"]).constant("Settings", {
  apis: {
    muscle: "/api/muscle/",
    exercise: "/api/exercise/"
  }
}).config([
  "$routeProvider", function(rpr) {
    return rpr.when("/", {
      templateUrl: "tpl/home.html",
      controller: "HomeCtrl"
    }).when("/exercises", {
      templateUrl: "tpl/exercises.html",
      controller: "ExercisesController"
    }).when("/exercise/:id", {
      templateUrl: "tpl/exercise.html",
      controller: "ExerciseCtrl"
    }).when("/muscles", {
      templateUrl: "tpl/muscles.html",
      controller: "MusclesController"
    }).when("/muscle/:id", {
      templateUrl: "tpl/muscle.html",
      controller: "MuscleController"
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

angular.module("BodyApp").controller("ExercisesController", [
  "$scope", "ExercisesService", "MusclesService", function(scope, exercisesService, musclesService) {
    scope.data = {
      title: "exercices",
      exercises: [],
      muscleGroup: musclesService.getGroups()[0],
      muscleGroups: musclesService.getGroups(),
      newExercise: {},
      showAddExerciseModal: false
    };
    exercisesService.getAll().then(function(data) {
      return scope.data.exercises = data;
    });
    return scope.submitAddExerciseForm = function() {
      var exercise;
      exercise = scope.data.newExercise;
      exercise.muscles = _.pluck(exercise.muscles, '_id');
      return exercisesService.upsert(exercise).then(function(data) {
        scope.data.newExercise = {};
        return scope.data.showAddExerciseModal = false;
      });
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

angular.module("BodyApp").controller("MuscleController", [
  "$scope", "$routeParams", "ExercisesService", "MusclesService", function(scope, params, exercisesService, musclesService) {
    scope.data = {};
    return musclesService.getById(params.id).then(function(data) {
      scope.data.muscle = data;
      return scope.data.muscle.group = musclesService.getGroupById(data.group);
    });
  }
]);

angular.module("BodyApp").controller("MusclesController", [
  "$scope", "ExercisesService", "MusclesService", function(scope, exercisesService, musclesService) {
    var _ref, _ref1;
    scope.data = {
      title: "muscles",
      muscles: [],
      filtered: null,
      muscleGroup: (_ref = musclesService.getGroups()) != null ? _ref[0] : void 0,
      muscleGroups: musclesService.getGroups(),
      showMuscleModal: false,
      edit: false,
      form: {
        group: (_ref1 = musclesService.getGroups()) != null ? _ref1[0] : void 0,
        update: false
      }
    };
    console.log(musclesService.getGroups());
    musclesService.getAll().then(function(data) {
      return scope.data.muscles = data;
    });
    scope.insertModal = function() {
      var _ref2;
      scope.data.form = {
        group: (_ref2 = musclesService.getGroups()) != null ? _ref2[0] : void 0,
        name: '',
        update: false
      };
      return scope.data.showMuscleModal = true;
    };
    scope.upsertModal = function(index) {
      var muscle;
      muscle = scope.data.filtered[index];
      scope.data.form = {
        _id: muscle._id,
        group: _.findWhere(scope.data.muscleGroups, {
          id: muscle.group
        }),
        name: muscle.name,
        update: true
      };
      return scope.data.showMuscleModal = true;
    };
    scope.remove = function() {
      var data;
      data = _.omit(scope.data.form, 'update');
      data.group = data.group.id;
      return musclesService.remove(data).then(function(data) {
        var _ref2;
        scope.data.form = {
          group: (_ref2 = musclesService.getGroups()) != null ? _ref2[0] : void 0,
          update: false
        };
        return scope.data.showMuscleModal = false;
      });
    };
    return scope.upsert = function() {
      var data;
      data = _.omit(scope.data.form, 'update');
      data.group = data.group.id;
      return musclesService.upsert(data).then(function(data) {
        scope.data.form.name = '';
        return scope.data.showMuscleModal = false;
      });
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
  "$q", "$timeout", "$compile", "MusclesService", function(q, tmt, cpl, musclesService) {
    return {
      restrict: "E",
      scope: {
        selected: "="
      },
      replace: true,
      templateUrl: "tpl/muscle-chosen.tpl.html",
      link: function(scp, elm, atr) {
        var _$menu, _adjustMenu, _watchForChanges, _watchOptionChanges, _watchSelectedChanges;
        scp.data = {
          available: [],
          filtered: null,
          searchText: '',
          newMuscle: '',
          muscleGroups: musclesService.getGroups(),
          muscleGroup: musclesService.getGroups()[0],
          toggles: {
            showMenu: false,
            showFilter: false,
            showAddForm: false
          }
        };
        scp.selected = scp.selected || [];
        musclesService.getAll().then(function(data) {
          return scp.options = data;
        });
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
          return scp.$watch('selected', function(newVal) {
            if (_.isUndefined(newVal)) {
              return scp.data.available = angular.copy(scp.options);
            }
          });
        })();
        _watchForChanges = function() {
          scp.$watch('[data.toggles.showMenu, data.toggles.showFilter, data.toggles.showAddForm]', function(nv, ov) {
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
          return musclesService.upsert({
            name: scp.data.newMuscle,
            group: scp.data.muscleGroup.id
          }).then(function(data) {
            scp.options.push(data);
            return scp.data.newMuscle = '';
          });
        };
        scp.toggleMenu = function(event) {
          event.preventDefault();
          event.stopPropagation();
          scp.data.searchText = "";
          return scp.data.toggles.showMenu = !scp.data.toggles.showMenu;
        };
        scp.toggleFilter = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.data.toggles.showFilter = !scp.data.toggles.showFilter;
        };
        scp.toggleAddForm = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scp.data.toggles.showAddForm = !scp.data.toggles.showAddForm;
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
          scp.selected = scp.selected || [];
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
          return scp.data.toggles.showMenu = false;
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
  return function(list, groupId, type) {
    var filtered;
    if (groupId !== 0) {
      switch (type) {
        case 'exercises':
          filtered = _.filter(list, function(element) {
            return _.contains(_.pluck(element.muscles, 'group'), groupId);
          });
          return filtered;
        case 'muscles':
          return _.filter(list, function(element) {
            return element.group === groupId;
          });
      }
    }
    return list;
  };
});

angular.module("BodyApp").service("ExercisesService", [
  "$q", "$timeout", "$http", "Settings", function(q, timeout, http, settings) {
    var _exercises;
    _exercises = [];
    return {
      getAll: function() {
        var deferred;
        deferred = q.defer();
        http({
          url: "" + settings.apis.exercise + "select",
          method: 'GET',
          headers: {
            'Accept': 'application/json'
          }
        }).success(function(data, status, headers, config) {
          _exercises = data;
          return deferred.resolve(_exercises);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      },
      upsert: function(exercise) {
        var deferred;
        deferred = q.defer();
        http({
          url: "" + settings.apis.exercise + "upsert",
          method: 'PUT',
          data: exercise,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8'
          }
        }).success(function(data, status, headers, config) {
          var element, index, _i, _len;
          if (exercise._id != null) {
            for (index = _i = 0, _len = _exercises.length; _i < _len; index = ++_i) {
              element = _exercises[index];
              if (element._id === exercise._id) {
                _exercises[index] = data;
                break;
              }
            }
          } else {
            _exercises.push(data);
          }
          return deferred.resolve(data);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      }
    };
  }
]);

angular.module("BodyApp").service("MusclesService", [
  "$q", "$timeout", "$http", function(q, timeout, http) {
    var Service, service;
    Service = (function() {
      function Service() {
        this.muscles = [];
/* Begin: client/database/musclegroups.json */
        this.groups = [
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
        console.log(this);
      }

      Service.prototype.getAll = function() {
        var deferred, that;
        that = this;
        console.log(that);
        deferred = q.defer();
        if (_.isEmpty(that.muscles)) {
          http({
            url: "/api/muscle/select",
            method: 'GET',
            headers: {
              'Accept': 'application/json'
            }
          }).success(function(data, status, headers, config) {
            that.muscles = data;
            return deferred.resolve(that.muscles);
          }).error(function(data, status, headers, config) {
            return deferred.reject(status);
          });
        } else {
          timeout(function() {
            return deferred.resolve(that.muscles);
          }, 0);
        }
        return deferred.promise;
      };

      Service.prototype.getGroups = function() {
        var that;
        that = this;
        console.log(that);
        return that.groups;
      };

      Service.prototype.getById = function(id) {
        var deferred, resolve, that;
        that = this;
        deferred = q.defer();
        resolve = function() {
          return deferred.resolve(_.findWhere(that.muscles, {
            _id: id
          }));
        };
        if (_.isEmpty(that.muscles)) {
          that.getAll().then(function() {
            return resolve();
          });
        } else {
          timeout(function() {
            return resolve();
          }, 0);
        }
        return deferred.promise;
      };

      Service.prototype.upsert = function(muscle) {
        var deferred, that;
        that = this;
        deferred = q.defer();
        http({
          url: "/api/muscle/upsert",
          method: 'PUT',
          data: muscle,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8'
          }
        }).success(function(data, status, headers, config) {
          var element, index, _i, _len, _ref;
          if (muscle._id != null) {
            _ref = that.muscles;
            for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
              element = _ref[index];
              if (element._id === muscle._id) {
                that.muscles[index] = data;
                break;
              }
            }
          } else {
            that.muscles.push(data);
          }
          return deferred.resolve(data);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
        return deferred.promise;
      };

      Service.prototype.remove = function(muscle) {
        var deferred, that;
        that = this;
        deferred = q.defer();
        return http({
          url: "/api/muscle/remove",
          method: 'DELETE',
          data: {
            _id: muscle._id
          },
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8'
          }
        }).success(function(data, status, headers, config) {
          var element, index, _i, _len, _ref;
          _ref = that.muscles;
          for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
            element = _ref[index];
            if (element._id === muscle._id) {
              that.muscles.splice(index, 1);
              break;
            }
          }
          return deferred.resolve(data);
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
      };

      return Service;

    })();
    service = new Service();
    return {
      getAll: service.getAll,
      getGroups: service.getGroups,
      getById: service.getById,
      upsert: service.upsert,
      remove: service.remove
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
