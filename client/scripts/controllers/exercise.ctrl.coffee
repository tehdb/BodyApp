angular.module("BodyApp").controller "ExerciseCtrl", [ "$scope", "$routeParams", "ExercisesService", ( scp, rps, es ) ->
	
	scp.data = {
		exercise : null
		muscles : null
	}	

	es.getExercise( rps.id ).then (exercise) ->
		scp.data.exercise = exercise


	es.getMuscles().then (muscles) ->
		scp.data.muscles = muscles

	# scp.form = {
	# 	title : scp.exercise.title
	# 	descr : scp.exercise.descr
	# 	muscles : scp.exercise.muscles
	# }

	scp.submitForm = ->
		exercise = _.pick( scp.data.exercise, '_id', 'title', 'descr')
		exercise.muscles = _.pluck( scp.data.exercise.muscles, '_id')

		es.addExercise( exercise ).then (data) ->
			console.info data
			$('#editExerciseModal').modal('hide')

]
