angular.module("BodyApp").service( "LocalStorageService", [
	"$q", 
	( q ) ->
		that = @

		@get = ( key ) ->
			return localStorage.getItem( key )

		@set = ( key, val ) ->
			return localStorage.setItem( key, val )

		@remove = ( key ) ->
			return localStorage.removeItem( key )

		@clear = ->
			return localStorage.clear()

		return
])