angular.module("BodyApp").controller "MusclesController", [
	"$scope", "$modal", "MusclesService", "ExercisesService",
	( scope, $modal, musclesService, es ) ->
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

		# TODO: pарберись с resolve
		scope.insertModal = ->
			modalInstance = $modal.open({
				template: '"{{templates/dialogs/muscle.html}}"'
				controller: 'MuscleDialogCtrl'
				resolve : {
					title : ->
						return 'add new muscle'
				}
			})

			return false
			scope.data.form = {
				group : musclesService.getGroups()?[0]
				name : ''
				update : false
			}
			scope.data.showMuscleModal = true
			console.log scope.data.showMuscleModal

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
