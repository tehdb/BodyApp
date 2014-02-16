angular.module("BodyApp").controller "ExerciseCtrl", [ "$scope", "$routeParams", "ExercisesService", ( scp, rps, es ) ->
	es.getExercise( rps.id ).then (exercise) ->
		scp.exercise = exercise
		es.getMuscles().then (muscles) ->
			scp.muscles = muscles

		scp.form = {
			title : exercise.title
			descr : exercise.descr
			muscles : exercise.muscles

		}

		scp.submitForm = ->
			console.log scp.formData

]
