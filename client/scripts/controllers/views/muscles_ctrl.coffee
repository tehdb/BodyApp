angular.module("BodyApp").controller( "MusclesController", [
	"$scope", "$modal", "MusclesService", "ExercisesService",
	( scope, $modal, musclesService, es ) ->
		scope.data = {
			title : "muscles"
			muscles : []
			filtered : null
			searchText : ''
			muscleGroup : musclesService.getGroups()?[0]
			muscleGroups : musclesService.getGroups()
			edit : false
		}

		_modalInstance = null

		musclesService.getAll().then (data) ->
			scope.data.muscles = data


		scope.insertModal = ->
			$modal.open({
				template: '"{{templates/dialogs/muscle.html}}"'
				controller: 'MuscleDialogCtrl'
				resolve: { preset: ->
					return null
				}
			})


		scope.upmoveModal = (index) ->
			$modal.open({
				template: '"{{templates/dialogs/muscle.html}}"'
				controller: 'MuscleDialogCtrl'
				resolve: { preset: ->
					return scope.data.filtered[index]
				}
			})


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

])