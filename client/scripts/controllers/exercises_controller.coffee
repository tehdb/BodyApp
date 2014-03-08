angular.module("BodyApp").controller "ExercisesController", [
	"$scope", "ExercisesService", "MusclesService",
	( scope, exercisesService, musclesService ) ->
		scope.data = {
			title : "exercices"
			exercises : []
			muscleGroup : musclesService.getGroups()[0]
			muscleGroups : musclesService.getGroups()
			newExercise : {}
			showAddExerciseModal : false
		}

		exercisesService.getAll().then (data) ->
			scope.data.exercises = data



		scope.submitAddExerciseForm = ->
			exercise = scope.data.newExercise
			# _.each scope.data.newExercise.muscles, ( element, index, list) ->
			# 	list[index] = _.pick( element, "_id", "name", "group" )
			exercise.muscles = _.pluck( exercise.muscles, '_id')
			exercisesService.upsert( exercise ).then (data) ->
				scope.data.newExercise = {}
				scope.data.showAddExerciseModal = false


		# console.log scope.data.muscleGroups

		# scp.data = {
		# 	muscleGroups : es.getMuscleGroups()
		# 	muscleGroup : null
		# 	muscles : null
		# 	exercises : []
		# 	filtered : []
		# 	searchText : ''
		# 	addExerciseModal : {
		# 		show : false
		# 		confirmed : false
		# 	}

		# }

		# scp.data.muscleGroup = scp.data.muscleGroups[0]

		# scp.addForm = {
		# 	title : ''
		# 	descr : ''
		# 	muscles : []
		# }

		# es.getExercises().then((data) ->
		# 	console.log data
		# 	scp.data.exercises = data
		# ).catch( ->
		# 	console.log "cant load data"
		# )


		# es.getMuscles().then (data) ->
		# 	scp.data.muscles = data

		# # TODO: watch for changes on exercises/muscles

		# scp.submitForm = ->
		# 	if scp.exrcForm.$valid && scp.addForm.muscles.length > 0
		# 		muscleIds = []
		# 		_.each scp.addForm.muscles, (muscle) ->
		# 			muscleIds.push( muscle._id )
		# 		scp.addForm.muscles = muscleIds

		# 		es.addExercise( scp.addForm ).then (data) ->
		# 			# scp.data.exercises.push( data )
		# 			scp.addForm = {
		# 				title : ''
		# 				descr : ''
		# 				muscles : []
		# 			}
		# 			$('#addExerciseModal').modal('hide')
]
