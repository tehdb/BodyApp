angular.module("BodyApp").service( "SchedulesService", [
	"$q", "$timeout", "$http", "LocalStorageService",
	( q, timeout, http, lss ) ->
		

		_schedules = [{
			"title" : "Training day 1"
			"descr" : "shoulder and chest"
			"exercises" : []
			"repetition" : "continues"  #"continues | daily-1 | weekly-1"

		},{
			"title" : "Training day 2"
			"descr" : "back and buttocks"
			"exercises" : []
			"repetition" : "continues"
		}]

		@getAll = ->
			def = q.defer()
			timeout(->
				def.resolve( _schedules )
			,0)

			return def.promise


		return
])
