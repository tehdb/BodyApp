angular.module("BodyApp").controller "ExerciseCtrl", [ "$scope", "$routeParams", "ExercisesService", ( scp, rps, es ) ->
	scp.exercise = es.getExercise( rps.id )

	scp.exercise.$promise.then (data) ->
		scp.muscles = es.getMusclesByIds( data.muscles )

]