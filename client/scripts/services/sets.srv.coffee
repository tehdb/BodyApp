angular.module("BodyApp").service "SetsService", [
	"$q", "$timeout", "$http",
	( q, tmt, htp ) ->
		class Service
			constructor : ->

			getExerciseSets : ->
				return [{
					idx : 1
					heft : 50
					reps : 10
				}]

		_s = new Service()

		return {
				getLast : ( exerciseId ) ->
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
