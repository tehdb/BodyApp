
angular.module("BodyApp").service "ExercisesService", [ "$q", "$resource", "$timeout", "$http", "$log", ( q, rsr, tmt, htp, lg) ->

	class ExercisesService
		constructor : ->
			that = @
			that.$ = $(that)
			that.initialized = false

			that.$.one 'data.loaded', ( event, data) ->
				that.data = data
				that.initialized = true
				that.$.trigger('data.ready')

			that.initData()


		initData : ->
			that = @

			that.getExercisesFromServer().then (exercises) ->
				that.getMusclesFromServer().then (muscles) ->
					_.each exercises, ( exercise ) ->
						exercise.muscles = _.filter muscles, (val) ->
							return _.contains( exercise.muscles, val._id )

					that.$.trigger('data.loaded', {
						exercises : exercises
						muscles : muscles
					})

		getExercisesFromServer : ->
			deferred = q.defer()
			htp(
				method : "GET"
				url : '/api/exercises/list'
			).success( (exercises, status, headers, config) ->
				deferred.resolve( exercises )
			).error (data, status, headers, config) ->
				deferred.reject( status )
			return deferred.promise


		getMusclesFromServer : ->
			deferred = q.defer()
			htp(
				method : "GET"
				url : '/api/muscles/list'
			).success( (muscles, status, headers, config) ->
				deferred.resolve( muscles )
			).error (data, status, headers, config) ->
				deferred.reject( status )
			return deferred.promise


		# exercises : ( param ) ->
		# 	that = @
		# 	deferred = q.defer()
		# 	if _.isUndefined( param )
		# 		if not that.initialized
		# 			that.$.one 'data.ready', ( event ) ->
		# 				deferred.resolve( that.data.exercises )
		# 		else
		# 			deferred.resolve( that.data.exercises )

		# 	else if _.isString( param )
		# 		if not that.initialized
		# 			that.$.one 'data.ready', ( event ) ->
		# 				exercise = _.findWhere( that.data.exercises, {
		# 					_id : param
		# 				})
		# 				deferred.resolve( exercise )
		# 		else
		# 			deferred.resolve( that.data.exercises )

		# 	return deferred.promise

		# muscles : ( param ) ->
		# 	that = @
		# 	deferred = q.defer()
		# 	if _.isUndefined( param )
		# 		if not that.initialized
		# 			that.$.one 'data.ready', ( event ) ->
		# 				deferred.resolve( that.data.muscles )
		# 		else
		# 			deferred.resolve( that.data.muscles )



		# 	return deferred.promise

		# muscle : ( id = null) ->
		# 	that = @

		# 	if id?
		# 		for muscle in that.data.muscles
		# 			if muscle._id is id
		# 				return {
		# 					_id : muscle._id
		# 					name : muscle.name
		# 					group : muscle.group
		# 				}
		# 		return null
		# 	else
		# 		# TODO : add muscle
		# 		return null

		apply : (cb) ->
			if @initialized
				cb()
			else
				@.$.one 'data.ready', ->
					cb()

		upsert : (action, exercise, deferred) ->
			that = @
			htp(
				method : "POST"
				url : "/api/exercises/upsert"
				data : exercise
				headers: {
					'Content-Type' : 'application/json;charset=UTF-8'
					'Accept' : 'application/json, text/plain, */*'
				}
			).success( (exercise, status, headers, config) ->
				exercise.muscles = _.filter _es.data.muscles, (val) ->
					return _.contains( exercise.muscles, val._id )

				switch action
					when 'insert'
						that.data.exercises.push( exercise )
					when 'update'
						for e, eidx in that.data.exercises
							if e._id is exercise._id
								that.data.exercises[eidx] = exercise
								break
						# _.each that.data.exercises, (element, index) ->
						# 	if element._id is exercise._id
						# 		that.data.exercises[index] = exercise

				deferred.resolve( _.clone( exercise ) )
			).error (data, status, headers, config) ->
				deferred.reject( status )

		delete : ( id, deferred ) ->
			that = @
			htp(
				method : "POST"
				url : "/api/exercises/delete/#{id}"
				headers: {
					'Content-Type' : 'application/json;charset=UTF-8'
					'Accept' : 'application/json, text/plain, */*'
				}
			).success( (exercise, status, headers, config) ->
				deferred.resolve( true )
			).error (data, status, headers, config) ->
				deferred.reject( false )

	_es = new ExercisesService()
	#_exercises = "{{../client/database/exercises.json}}"
	#_muscles = "{{../client/database/muscles.json}}"
	_muscleGroups = "{{../client/database/musclegroups.json}}"


	return {
		getExercises : ->
			deferred = q.defer()
			_es.apply ->
				deferred.resolve( _.clone( _es.data.exercises ) )
			return deferred.promise

		getExercise : ( id ) ->
			deferred = q.defer()
			_es.apply ->
				deferred.resolve( _.clone( _.findWhere( _es.data.exercises, {_id : id } ) ) )
			return deferred.promise

		addMuscle : ( muscle ) ->
			deferred = q.defer()
			htp(
				method : "POST"
				url : "/api/muscles/add"
				data : muscle
				headers: {
					'Content-Type' : 'application/json;charset=UTF-8'
					'Accept' : 'application/json, text/plain, */*'
				}
			).success( (muscle, status, headers, config) ->
				_es.data.muscles.push( muscle )
				deferred.resolve( _.clone( muscle) )
			).error (data, status, headers, config) ->
				deferred.reject( status )
			return deferred.promise


		addExercise : ( exercise ) ->
			deferred = q.defer()
			_es.upsert( "insert", exercise, deferred )
			return deferred.promise


		updateExercise : (exercise) ->
			deferred = q.defer()
			_es.upsert( "update", exercise, deferred )
			return deferred.promise

		deleteExercise : (id) ->
			deferred = q.defer()
			_es.delete( id, deferred )
			return deferred.promise


		getMuscles : ->
			deferred = q.defer()
			_es.apply ->
				deferred.resolve( _.clone( _es.data.muscles ) )
			return deferred.promise


		getMuscle : ( id ) ->
			return _es.muscles( id )


		getMuscleGroups : ->
			return _muscleGroups


	}
]
