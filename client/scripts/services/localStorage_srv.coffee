angular.module("BodyApp").service( "LocalStorageService", [
	"$q",
	( q ) ->
		that = @

		@get = ( key ) ->
			res = localStorage.getItem( key )
			return null if _.isNull( res )

			res = LZString.decompress( res )
			res = angular.fromJson( res )
			return res

		@set = ( key, val ) ->
			val = angular.toJson( val )
			val = LZString.compress( val )
			return localStorage.setItem( key, val )

		@remove = ( key ) ->
			return localStorage.removeItem( key )

		@clear = ->
			return localStorage.clear()

		return
])
