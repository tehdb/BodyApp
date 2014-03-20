angular.module("BodyApp").controller("SchedulesController", [
	"$scope", "SchedulesService", "ExercisesService",
	( scope, ss, es ) ->
		scope.data = {
			title : "schedules"
			schedules : null
			exercises : null
			showFormModal : false
			formEditMode : false
			form : {
				title : ''
				descr : ''
				exercises : []
				repetition : ''
			}
		}

		_data = scope.data
		
		ss.getAll().then ( data ) ->
			scope.data.schedules = data

		es.getAll().then ( data ) ->
			scope.data.exercises = data

		scope.insertModal = ->
			scope.data.showFormModal = true
			return false

		scope.upsert = ->
			console.log scope.data.form
			return false

		return
])
