angular.module("BodyApp").controller "ExercisesController", [
	"$scope", "ExercisesService", "MusclesService",
	( scope, es, ms ) ->
		scope.data = {
			title : "exercices"
			showModal : false
			editMode : false
			exercises : []
			filtered : null
			form : {}
		}

		es.getAll().then (data) ->
			scope.data.exercises = data

		scope.insertModal = ->
			scope.data.form = {}
			scope.data.showModal = true

		scope.upmoveModal = (index) ->
			exercise = scope.data.filtered[index]
			scope.data.form = {
				_id : exercise._id
				title : exercise.title
				descr : exercise.descr
				muscles :  exercise.muscles #_.pluck( exercise.muscles, '_id')
			}
			scope.data.showModal = true

		scope.upsert = ->
			scope.data.form.muscles = _.pluck( scope.data.form.muscles, '_id')
			es.upsert(scope.data.form).then (data) ->
				scope.data.form = {}
				scope.data.showModal = false

		scope.remove = ->
			es.remove(scope.data.form).then (data) ->
				scope.data.form = {}
				scope.data.showModal = false

]
