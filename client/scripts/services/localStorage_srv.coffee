angular.module("BodyApp").service( "LocalStorageService", [
	"$q", 
	( q ) ->
		that = @

		@get = ( key ) ->
			res = localStorage.getItem( key )
			return null if _.isNull( res )

			res = LZString.decompress( res )

			return JSON.parse( res )

		@set = ( key, val ) ->
			val = JSON.stringify( val )
			val = LZString.compress( val )
			return localStorage.setItem( key, val )

		@remove = ( key ) ->
			return localStorage.removeItem( key )

		@clear = ->
			return localStorage.clear()

		return
])