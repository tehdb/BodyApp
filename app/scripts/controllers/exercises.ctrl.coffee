
angular.module("BodyApp").controller "ExercisesCtrl", [ "$scope", "ExercisesService", ( $s, es ) ->
	$s.title = "exercices"
	$s.exercises = es.getExercises()
	$s.muscles = es.getMuscles()

] #MainCtrl
