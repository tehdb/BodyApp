
angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( scp, es ) ->
	scp.title = "exercices"
	scp.exercises = es.getExercises( 'dynamic')
	scp.muscles = es.getMuscles('dynamic')
	scp.muscleGroups = es.getMuscleGroups()

	scp.temp = [
		{name:"bla"}
	]

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
			scp.exercises.push( scp.formData )

			es.addExercise( scp.formData )
			scp.formData = {
				title : ''
				descr : ''
				muscles : null
			}
			$('#addExerciseModal').modal('hide')
			scp.$broadcast('form.submit')

] #MainCtrl
