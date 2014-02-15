angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( scp, es ) ->
	scp.title = "exercices"

	scp.data = {
		#muscleGroups : es.getMuscleGroups()
		addMuscleForm : es.getMuscleGroups()
		muscles : null
		exercises : null
	}
	scp.formData = {
		title : ''
		descr : ''
		muscles : null
	}


	es.getExercises().then (data) ->
		scp.data.exercises = data


	es.getMuscles().then (data) ->
		scp.data.muscles = data


	scp.$on 'chosen.update', (event, data) ->
		event.preventDefault()
		event.stopPropagation()
		muscleIds = []
		for muscle in data[0]
			muscleIds.push( muscle._id )

		scp.formData.muscles = muscleIds

	# add new muscle
	scp.$on 'chosen.add', (event, data) ->
		event.preventDefault()
		event.stopPropagation()

		es.addMuscle( data ).then (data) ->
			scp.data.muscles.push( data )

	scp.submitForm = ->
		if scp.exrcForm.$valid && scp.formData.muscles?
			console.log scp.formData

			return false
			es.addExercise( scp.formData ).then (data) ->
				scp.data.exercises.push( data )
				console.log data
				scp.formData = {
					title : ''
					descr : ''
					muscles : null
				}
				$('#addExerciseModal').modal('hide')
				scp.$broadcast('form.submit')


] #MainCtrl
