angular.module("BodyApp").service( "PromosService", [
	"$q", "$timeout", "$http", "LocalStorageService",
	( q, timeout, http, lss ) ->
		that = @
		_promos = null

			# [{
			# 	exercise : "5326b926fe272fe20a9c9261"
			# 	progress : [{
			# 		date : new Date().getTime()
			# 		sets : [
			# 			{
			# 				inc : 1
			# 				heft : 100
			# 				reps : 12
			# 			},{
			# 				inc : 2
			# 				heft : 100
			# 				reps : 10
			# 			},{
			# 				inc : 3
			# 				heft : 100
			# 				reps : 8
			# 			}
			# 		]
			# 	}]
			# }]
			# 
		do _init = ->
			storred = JSON.parse( lss.get('promos') )
			if _.isUndefined( storred )
				schema = {}

		_store = ( exerciseId, progress ) ->
			def = q.defer()
			timeout( ->
				for elm, idx in _promos
					if elm.exercise is exerciseId
						newProgress = {
							date : new Date().getTime()
							sets : sets
						}

						_promos[idx].progress.push( newProgress )
						def.resolve( newProgress )
						break
			, 0 )
			return def.promise


		_getPromo = ( exerciseId ) ->
			if _.isNull( _promos )
				_promos = lss.get('promos')

				if _.isNull( _promos )
					_promos = []
					_promos.push({
						exercise : exerciseId
						progress : []
					})

					lss.set('promos', JSON.stringify( _promos ))
					return _promos[0]
				else
					_promos = JSON.parse( _promos )

			return _.findWhere( _promos, { exercise : exerciseId } )



		_pushSetsToPromo = ( exerciseId, sets ) ->

			promo = _getPromo( exerciseId )
			progress = {
				date : new Date().getTime()
				sets : sets
			}

			for elm, idx in _promos
				if elm.exercise is exerciseId
					_promos[idx].progress.push( progress )
					lss.set('promos', JSON.stringify( _promos ))
					break

			return progress




			# if _.
			# _promos = JSON.parse( lss.get('promos') )

			# promo = _.findWhere( promos, { exercise : exerciseId } )
			# if _.isUndefined( _promos )


			# if _.isEmpty( _promos )

			# else
			# 	return _promos

		@getLastProgress = ( exerciseId ) ->

			def = q.defer()
			timeout( ->
				promo = _getPromo( exerciseId )
				def.resolve( _.last( promo.progress ) )
			, 0 )
			return def.promise


		@add = ( exerciseId, sets ) ->
			def = q.defer()
			$timeout(->
				def.resolve( _pushSetsToPromo( exerciseId, sets ) )
			,0)
			# _store( exerciseId, sets ).then (data) ->
			# 	def.resolve( data )
			return def.promise

		return

])