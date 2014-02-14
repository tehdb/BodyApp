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
    return es.getExercise(rps.id).then(function(exercise) {
      return scp.exercise = exercise;
    });
  }
]);

angular.module("BodyApp").controller("ExercisesCtrl", [
  "$scope", "ExercisesService", function(scp, es) {
    scp.title = "exercices";
    scp.data = {
      exercices: "exercices",
      muscles: "muscles"
    };
    es.getExercises().then(function(data) {
      return scp.data.exercises = data;
    });
    es.getMuscles().then(function(data) {
      return scp.safeApply(function() {
        return scp.data.muscles = data;
      });
    });
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
        return es.addExercise(scp.formData).then(function(data) {
          scp.data.exercises.push(data);
          console.log(data);
          scp.formData = {
            title: '',
            descr: '',
            muscles: null
          };
          $('#addExerciseModal').modal('hide');
          return scp.$broadcast('form.submit');
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
            console.log(scp.options);
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
        var _menu, _toggleMenu;
        _menu = elm.find('.options');
        scp.options = scp[atr.thChosen];
        scp.selected = [];
        scp.searchText = '';
        scp.newElement = '';
        scp.showmenu = false;
        _toggleMenu = function() {
          scp.searchText = "";
          scp.showmenu = !scp.showmenu;
          if (scp.showmenu) {
            return to(function() {
              var mh, mot, wh, wot, y;
              wh = $(window).height() - 60;
              wot = $(document).scrollTop();
              mh = _menu.outerHeight();
              mot = _menu.parent().offset().top;
              if (mot + mh > wot + wh) {
                y = -((mot + mh) - (wot + wh));
                return _menu.css('top', y + "px");
              } else {
                return _menu.css('top', "100%");
              }
            }, 0);
          }
        };
        elm.click(function(event) {
          event.preventDefault();
          event.stopPropagation();
          return console.log(scp);
        });
        return scp.$on('form.submit', function(event, data) {
          scp.options = scp.options.concat(scp.selected);
          return scp.selected = [];
        });
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
            return _.each(exercises, function(e) {
              e.muscles = _.filter(muscles, function(val) {
                return _.contains(e.muscles, val._id);
              });
              return that.$.trigger('data.loaded', {
                exercises: exercises,
                muscles: muscles
              });
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

      ExercisesService.prototype.checkInit = function(cb) {
        if (this.initialized) {
          return cb();
        } else {
          return this.$.one('data.ready', function() {
            return cb();
          });
        }
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
        _es.checkInit(function() {
          return deferred.resolve(_es.data.exercises);
        });
        return deferred.promise;
      },
      getExercise: function(id) {
        var deferred;
        deferred = q.defer();
        _es.checkInit(function() {
          return deferred.resolve(_.findWhere(_es.data.exercises, {
            _id: id
          }));
        });
        return deferred.promise;
      },
      addExercise: function(exercise) {
        return _es.exercises(exercise);
      },
      getMuscles: function() {
        var deferred;
        deferred = q.defer();
        _es.checkInit(function() {
          return deferred.resolve(_es.data.muscles);
        });
        return deferred.promise;
      },
      getMuscle: function(id) {
        return _es.muscles(id);
      },
      getMuscleGroups: function() {
        return _muscleGroups;
      },
      addMuscle: function(muscle) {
        return rsr('api/muscles/add').save(muscle).$promise;
      }
    };
  }
]);

//# sourceMappingURL=../.temp/bodyApp.js.map
