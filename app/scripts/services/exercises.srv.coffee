
angular.module("BodyApp").service "ExercisesService", [ "Settings", ( st ) ->

	_exercises = "{{../app/database/exercises.json}}"

	return {
		getAllExercises : ->
			return _exercises
	}
]
