angular.module("BodyApp").service( "MusclesService", [
	"$q", "$timeout", "$http",
	( q, timeout, http ) ->
		class Service
			constructor : ->
				@muscles = []
				@groups = "{{../client/database/musclegroups.json}}"

				console.log @
			getAll : ->

				that = @

				console.log that

				deferred = q.defer()
				if _.isEmpty( that.muscles )
					http(
						url : "/api/muscle/select"
						method : 'GET'
						headers: {
							'Accept' : 'application/json'
						}
					).success( (data, status, headers, config) ->
						that.muscles = data
						deferred.resolve( that.muscles )
					).error (data, status, headers, config) ->
						deferred.reject( status )
				else
					timeout(->
						deferred.resolve( that.muscles )
					,0)

				return deferred.promise

			getGroups : ->
				that = @
				console.log that
				# TODO: why that.groups is empty???
				# console.log "groups", that.groups
				return that.groups

			getById : (id) ->
				that = @
				deferred = q.defer()
				resolve = ->
					deferred.resolve( _.findWhere( that.muscles, {_id : id }) )

				if _.isEmpty( that.muscles )
					that.getAll().then ->
						resolve()
				else
					timeout( ->
						resolve()
					,0)
				return deferred.promise

			upsert : (muscle) ->
				that = @
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
						for element, index in that.muscles
							if element._id is muscle._id
								that.muscles[index] = data
								break

					#insert
					else
						that.muscles.push( data )
					deferred.resolve( data )
				).error (data, status, headers, config) ->
					deferred.reject( status )

				return deferred.promise

			remove : (muscle) ->
				that = @
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
					for element, index in that.muscles
						if element._id is muscle._id
							that.muscles.splice(index, 1)
							break
					deferred.resolve( data )
				).error (data, status, headers, config) ->
					deferred.reject( status )

		service = new Service()

		# TODO: before push muscle to array, insert group object to group property
		# get right reference to this
		return {
			getAll : service.getAll
			getGroups : service.getGroups
			getById : service.getById
			upsert : service.upsert
			remove : service.remove
		}
])
