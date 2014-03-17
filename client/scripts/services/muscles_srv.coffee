angular.module("BodyApp").service( "MusclesService", [
	"$q", "$timeout", "$http",
	( q, timeout, http ) ->
		that = @
		_muscles = []
		_groups = "{{../client/database/musclegroups.json}}"

		# insert group object to group property instead if group id
		_prepare = (data, cb ) ->
			if _.isArray(data)
				_.each data, (element, index, list ) ->
					list[index].group = _.findWhere _groups, { id : element.group }
			else
				data.group = _.findWhere _groups, { id : data.group }

			cb(data)

		_apply = (cb) ->
			if _.isEmpty( _muscles )
				that.getAll().then ->
					cb()
			else
				# timeout becouse of promise nature
				timeout( ->
					cb()
				,0)


		@getAll = ->
			deferred = q.defer()
			if _.isEmpty( _muscles )
				http(
					url : "/api/muscle/select"
					method : 'GET'
					headers: {
						'Accept' : 'application/json'
					}
				).success( (data, status, headers, config) ->
					_prepare data, (data) ->
						_muscles = data
						deferred.resolve( _muscles )
				).error (data, status, headers, config) ->
					deferred.reject( status )
			else
				timeout(->
					deferred.resolve( _muscles )
				,0)

			return deferred.promise


		@getGroups = ->
			return _groups


		@getById = (id) ->
			deferred = q.defer()
			_apply ->
				deferred.resolve( _.findWhere( _muscles, {_id : id }) )
			return deferred.promise


		@upsert = (muscle) ->
			deferred = q.defer()
			http(
				url : "/api/muscle/upsert"
				method : 'PUT'
				data : muscle
				headers: {
					'Accept' : 'application/json'
					'Content-Type' : 'application/json;charset=UTF-8'
				}
			).success( (data, status, headers, config) ->
				# update
				if muscle._id?
					# find and update in cache
					for element, index in _muscles
						if element._id is muscle._id
							_prepare data, (data) ->
								_muscles[index] = data
								deferred.resolve( data )
							break

				#insert
				else
					_prepare data, (data) ->
						_muscles.push( data )
						deferred.resolve( data )

			).error (data, status, headers, config) ->
				deferred.reject( status )

			return deferred.promise

		@remove = (muscle) ->
			deferred = q.defer()
			http(
				url : "/api/muscle/remove"
				method : 'DELETE'
				data : { _id : muscle._id}
				headers: {
					'Accept' : 'application/json'
					'Content-Type' : 'application/json;charset=UTF-8'
				}
			).success( (data, status, headers, config) ->
				# remove element from cache
				for element, index in _muscles
					if element._id is muscle._id
						_muscles.splice(index, 1)
						break
				deferred.resolve( data )
			).error (data, status, headers, config) ->
				deferred.reject( status )

		return
])
