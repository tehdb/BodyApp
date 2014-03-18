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


		_getPromo = ( exerciseId ) ->

			# first initialize promos
			if _.isNull( _promos )

				# get storred data
				_promos = lss.get('promos')

				# if no data in storage create new data object
				if _.isNull( _promos )
					_promos = []
					_promos.push({
						exercise : exerciseId
						progress : []
					})

					# store data
					lss.set('promos', JSON.stringify( _promos ))
					return _promos[0]

				# parse storred data
				else
					_promos = JSON.parse( _promos )


			# find promo in cache
			promo = _.findWhere( _promos, { exercise : exerciseId } )

			# no promo in cache
			if _.isUndefined( promo )
				promo = {
					exercise : exerciseId
					progress : []
				}
				_promos.push( promo )
				lss.set('promos', JSON.stringify( _promos ))

			return promo


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


		@getLastProgress = ( exerciseId ) ->
			def = q.defer()
			timeout( ->
				promo = _getPromo( exerciseId )

				progress = _.last( promo.progress )
				if _.isUndefined( progress )
					# TODO: get default set data for exercise
					progress = {
						date : null
						sets : [{
							inc : 1
							heft : 50
							reps : 10
						}]
					}

				def.resolve( progress )
			, 0 )
			return def.promise


		@add = ( exerciseId, sets ) ->
			def = q.defer()
			timeout(->
				def.resolve( _pushSetsToPromo( exerciseId, sets ) )
			,0)
			return def.promise

		return

])