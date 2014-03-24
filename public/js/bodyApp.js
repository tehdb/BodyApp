angular.module("BodyApp", ["ngRoute", "ngResource", "ngAnimate", "ngSanitize"]).constant("Settings", {
  apis: {
    muscle: "/api/muscle",
    exercise: "/api/exercise"
  }
}).config([
  "$routeProvider", function(rpr) {
    return rpr.when("/", {
      templateUrl: "tpl/views/home.html",
      controller: "HomeController"
    }).when("/exercises", {
      templateUrl: "tpl/views/exercises.html",
      controller: "ExercisesController"
    }).when("/exercise/:id", {
      templateUrl: "tpl/views/exercise.html",
      controller: "ExerciseCtrl"
    }).when("/muscles", {
      templateUrl: "tpl/views/muscles.html",
      controller: "MusclesController"
    }).when("/muscle/:id", {
      templateUrl: "tpl/views/muscle.html",
      controller: "MuscleController"
    }).when("/schedules/", {
      templateUrl: "tpl/views/schedules.html",
      controller: "SchedulesController"
    }).otherwise({
      redirectTo: "/"
    });
  }
]);

angular.module("BodyApp").controller("ExerciseCtrl", [
  "$scope", "$routeParams", "$location", "ExercisesService", "PromosService", function(scp, routeParams, location, exercisesService, promosService) {
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
      return exercisesService.getById(routeParams.id).then(function(exercise) {
        scp.data.exercise = exercise;
        return promosService.getLastProgress(scp.data.exercise._id).then(function(progress) {
          scp.data.progress = progress;
          scp.data.set.value = scp.data.progress.sets[scp.data.set.index];
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
        scp.data.set.value.inc = scp.data.set.index + 1;
        scp.data.set.value.type = "complete";
        if (++scp.data.set.index > scp.data.progress.sets.length - 1) {
          scp.data.progress.sets.push({
            inc: scp.data.set.index + 1,
            heft: scp.data.set.value.heft,
            reps: scp.data.set.value.reps
          });
        }
        scp.data.set.value = scp.data.progress.sets[scp.data.set.index];
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
      var completed;
      completed = _.where(scp.data.progress.sets, {
        type: "complete"
      });
      _.each(completed, function(elm, idx, list) {
        return completed[idx] = _.pick(elm, "inc", "heft", "reps");
      });
      return promosService.add(scp.data.exercise._id, completed).then(function(progress) {
        scp.data.progress = progress;
        scp.data.set.index = 0;
        scp.data.set.value = scp.data.progress.sets[scp.data.set.index];
        scp.data.upsertModal.set = angular.copy(scp.data.set.value);
        return scp.data.completable = false;
      });
    };
    scp.submitForm = function() {
      var exercise;
      exercise = _.pick(scp.data.exercise, '_id', 'title', 'descr');
      exercise.muscles = _.pluck(scp.data.exercise.muscles, '_id');
      return exercisesService.updateExercise(exercise).then(function(data) {
        return _hideEditExerciseModal();
      });
    };
    return scp.deleteExercise = function(event) {
      event.preventDefault();
      event.stopPropagation();
      return exercisesService.deleteExercise(scp.data.exercise._id).then(function(data) {
        return _hideEditExerciseModal(function() {
          return scp.safeApply(function() {
            return location.path('/exercises');
          });
        });
      });
    };
  }
]);

angular.module("BodyApp").controller("ExercisesController", [
  "$scope", "ExercisesService", "MusclesService", function(scope, es, ms) {
    scope.data = {
      title: "exercices",
      showModal: false,
      editMode: false,
      exercises: [],
      filtered: null,
      form: {}
    };
    es.getAll().then(function(data) {
      return scope.data.exercises = data;
    });
    scope.insertModal = function() {
      scope.data.editMode = false;
      scope.data.form = {};
      return scope.data.showModal = true;
    };
    scope.upmoveModal = function(index) {
      var exercise;
      exercise = scope.data.filtered[index];
      scope.data.form = {
        _id: exercise._id,
        title: exercise.title,
        descr: exercise.descr,
        muscles: exercise.muscles
      };
      return scope.data.showModal = true;
    };
    scope.upsert = function() {
      scope.data.form.muscles = _.pluck(scope.data.form.muscles, '_id');
      return es.upsert(scope.data.form).then(function(data) {
        scope.data.form = {};
        return scope.data.showModal = false;
      });
    };
    return scope.remove = function() {
      return es.remove(scope.data.form).then(function(data) {
        scope.data.form = {};
        return scope.data.showModal = false;
      });
    };
  }
]);

angular.module("BodyApp").controller("HomeController", [
  "$scope", function($s) {
    return $s.title = "home";
  }
]);

angular.module("BodyApp").controller("MainController", [
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
      return scope.data.muscle = data;
    });
  }
]);

angular.module("BodyApp").controller("MusclesController", [
  "$scope", "MusclesService", "ExercisesService", function(scope, musclesService, es) {
    var _ref, _ref1;
    scope.data = {
      title: "muscles",
      muscles: [],
      filtered: null,
      searchText: '',
      muscleGroup: (_ref = musclesService.getGroups()) != null ? _ref[0] : void 0,
      muscleGroups: musclesService.getGroups(),
      showMuscleModal: false,
      edit: false,
      form: {
        group: (_ref1 = musclesService.getGroups()) != null ? _ref1[0] : void 0,
        update: false
      }
    };
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
    scope.upmoveModal = function(index) {
      var muscle;
      muscle = scope.data.filtered[index];
      scope.data.form = {
        _id: muscle._id,
        group: muscle.group,
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

angular.module("BodyApp").controller("SchedulesController", [
  "$scope", "SchedulesService", "ExercisesService", "MusclesService", "exerciseFilter", function(scope, ss, es, ms, ef) {
    var _ref;
    scope.data = {
      title: "schedules",
      schedules: null,
      exercises: null,
      showFormModal: false,
      formEditMode: false,
      form: {
        title: '',
        descr: '',
        exercises: [],
        repetition: ''
      },
      exerciseFilter: {
        muscleGroups: ms.getGroups(),
        selectedGroup: (_ref = ms.getGroups()) != null ? _ref[0] : void 0
      }
    };
    ss.getAll().then(function(data) {
      return scope.data.schedules = data;
    });
    es.getAll().then(function(data) {
      scope.data.exercises = data;
      return scope.data.filteredExercises = data;
    });
    scope.insertModal = function() {
      scope.data.showFormModal = true;
      return false;
    };
    scope.upsert = function() {
      console.log(scope.data.form);
      return false;
    };
    scope.exerciseSearchTextChange = function() {
      var available, selected;
      selected = _.pluck(scope.data.form.exercises, '_id');
      available = _.filter(scope.data.exercises, function(element) {
        return !_.contains(selected, element._id);
      });
      if (scope.data.exerciseSearchText.length >= 3) {
        return scope.data.filteredExercises = ef(available, scope.data.exerciseSearchText, 'text');
      } else {
        return scope.data.filteredExercises = available;
      }
    };
    scope.exerciseMuscleGroupChange = function() {
      var available, selected;
      selected = _.pluck(scope.data.form.exercises, '_id');
      available = _.filter(scope.data.exercises, function(element) {
        return !_.contains(selected, element._id);
      });
      return scope.data.filteredExercises = ef(available, scope.data.exerciseFilter.selectedGroup.id, 'group');
    };
  }
]);

angular.module("BodyApp").directive("chosen", [
  "$q", "$timeout", "$compile", function(q, timeout, compile) {
    return {
      restrict: "E",
      scope: {
        placeholder: "@",
        optionLabel: "@",
        fullscreen: "@",
        options: "=",
        selected: "="
      },
      replace: true,
      transclude: true,
      templateUrl: "tpl/directives/chosen.html",
      link: function(scope, element, attrs) {
        var _optionTemplate;
        _optionTemplate = null;
        (function() {
          var cls, ot, tpl;
          ot = element.find("div[option-template]");
          cls = ot.attr('option-template');
          tpl = '<div class="' + cls + '">' + ot.html() + '</div>';
          return _optionTemplate = tpl;
        })();
        scope.data = {
          showMenu: false,
          available: null,
          multiSelect: []
        };
        scope.$watch('options', function(nv, ov) {
          scope.data.multiSelect = [];
          if (nv != null) {
            return scope.data.available = angular.copy(nv);
          }
        }, true);
        scope.getOptionTemplate = function() {
          return _optionTemplate;
        };
        scope.toggleMenu = function(event) {
          event.preventDefault();
          event.stopPropagation();
          return scope.data.showMenu = !scope.data.showMenu;
        };
        scope.select = function(event, index) {
          var option;
          event.preventDefault();
          option = scope.data.available.splice(index, 1);
          scope.selected.push(option[0]);
          return scope.data.showMenu = false;
        };
        scope.isMultiSelected = function(index) {
          return _.contains(scope.data.multiSelect, index);
        };
        scope.multiSelect = function(event, index) {
          var selected;
          event.preventDefault();
          event.stopPropagation();
          if (index === 'apply') {
            selected = scope.data.available.multisplice(scope.data.multiSelect);
            _.each(selected, function(element) {
              return scope.selected.push(element);
            });
            scope.data.showMenu = false;
            return scope.data.multiSelect = [];
          } else if (index === 'all') {
            if (scope.data.multiSelect.length !== scope.data.available.length) {
              return _.each(scope.data.available, function(element, index) {
                if (!scope.isMultiSelected(index)) {
                  return scope.data.multiSelect.push(index);
                }
              });
            } else {
              return scope.data.multiSelect = [];
            }
          } else {
            if (scope.isMultiSelected(index)) {
              return scope.data.multiSelect = _.without(scope.data.multiSelect, index);
            } else {
              return scope.data.multiSelect.push(index);
            }
          }
        };
        scope.unselect = function(event, index) {
          var option;
          event.preventDefault();
          event.stopPropagation();
          option = scope.selected.splice(index, 1);
          scope.data.available.push(option[0]);
          return false;
        };
      }
    };
  }
]).directive("chosenOption", [
  "$compile", function(compile) {
    return {
      scope: {
        template: "&",
        option: "="
      },
      restrict: "E",
      replace: true,
      template: '<div class="option"></div>',
      link: function(scope, element, attrs) {
        var _template;
        _template = scope.template();
        if (!_.isUndefined(_template)) {
          return element.html(compile(_template)(scope));
        }
      }
    };
  }
]);

angular.module("BodyApp").directive("modal", [
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
      templateUrl: "tpl/directives/modal.html",
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

angular.module("BodyApp").directive("muscleChosen", [
  "$q", "$timeout", "$compile", "MusclesService", function(q, tmt, cpl, musclesService) {
    return {
      restrict: "E",
      scope: {
        selected: "="
      },
      replace: true,
      templateUrl: "tpl/directives/muscle-chosen.html",
      link: function(scp, elm, atr) {
        var _watchSelectedChanges;
        scp.data = {
          available: [],
          filtered: null,
          searchText: '',
          newMuscleForm: {
            name: '',
            group: musclesService.getGroups()[0]
          },
          muscleGroups: musclesService.getGroups(),
          toggles: {
            showMenu: false,
            showFilter: false,
            showAddForm: false
          }
        };
        scp.selected = scp.selected || [];
        musclesService.getAll().then(function(data) {
          return scp.data.options = data;
        });
        (_watchSelectedChanges = function() {
          return scp.$watch('selected', function(newVal, oldVal) {
            var selectedIds;
            if (_.isArray(newVal)) {
              selectedIds = _.pluck(newVal, '_id');
              return scp.data.available = _.filter(scp.data.options, function(elm) {
                return !_.contains(selectedIds, elm._id);
              });
            } else {
              return scp.data.available = angular.copy(scp.data.options);
            }
          });
        })();
        scp.add = function(event) {
          var form;
          event.preventDefault();
          event.stopPropagation();
          form = angular.copy(scp.data.newMuscleForm);
          form.group = form.group.id;
          return musclesService.upsert(form).then(function(data) {
            scp.data.available.push(data);
            return scp.data.newMuscleForm.name = '';
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
          scp.data.available.push(scp.selected[index]);
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
      templateUrl: "tpl/directives/number-input.html",
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

angular.module("BodyApp").filter("exercise", function() {
  return function(list, query, type) {
    switch (type) {
      case 'text':
        if ((query != null ? query.length : void 0) >= 3) {
          return _.filter(list, function(exercise) {
            var _ref, _ref1;
            return ((_ref = exercise.title) != null ? _ref.indexOf(query) : void 0) !== -1 || ((_ref1 = exercise.descr) != null ? _ref1.indexOf(query) : void 0) !== -1;
          });
        }
        break;
      case 'group':
        if (query === 0) {
          return list;
        }
        return _.filter(list, function(exercise) {
          var muscle, res, _i, _len, _ref;
          res = false;
          _ref = exercise.muscles;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            muscle = _ref[_i];
            if (muscle.group.id === query) {
              res = true;
              break;
            }
          }
          return res;
        });
    }
    return list;
  };
});

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
            return element.group.id === groupId;
          });
      }
    }
    return list;
  };
});

angular.module("BodyApp").service("ExercisesService", [
  "$q", "$timeout", "$http", "MusclesService", "Settings", function(q, timeout, http, ms, sttgs) {
    var that, _apply, _enrich, _exercises, _prepare;
    that = this;
    _exercises = [];
    _enrich = function(exercise) {
      var def, muscles, musclesCount, musclesLength;
      def = q.defer();
      musclesLength = exercise.muscles.length - 1;
      musclesCount = 0;
      muscles = [];
      _.each(exercise.muscles, function(muscleId, muscleIdx, muscleIds) {
        return ms.getById(muscleId).then(function(muscle) {
          muscles.push(muscle);
          if (++musclesCount > musclesLength) {
            exercise.muscles = muscles;
            return def.resolve(exercise);
          }
        });
      });
      return def.promise;
    };
    _prepare = function(data) {
      var def, exercises, exercisesCount, exercisesLength;
      def = q.defer();
      if (_.isArray(data)) {
        exercisesLength = data.length - 1;
        exercisesCount = 0;
        exercises = [];
        _.each(data, function(element, index, list) {
          return _enrich(element).then(function(data) {
            exercises.push(data);
            if (++exercisesCount > exercisesLength) {
              return def.resolve(exercises);
            }
          });
        });
      } else {
        _enrich(data).then(function(data) {
          return def.resolve(data);
        });
      }
      return def.promise;
    };
    _apply = function() {
      var def;
      def = q.defer();
      if (_.isEmpty(_exercises)) {
        http({
          url: "" + sttgs.apis.exercise + "/select",
          method: 'GET',
          headers: {
            'Accept': 'application/json'
          }
        }).success(function(data, status, headers, config) {
          return _prepare(data).then(function(data) {
            _exercises = data;
            return def.resolve(_exercises);
          });
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
      } else {
        timeout(function() {
          return def.resolve(_exercises);
        }, 0);
      }
      return def.promise;
    };
    this.getAll = function() {
      var def;
      def = q.defer();
      _apply().then(function() {
        return def.resolve(_exercises);
      });
      return def.promise;
    };
    this.getById = function(id) {
      var def;
      def = q.defer();
      _apply().then(function() {
        return def.resolve(_.findWhere(_exercises, {
          _id: id
        }));
      });
      return def.promise;
    };
    this.upsert = function(exercise) {
      var def;
      def = q.defer();
      http({
        url: "" + sttgs.apis.exercise + "/upsert",
        method: 'PUT',
        data: exercise,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json;charset=UTF-8'
        }
      }).success(function(data, status, headers, config) {
        var element, index, _i, _len, _results;
        if (exercise._id == null) {
          return _prepare(data).then(function(data) {
            _exercises.push(data);
            return def.resolve(data);
          });
        } else {
          _results = [];
          for (index = _i = 0, _len = _exercises.length; _i < _len; index = ++_i) {
            element = _exercises[index];
            if (element._id === exercise._id) {
              _prepare(data).then(function(data) {
                _exercises[index] = data;
                return def.resolve(data);
              });
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        }
      }).error(function(data, status, headers, config) {
        return def.reject(status);
      });
      return def.promise;
    };
    this.remove = function(exercise) {
      var defer;
      defer = q.defer();
      http({
        url: "" + sttgs.apis.exercise + "/remove",
        method: 'DELETE',
        data: {
          _id: exercise._id
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json;charset=UTF-8'
        }
      }).success(function(data, status, headers, config) {
        var element, index, _i, _len;
        for (index = _i = 0, _len = _exercises.length; _i < _len; index = ++_i) {
          element = _exercises[index];
          if (element._id === exercise._id) {
            _exercises.splice(index, 1);
            break;
          }
        }
        return defer.resolve(data);
      }).error(function(data, status, headers, config) {
        return defer.reject(status);
      });
      return defer.promise;
    };
  }
]);

angular.module("BodyApp").service("LocalStorageService", [
  "$q", function(q) {
    var that;
    that = this;
    this.get = function(key) {
      var res;
      res = localStorage.getItem(key);
      if (_.isNull(res)) {
        return null;
      }
      res = LZString.decompress(res);
      res = angular.fromJson(res);
      return res;
    };
    this.set = function(key, val) {
      val = angular.toJson(val);
      val = LZString.compress(val);
      return localStorage.setItem(key, val);
    };
    this.remove = function(key) {
      return localStorage.removeItem(key);
    };
    this.clear = function() {
      return localStorage.clear();
    };
  }
]);

angular.module("BodyApp").service("MusclesService", [
  "$q", "$timeout", "$http", function(q, timeout, http) {
    var that, _apply, _groups, _muscles, _prepare;
    that = this;
    _muscles = [];
/* Begin: client/database/musclegroups.json */
    _groups = [
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
    _prepare = function(data, cb) {
      if (_.isArray(data)) {
        _.each(data, function(element, index, list) {
          return list[index].group = _.findWhere(_groups, {
            id: element.group
          });
        });
      } else {
        data.group = _.findWhere(_groups, {
          id: data.group
        });
      }
      return cb(data);
    };
    _apply = function(cb) {
      if (_.isEmpty(_muscles)) {
        return that.getAll().then(function() {
          return cb();
        });
      } else {
        return timeout(function() {
          return cb();
        }, 0);
      }
    };
    this.getAll = function() {
      var deferred;
      deferred = q.defer();
      if (_.isEmpty(_muscles)) {
        http({
          url: "/api/muscle/select",
          method: 'GET',
          headers: {
            'Accept': 'application/json'
          }
        }).success(function(data, status, headers, config) {
          return _prepare(data, function(data) {
            _muscles = data;
            return deferred.resolve(_muscles);
          });
        }).error(function(data, status, headers, config) {
          return deferred.reject(status);
        });
      } else {
        timeout(function() {
          return deferred.resolve(_muscles);
        }, 0);
      }
      return deferred.promise;
    };
    this.getGroups = function() {
      return _groups;
    };
    this.getById = function(id) {
      var deferred;
      deferred = q.defer();
      _apply(function() {
        return deferred.resolve(_.findWhere(_muscles, {
          _id: id
        }));
      });
      return deferred.promise;
    };
    this.upsert = function(muscle) {
      var deferred;
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
        var element, index, _i, _len, _results;
        if (muscle._id != null) {
          _results = [];
          for (index = _i = 0, _len = _muscles.length; _i < _len; index = ++_i) {
            element = _muscles[index];
            if (element._id === muscle._id) {
              _prepare(data, function(data) {
                _muscles[index] = data;
                return deferred.resolve(data);
              });
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        } else {
          return _prepare(data, function(data) {
            _muscles.push(data);
            return deferred.resolve(data);
          });
        }
      }).error(function(data, status, headers, config) {
        return deferred.reject(status);
      });
      return deferred.promise;
    };
    this.remove = function(muscle) {
      var deferred;
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
        var element, index, _i, _len;
        for (index = _i = 0, _len = _muscles.length; _i < _len; index = ++_i) {
          element = _muscles[index];
          if (element._id === muscle._id) {
            _muscles.splice(index, 1);
            break;
          }
        }
        return deferred.resolve(data);
      }).error(function(data, status, headers, config) {
        return deferred.reject(status);
      });
    };
  }
]);

angular.module("BodyApp").service("PromosService", [
  "$q", "$timeout", "$http", "LocalStorageService", function(q, timeout, http, lss) {
    var that, _getPromo, _promos, _pushSetsToPromo;
    that = this;
    _promos = null;
    _getPromo = function(exerciseId) {
      var promo;
      _promos = _promos ||  lss.get('promos');
      if (_.isNull(_promos)) {
        _promos = [];
        _promos.push({
          exercise: exerciseId,
          progress: []
        });
        lss.set('promos', _promos);
        return _promos[0];
      }
      promo = _.findWhere(_promos, {
        exercise: exerciseId
      });
      if (_.isUndefined(promo)) {
        promo = {
          exercise: exerciseId,
          progress: []
        };
        _promos.push(promo);
        lss.set('promos', _promos);
      }
      return promo;
    };
    _pushSetsToPromo = function(exerciseId, sets) {
      var elm, idx, progress, promo, _i, _len;
      promo = _getPromo(exerciseId);
      progress = {
        date: new Date().getTime(),
        sets: sets
      };
      for (idx = _i = 0, _len = _promos.length; _i < _len; idx = ++_i) {
        elm = _promos[idx];
        if (elm.exercise === exerciseId) {
          _promos[idx].progress.push(progress);
          lss.set('promos', _promos);
          break;
        }
      }
      return progress;
    };
    this.getLastProgress = function(exerciseId) {
      var def;
      def = q.defer();
      timeout(function() {
        var progress, promo;
        promo = _getPromo(exerciseId);
        progress = _.last(promo.progress);
        if (_.isUndefined(progress)) {
          progress = {
            date: null,
            sets: [
              {
                inc: 1,
                heft: 50,
                reps: 10
              }
            ]
          };
        }
        return def.resolve(progress);
      }, 0);
      return def.promise;
    };
    this.add = function(exerciseId, sets) {
      var def;
      def = q.defer();
      timeout(function() {
        return def.resolve(_pushSetsToPromo(exerciseId, sets));
      }, 0);
      return def.promise;
    };
  }
]);

angular.module("BodyApp").service("SchedulesService", [
  "$q", "$timeout", "$http", "LocalStorageService", function(q, timeout, http, lss) {
    var _schedules;
    _schedules = [
      {
        "title": "Training day 1",
        "descr": "shoulder and chest",
        "exercises": [],
        "repetition": "continues"
      }, {
        "title": "Training day 2",
        "descr": "back and buttocks",
        "exercises": [],
        "repetition": "continues"
      }
    ];
    this.getAll = function() {
      var def;
      def = q.defer();
      timeout(function() {
        return def.resolve(_schedules);
      }, 0);
      return def.promise;
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
