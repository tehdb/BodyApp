
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



		exercises : ( param ) ->
			that = @
			deferred = q.defer()
			if _.isUndefined( param )
				if not that.initialized
					that.$.one 'data.ready', ( event ) ->
						deferred.resolve( that.data.exercises )
				else
					deferred.resolve( that.data.exercises )

			else if _.isString( param )
				if not that.initialized
					that.$.one 'data.ready', ( event ) ->
						exercise = _.findWhere( that.data.exercises, {
							_id : param
						})
						deferred.resolve( exercise )
				else
					deferred.resolve( that.data.exercises )

			return deferred.promise

		muscles : ( param ) ->
			that = @
			deferred = q.defer()
			if _.isUndefined( param )
				if not that.initialized
					that.$.one 'data.ready', ( event ) ->
						deferred.resolve( that.data.muscles )
				else
					deferred.resolve( that.data.muscles )



			return deferred.promise

		# muscles : ->
		# 	that = @
		# 	deferred = q.defer()

		# 	if not that.data.muscles?
		# 		htp(
		# 			method : "GET"
		# 			url : '/api/muscles/list'
		# 		).success( (data, status, headers, config) ->
		# 			that.data.muscles = data
		# 			deferred.resolve( that.data.muscles )
		# 		).error (data, status, headers, config) ->
		# 			deferred.reject( status )
		# 	else
		# 		tmt( ->
		# 			deferred.resolve( that.data.muscles )
		# 		,0)

		# 	return deferred.promise

		# add, get exercises

		# @param param [undefined] 		get all exercises
		# @param param [string] 		getExerciseset exercise by id
		# @param param [array] 			get exercises by id's
		# @param param [object] 		add exercise

		exercise12 : ( param = undefined ) ->
			that = @
			deferred = q.defer()

			switch (typeof param )
				when 'string'
					if not that.data.exercises?
						that.exercises().then ->
							deferred.resolve( e ) if e._id is param for e in that.data.exercises
					else
						deferred.resolve( e ) if e._id is param for e in that.data.exercises


				when 'undefined'
					if not that.data.exercises?
						htp(
							method : "GET"
							url : '/api/exercises/list'
						).success( (data, status, headers, config) ->
							that.data.exercises = data
							that.muscles().then ->
								for e, idx in that.data.exercises
									muscles = []
									muscles.push( that.muscle( mid) ) for mid in e.muscles
									that.data.exercises[idx].muscles = muscles
								deferred.resolve( that.data.exercises )
						).error (data, status, headers, config) ->
							deferred.reject( status )
					else
						tmt( ->
							deferred.resolve( that.data.exercises )
						, 0 )

				when 'object'
					if param instanceof Object
						# rsr('/api/exercises/add').save( exercise )
						htp(
							method : "POST"
							url : "/api/exercises/add"
							data : param
							headers: {
								'Content-Type' : 'application/json;charset=UTF-8'
								'Accept' : 'application/json, text/plain, */*'
							}
						).success( (exercise, status, headers, config) ->
							muscles = []
							muscles.push( that.muscle(mid) ) for mid in exercise.muscles
							exercise.muscles = muscles
							deferred.resolve( exercise )
						).error (data, status, headers, config) ->
							deferred.reject( status )


					else if param instanceof Array
						console.log 'get exercises by ids'


			return deferred.promise


		muscle : ( id = null) ->
			that = @

			if id?
				for muscle in that.data.muscles
					if muscle._id is id
						return {
							_id : muscle._id
							name : muscle.name
							group : muscle.group
						}
				return null
			else
				# TODO : add muscle
				return null

		apply : (cb) ->
			if @initialized
				cb()
			else
				@.$.one 'data.ready', ->
					cb()

		upsertExercise : (action, exercise, deferred) ->
			that = @
			htp(
				method : "POST"
				url : "/api/exercises/add"
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
						# TODO: find out how to break the each loop
						_.each that.data.exercises, (element, index) ->
							if element._id is exercise._id
								that.data.exercises[index] = exercise

				deferred.resolve( _.clone( exercise ) )
			).error (data, status, headers, config) ->
				deferred.reject( status )




	_es = new ExercisesService()

	_exercises = "{{../client/database/exercises.json}}"
	_muscles = "{{../client/database/muscles.json}}"
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

			# _es.apply ->
			# 	# TODO: add persistence
			# 	m = _.clone( muscle )
			# 	_es.data.muscles.push( m )
			# 	deferred.resolve( m )

			return deferred.promise
			#rsr('api/muscles/add').save( muscle ).$promise

		addExercise : ( exercise ) ->
			deferred = q.defer()
			_es.upsertExercise( "insert", exercise, deferred )
			return deferred.promise

		updateExercise : (exercise) ->
			deferred = q.defer()
			_es.upsertExercise( "update", exercise, deferred )
			return deferred.promise


		getMuscles : ->
			deferred = q.defer()
			_es.apply ->
				deferred.resolve( _.clone( _es.data.muscles ) )
			return deferred.promise

		getMuscle : ( id ) ->
			return _es.muscles( id )

		#getMusclesByIds : (ids) ->
		#	rsr('/api/muscles/get/:ids').query({ 'ids' : ids.join(',') })



		getMuscleGroups : ->
			return _muscleGroups


	}
]
