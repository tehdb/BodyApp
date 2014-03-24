angular.module("BodyApp").controller("SchedulesController", [
	"$scope", "SchedulesService", "ExercisesService", "MusclesService", "exerciseFilter",
	( scope, ss, es, ms, ef ) ->
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
			, exerciseFilter : {
				muscleGroups : ms.getGroups()
				selectedGroup : ms.getGroups()?[0]
			}
		}

		ss.getAll().then ( data ) ->
			scope.data.schedules = data

		es.getAll().then ( data ) ->
			scope.data.exercises = data
			scope.data.filteredExercises = data

		scope.insertModal = ->
			scope.data.showFormModal = true
			return false

		scope.upsert = ->
			console.log scope.data.form
			return false

		# scope.filterExercises = (event) ->
		# 	# event.preventDefault()
		# 	event.stopPropagation()

		# 	if event.keyCode is 13 and scope.data.exerciseSearchText.length >= 3
		# 		 scope.data.filteredExercises = angular.copy ef(scope.data.exercises, scope.data.exerciseSearchText )


		scope.exerciseSearchTextChange = ->
			# get options without selected
			selected = _.pluck( scope.data.form.exercises, '_id')
			available = _.filter scope.data.exercises, (element) ->
				return !_.contains( selected, element._id )

			# filter exercises by text
			if scope.data.exerciseSearchText.length >= 3
				scope.data.filteredExercises = ef(available, scope.data.exerciseSearchText, 'text' )

			# reset filter
			else
				scope.data.filteredExercises = available

		scope.exerciseMuscleGroupChange = ->
			selected = _.pluck( scope.data.form.exercises, '_id')
			available = _.filter scope.data.exercises, (element) ->
				return !_.contains( selected, element._id )

			scope.data.filteredExercises = ef(available, scope.data.exerciseFilter.selectedGroup.id, 'group' )


		return
])
