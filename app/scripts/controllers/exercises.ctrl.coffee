
angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( $s, es ) ->
	$s.title = "exercices"
	$s.exercises = es.getExercises()
	$s.muscles = es.getMuscles()
	$s.muscleGroups = es.getMuscleGroups()
	
	$s.temp = [
		{name:"bla"}
	]

	$s.formData = {
		title : ''
		descr : ''
		muscles : null
	}

	$s.$on( 'chosen.update', (event, data) ->
		$s.formData.muscles = data[0]
	)

	$s.submitForm = ->
		if $s.exerciseForm.$valid
			$s.exercises.push( $s.formData )
			console.log $s.formData
			$s.formData = {}
			$s.$broadcast('form.submit')


	# $s.addMuscleForm = [
	# 	{
	# 		value : "group"
	# 		type : "select"
	# 		options : es.getMuscleGroupts()
	# 	},{
	# 		value : "name"
	# 		type : "string"
	# 	}
	# ]

] #MainCtrl
