angular.module("BodyApp").controller( "ExercisesController", [
	"$scope", "$modal", "ExercisesService", "MusclesService",
	( $scope, $modal, e_srv, m_srv ) ->
		# defaults
		$scope.data = {
			title : "exercices"
			editMode : false
			exercises : []
			filtered : null
		}

		# init
		do ->
			$scope.data.muscleGroups = m_srv.getGroups()
			$scope.data.muscleGroup = $scope.data.muscleGroups[0]

			e_srv.getAll().then (data) ->
				scope.data.exercises = data

		$scope.showInsertExerciseModal = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$modal.open({
				template: '"{{templates/dialogs/exercise.html}}"'
				controller: 'ExerciseDialogCtrl'
				resolve: { preset: ->
					return null
				}
			})



		# scope.insertModal = ->
		# 	scope.data.editMode = false
		# 	scope.data.form = {}
		# 	scope.data.showModal = true


		# scope.upmoveModal = (index) ->
		# 	exercise = scope.data.filtered[index]
		# 	scope.data.form = {
		# 		_id : exercise._id
		# 		title : exercise.title
		# 		descr : exercise.descr
		# 		muscles :  exercise.muscles #_.pluck( exercise.muscles, '_id')
		# 	}
		# 	scope.data.showModal = true

		# scope.upsert = ->
		# 	scope.data.form.muscles = _.pluck( scope.data.form.muscles, '_id')
		# 	es.upsert(scope.data.form).then (data) ->
		# 		scope.data.form = {}
		# 		scope.data.showModal = false

		# scope.remove = ->
		# 	es.remove(scope.data.form).then (data) ->
		# 		scope.data.form = {}
		# 		scope.data.showModal = false

])