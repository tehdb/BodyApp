
angular.module("BodyApp").service "ExercisesService", [ "$q", "$resource", ( q, rsr ) ->

	_exercises = "{{../client/database/exercises.json}}"
	_muscles = "{{../client/database/muscles.json}}"
	_muscleGroups = "{{../client/database/musclegroups.json}}"

	return {
		getExercises : (type) ->
			switch type
				when 'dynamic' then return rsr('/api/exercises/list').query()
				when 'static' then return _exercises

		getMuscles : (type) ->
			switch type
				when 'dynamic' then return rsr('/api/muscles/list').query()
				when 'static' then return _muscles

		getMusclesByIds : (ids) ->
			rsr('/api/muscles/get/:ids').query({ 'ids' : ids.join(',') })



		getMuscleGroups : ->
			return _muscleGroups

		getExercise : (id) ->
			rsr('/api/exercises/get/:id').get({ 'id' : id })

		addExercise : ( exercise ) ->
			rsr('/api/exercises/add').save( exercise )

		addMuscle : ( muscle ) ->
			rsr('api/muscles/add').save( muscle ).$promise
	}
]
