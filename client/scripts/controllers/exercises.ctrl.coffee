
angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( scp, es ) ->
	scp.title = "exercices"

	scp.data = {
		exercices : "exercices"
		muscles : "muscles"
	}

	# scp.exercices = null
	# scp.muscles = null

	es.getExercises().then (data) ->
		scp.data.exercises = data

	es.getMuscles().then (data) ->
		scp.safeApply ->
			scp.data.muscles = data

	scp.formData = {
		title : ''
		descr : ''
		muscles : null
	}


	scp.$on 'chosen.update', (event, data) ->
		event.preventDefault()
		event.stopPropagation()
		muscleIds = []
		for muscle in data[0]
			muscleIds.push( muscle._id )

		scp.formData.muscles = muscleIds

	scp.$on 'chosen.add', (event, data) ->
		event.preventDefault()
		event.stopPropagation()

		es.addMuscle({
			"name" : data[0].name
			"group" : data[0].group
		}).then ( res ) ->
			data[0]._id = res.message

	scp.submitForm = ->
		if scp.exrcForm.$valid && scp.formData.muscles?

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
