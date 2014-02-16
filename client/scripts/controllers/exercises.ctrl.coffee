angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( scp, es ) ->
	scp.title = "exercices"

	scp.data = {
		#muscleGroups : es.getMuscleGroups()
		addMuscleForm : es.getMuscleGroups()
		muscles : null
		exercises : null
	}
	scp.addForm = {
		title : ''
		descr : ''
		muscles : []
	}


	es.getExercises().then (data) ->
		scp.data.exercises = data


	es.getMuscles().then (data) ->
		scp.data.muscles = data


	# scp.$on 'chosen.update', (event, data) ->
	# 	event.preventDefault()
	# 	event.stopPropagation()
	# 	muscleIds = []
	# 	for muscle in data[0]
	# 		muscleIds.push( muscle._id )

	# 	scp.formData.muscles = muscleIds

	# add new muscle
	# scp.$on 'chosen.add', (event, data) ->
	# 	event.preventDefault()
	# 	event.stopPropagation()

	# 	es.addMuscle( data ).then (data) ->
	# 		scp.data.muscles.push( data )

	# scp.$watch( "data.muscles", (nv, ov) ->
	# 	console.log nv, ov
	# , true )

	scp.submitForm = ->
		if scp.exrcForm.$valid && scp.addForm.muscles.length > 0
			muscleIds = []
			_.each scp.addForm.muscles, (muscle) ->
				muscleIds.push( muscle._id)
			scp.addForm.muscles = muscleIds

			es.addExercise( scp.addForm ).then (data) ->
				scp.data.exercises.push( data )
				scp.addForm = {
					title : ''
					descr : ''
					muscles : []
				}
				$('#addExerciseModal').modal('hide')
				scp.$broadcast('form.submit')


] #MainCtrl
