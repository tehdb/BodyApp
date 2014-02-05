
angular.module("BodyApp").service "ExercisesService", [ "Settings", ( st ) ->

	_exercises = "{{../app/database/exercises.json}}"
	_muscles = "{{../app/database/muscles.json}}"

	return {
		getExercises : ->
			return _exercises

		getMuscles : ->
			return _muscles
	}
]
