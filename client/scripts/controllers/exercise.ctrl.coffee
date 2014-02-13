angular.module("BodyApp").controller "ExerciseCtrl", [ "$scope", "$routeParams", "ExercisesService", ( scp, rps, es ) ->
	es.getExercise( rps.id ).then (exercise) ->
		scp.exercise = exercise

]