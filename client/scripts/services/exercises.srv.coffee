
angular.module("BodyApp").service "ExercisesService", [ "$q", "$resource", "$timeout", "$http", ( q, rsr, tmt, htp) ->

	class ExercisesService
		constructor : ->
			that = @
			that.data = {
				exercises : null
				muscles : null
			}

		exercises : ->
			that = @
			deferred = q.defer()
			if not that.data.exercises?
				htp(
					method : "GET"
					url : '/api/exercises/list'
				).success( (exercises, status, headers, config) ->
					that.data.exercises = exercises
					that.muscles().then ->
						for exercise in exercises
							muscles = []
							for muscleId in exercise.muscles
								muscles.push( that.muscle( muscleId) )
							exercise.muscles = muscles
						#console.log that.data.exercises
						deferred.resolve( that.data.exercises )
				).error (data, status, headers, config) ->
					deferred.reject( status )
			else
				tmt( ->
					deferred.resolve( that.data.exercises )
				, 0 )
				
			return deferred.promise

		exercise : ( id = null) ->
			that = @
			if id?
				deferred = q.defer()
				if not that.data.exercises?
					that.exercises().then ->
						for exercise in that.data.exercises
							deferred.resolve( exercise ) if exercise._id is id
				else
					for exercise in that.data.exercises
						deferred.resolve( exercise ) if exercise._id is id

				return deferred.promise
			else
				# TODO : add exercise
				return null

		
		muscle : ( id = null) ->
			that = @
			if id?
				for muscle in that.data.muscles
					return muscle if muscle._id is id
				return null
			else
				# TODO : add muscle
				return null

		muscles : ->
			that = @
			deferred = q.defer()
	
			if not that.data.muscles?
				htp(
					method : "GET"
					url : '/api/muscles/list'
				).success( (data, status, headers, config) ->
					that.data.muscles = data
					deferred.resolve( that.data.muscles )
				).error (data, status, headers, config) ->
					deferred.reject( status )
			else
				tmt( ->
					deferred.resolve( that.data.muscles )
				,0)

			return deferred.promise


	_es = new ExercisesService()

	_exercises = "{{../client/database/exercises.json}}"
	_muscles = "{{../client/database/muscles.json}}"
	_muscleGroups = "{{../client/database/musclegroups.json}}"



	return {
		getExercises : ->
			return _es.exercises()
		
		getExercise : ( id ) ->
			return _es.exercise( id )

		getMuscles : ->
			return _es.muscles()

		getMuscle : ( id ) ->
			return _es.muscle( id )

		getMusclesByIds : (ids) ->
			rsr('/api/muscles/get/:ids').query({ 'ids' : ids.join(',') })



		getMuscleGroups : ->
			return _muscleGroups




		addExercise : ( exercise ) ->
			rsr('/api/exercises/add').save( exercise )


		addMuscle : ( muscle ) ->
			rsr('api/muscles/add').save( muscle ).$promise
	}
]
