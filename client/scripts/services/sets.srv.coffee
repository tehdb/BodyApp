angular.module("BodyApp").service "SetsService", [
	"$q", "$timeout", "$http",
	( q, tmt, htp ) ->
		class Service
			constructor : ->

			getExerciseSets : ->
				return null

				return [{
					idx : 1
					heft : "100"
					reps : 12
				},{
					idx : 2
					heft : "100"
					reps : 10
				},{
					idx : 3
					heft : "100"
					reps : 8
				}]

		_s = new Service()

		return {
				getLastExersiceSets : ( exerciseId ) ->
					deferred = q.defer()
					tmt( ->
						console.log exerciseId
						deferred.resolve _s.getExerciseSets()
					, 0)
					return deferred.promise



				add : (exerciseId, sets ) ->
					deferred = q.defer()
					tmt( ->
						#console.log exerciseId
						console.log "save set", exerciseId, sets
						deferred.resolve sets
					, 0)
					return deferred.promise

		}
]
