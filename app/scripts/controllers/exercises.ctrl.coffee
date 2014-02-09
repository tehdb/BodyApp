
angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( $s, es ) ->
	$s.title = "exercices"
	$s.exercises = es.getExercises()
	$s.muscles = es.getMuscles()
	$s.muscleGroups = es.getMuscleGroups()


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
