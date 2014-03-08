
angular.module("BodyApp").service( "ExercisesService", [
	"$q", "$timeout", "$http", "Settings",
	( q, timeout, http, settings ) ->
		_exercises = []


		return {
			getAll : ->
				deferred = q.defer()
				http(
					url : "#{settings.apis.exercise}select"
					method : 'GET'
					headers: {
						'Accept' : 'application/json'
					}
				).success( (data, status, headers, config) ->
					_exercises = data
					deferred.resolve( _exercises )
				).error (data, status, headers, config) ->
					deferred.reject( status )
				return deferred.promise

			upsert : ( exercise ) ->
				deferred = q.defer()

				http(
					url : "#{settings.apis.exercise}upsert"
					method : 'PUT'
					data : exercise
					headers: {
						'Accept' : 'application/json'
						'Content-Type' : 'application/json;charset=UTF-8'
					}
				).success( (data, status, headers, config) ->
					# update
					if exercise._id?
						# find and update in cache
						for element, index in _exercises
							if element._id is exercise._id
								_exercises[index] = data
								break

					#insert
					else
						_exercises.push( data )
					deferred.resolve( data )
				).error (data, status, headers, config) ->
					deferred.reject( status )

				return deferred.promise
		}
])
