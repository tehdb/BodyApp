angular.module("BodyApp").directive( "muscleChosen", [
	"$q", "$timeout", "$compile", "MusclesService",
	( q, tmt, cpl, musclesService ) ->
		restrict : "E"
		scope : {
			# options : "="
			selected : "="
		}
		replace : true
		templateUrl : "tpl/directives/muscle-chosen.html"

		link : (scp, elm, atr ) ->
			scp.data = {
				available : []
				filtered : null
				searchText : ''
				newMuscle : ''
				muscleGroups : musclesService.getGroups()
				muscleGroup : musclesService.getGroups()[0]
				toggles : {
					showMenu : false
					showFilter : false
					showAddForm : false
				}
			}

			scp.selected = scp.selected || []
			musclesService.getAll().then (data) ->
				scp.options = data


			_$menu = $(elm).find('.options')

			_adjustMenu = ->
				_$menu.css('y', 0)
				wh = $(window).height() + $(document).scrollTop()
				mh = _$menu.outerHeight() + _$menu.offset().top + 10
				dif = wh - mh
				_$menu.css('y', dif) if dif < 0


			do _watchOptionChanges = ->
				scp.$watch( 'options' , (nv,ov) ->
					# on initialize
					if nv? and not ov?
						# check if options are selected
						if _.isArray( scp.selected ) and scp.selected.length > 0
							filtered = _.filter nv, (o) ->
								return not _.contains( _.pluck( scp.selected , '_id' ), o._id )
							scp.data.available = angular.copy( filtered )
						else
							scp.data.available = angular.copy(nv)

					# on add new muscle
					# TODO: on remove muscle?
					else if nv? and ov? and nv isnt ov
						scp.data.available.push( angular.copy( _.last( nv ) ) )
						#lastIdx = nv.length - 1
						#newMuscle = nv[lastIdx]
						#if newMuscle._id?
						#	scp.data.available.push( angular.copy(newMuscle) )
				, true )


			do _watchSelectedChanges = ->
				scp.$watch 'selected', (newVal) ->
					scp.data.available = angular.copy( scp.options ) if _.isUndefined(newVal)

				# scp.$watch( 'selected', (nv,ov) ->
				# 	console.log "selected", nv
				# 	if nv?.length is 0 and ov?.length > 0
				# 		scp.data.available = angular.copy( scp.options )
				# , true )


			# do _watchForChanges = ->
			_watchForChanges = ->
				scp.$watch( '[data.toggles.showMenu, data.toggles.showFilter, data.toggles.showAddForm]', (nv, ov) ->
					if _.contains( nv, true )
						_adjustMenu()
				, true )

				scp.$watch( 'options', (nv, ov) ->
					_adjustMenu()
				, true )


			scp.add = (event) ->
				event.preventDefault()
				event.stopPropagation()

				musclesService.upsert({
					name : scp.data.newMuscle
					group : scp.data.muscleGroup.id
				}).then ( data )->
					scp.options.push( data )
					scp.data.newMuscle = ''

				# if scp.data.newMuscle isnt '' #and _selectedMuscleGroup isnt 0
				# 	es.addMuscle({
				# 		name : scp.data.newMuscle
				# 		group : scp.data.muscleGroup.id
				# 	}).then (data) ->
				# 		scp.options.push( data )
				# 		scp.data.newMuscle = ''

			scp.toggleMenu = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.searchText = ""
				scp.data.toggles.showMenu = !scp.data.toggles.showMenu

			scp.toggleFilter = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.toggles.showFilter = !scp.data.toggles.showFilter

			scp.toggleAddForm = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.toggles.showAddForm =  !scp.data.toggles.showAddForm

			scp.unselect = (index, event ) ->
				event.preventDefault()
				event.stopPropagation()
				scp.options.push( scp.selected[index] )
				scp.selected.splice( index, 1)

			scp.select = (index, event) ->
				event.preventDefault()
				event.stopPropagation()

				scp.selected = scp.selected || []

				# select the right option from filtered options
				if scp.data.searchText isnt ''
					selected = scp.data.filtered[index]
					scp.selected.push( selected )
					for opt, idx in scp.data.available
						if opt.$$hashKey is selected.$$hashKey
							scp.data.available.splice( idx, 1)
							break

				# select unfiltered option
				else
					scp.selected.push( scp.data.available[index] )
					scp.data.available.splice( index, 1)

				scp.data.toggles.showMenu = false


			scp.prevent = (event) ->
				event.preventDefault()
				event.stopPropagation()

			scp.clear = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.searchText = ""
])
