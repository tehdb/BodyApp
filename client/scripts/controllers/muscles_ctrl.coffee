angular.module("BodyApp").controller "MusclesController", [
	"$scope", "MusclesService", "ExercisesService",
	( scope, musclesService, es ) ->
		scope.data = {
			title : "muscles"
			muscles : []
			filtered : null
			searchText : ''
			muscleGroup : musclesService.getGroups()?[0]
			muscleGroups : musclesService.getGroups()
			showMuscleModal : false
			edit : false
			form : {
				group : musclesService.getGroups()?[0]
				update : false
			}
		}

		musclesService.getAll().then (data) ->
			scope.data.muscles = data

		scope.insertModal = ->
			scope.data.form = {
				group : musclesService.getGroups()?[0]
				name : ''
				update : false
			}
			scope.data.showMuscleModal = true

		scope.upmoveModal = (index) ->
			muscle = scope.data.filtered[index]

			scope.data.form = {
				_id : muscle._id
				group : muscle.group
				name : muscle.name
				update : true
			}

			scope.data.showMuscleModal = true

		scope.remove = ->
			data = _.omit( scope.data.form, 'update' )
			data.group = data.group.id
			musclesService.remove(data).then (data) ->
				scope.data.form = {
					group : musclesService.getGroups()?[0]
					update : false
				}
				scope.data.showMuscleModal = false

		scope.upsert = ->
			data = _.omit( scope.data.form, 'update' )
			data.group = data.group.id
			musclesService.upsert(data).then ( data )->
				scope.data.form.name = ''
				scope.data.showMuscleModal = false

]
