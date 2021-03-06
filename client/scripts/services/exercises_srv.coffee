
angular.module("BodyApp").service( "ExercisesService", [
	"$q", "$timeout", "$http", "MusclesService", "SETTINGS",
	( q, timeout, http, ms, sttgs ) ->
		that = @
		_exercises = []

		_enrich = ( exercise ) ->
			def = q.defer()
			musclesLength = exercise.muscles.length - 1
			musclesCount = 0
			muscles = []
			_.each exercise.muscles, (muscleId, muscleIdx, muscleIds) ->
				ms.getById( muscleId).then (muscle) ->
					muscles.push( muscle )
					if ++musclesCount > musclesLength
						exercise.muscles = muscles
						def.resolve( exercise )
			return def.promise


		_prepare = (data) ->
			def = q.defer()
			if _.isArray(data)
				exercisesLength = data.length - 1
				exercisesCount = 0
				exercises = []
				_.each data, (element, index, list) ->
					_enrich( element ).then ( data ) ->
						exercises.push( data )
						def.resolve( exercises ) if ++exercisesCount > exercisesLength
			else
				_enrich( data ).then ( data ) ->
					def.resolve( data )

			return def.promise

		_apply = () ->
			def = q.defer()
			if _.isEmpty( _exercises )
				http(
					url : "#{sttgs.apis.exercise}/select"
					method : 'GET'
					headers: {
						'Accept' : 'application/json'
					}
				).success( (data, status, headers, config) ->
					_prepare(data).then (data) ->
						_exercises = data
						def.resolve( _exercises )
						
				).error (data, status, headers, config) ->
					deferred.reject( status )
			else
				timeout( ->
					def.resolve( _exercises )
				, 0 )

			return def.promise

		@getAll = ->
			def = q.defer()
			_apply().then ->
				def.resolve( _exercises )

			# http(
			# 	url : "#{sttgs.apis.exercise}/select"
			# 	method : 'GET'
			# 	headers: {
			# 		'Accept' : 'application/json'
			# 	}
			# ).success( (data, status, headers, config) ->
			# 	_prepare(data).then (data) ->
			# 		_exercises = data
			# 		
			# ).error (data, status, headers, config) ->
			# 	def.reject( status )
			return def.promise

		@getById = ( id ) ->
			def = q.defer()
			_apply().then ->
				def.resolve( _.findWhere( _exercises, { _id : id } ) )

			return def.promise


		@upsert = (exercise)->
			def = q.defer()

			# if exercise.muscles are objects pluck just the id's
			exercise.muscles = _.pluck( exercise.muscles, '_id') if _.isObject(exercise.muscles[0])

			http(
				url : "#{sttgs.apis.exercise}/upsert"
				method : 'PUT'
				data : exercise
				headers: {
					'Accept' : 'application/json'
					'Content-Type' : 'application/json;charset=UTF-8'
				}
			).success( (data, status, headers, config) ->
				# insert
				if not exercise._id?
					_prepare(data).then (data) ->
						_exercises.push( data )
						def.resolve( data )

				# update
				else
					for element, index in _exercises
						if element._id is exercise._id
							_prepare(data).then (data) ->
								_exercises[index] = data
								def.resolve( data )
							break

			).error (data, status, headers, config) ->
				def.reject( status )

			return def.promise

		@remove = (exercise) ->
			defer = q.defer()
			http(
				url : "#{sttgs.apis.exercise}/remove"
				method : 'DELETE'
				data : { _id : exercise._id}
				headers: {
					'Accept' : 'application/json'
					'Content-Type' : 'application/json;charset=UTF-8'
				}
			).success( (data, status, headers, config) ->
				# remove element from cache
				for element, index in _exercises
					if element._id is exercise._id
						_exercises.splice(index, 1)
						break
				defer.resolve( data )
			).error (data, status, headers, config) ->
				defer.reject( status )
			return defer.promise

		return

])
