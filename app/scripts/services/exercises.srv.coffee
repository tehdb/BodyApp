
angular.module("BodyApp").service "ExercisesService", [ "Settings", ( st ) ->


	_exercises = [
		{
			'title' : "Exercise 1"
			'descr' : "Description 1"
		},{
			'title' : "Exercise 2"
			'descr' : "Description 2"
		},{
			'title' : "Exercise 3 Exercise 3 Exercise 3 Exercise 3 Exercise 3"
			'descr' : "Description 3 Description 3 Description 3 Description 3 Description 3 Description 3 Description 3"
		},{
			'title' : "Exercise 4"
			'descr' : "Description 4"
		},{
			'title' : "Exercise 5"
			'descr' : "Description 5"
		},{
			'title' : "Exercise 6"
			'descr' : "Description 6"
		},{
			'title' : "Exercise 7"
			'descr' : "Description 7"
		}
	]

	return {
		getAllExercises : ->
			return _exercises
	}
]
