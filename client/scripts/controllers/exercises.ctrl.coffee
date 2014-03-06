angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( scp, es ) ->
	scp.title = "exercices"

	scp.data = {
		muscleGroups : es.getMuscleGroups()
		muscleGroup : null
		muscles : null
		exercises : null
		filtered : []
		searchText : ''
	}

	scp.data.muscleGroup = scp.data.muscleGroups[0]

	scp.addForm = {
		title : ''
		descr : ''
		muscles : []
	}

	es.getExercises().then((data) ->
		console.log data
		scp.data.exercises = data
	).catch( ->
		console.log "cant load data"
	)


	es.getMuscles().then (data) ->
		scp.data.muscles = data

	# TODO: watch for changes on exercises/muscles

	scp.submitForm = ->
		if scp.exrcForm.$valid && scp.addForm.muscles.length > 0
			muscleIds = []
			_.each scp.addForm.muscles, (muscle) ->
				muscleIds.push( muscle._id )
			scp.addForm.muscles = muscleIds

			es.addExercise( scp.addForm ).then (data) ->
				# scp.data.exercises.push( data )
				scp.addForm = {
					title : ''
					descr : ''
					muscles : []
				}
				$('#addExerciseModal').modal('hide')
]
