angular.module("BodyApp").controller("SchedulesController", [
	"$scope", "SchedulesService",
	( scope, ss ) ->
		scope.data = {
			title : "schedules"
			schedules : null
			showFormModal : false
			formEditMode : false
			form : {}
		}

		_data = scope.data
		
		ss.getAll().then ( data ) ->
			scope.data.schedules = data

		scope.insertModal = ->
			scope.data.showFormModal = true


		return
])
