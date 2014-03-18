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
				newMuscleForm : {
					name : ''
					group : musclesService.getGroups()[0]
				}
				muscleGroups : musclesService.getGroups()
				toggles : {
					showMenu : false
					showFilter : false
					showAddForm : false
				}
			}

			scp.selected = scp.selected || []
			musclesService.getAll().then (data) ->
				scp.data.options = data



			# TODO: weiter beobahten
			# do _watchOptionChanges = ->
			# 	scp.$watch scp.data.options, (newVal, oldVal) ->
			# 		console.log newVal, oldVal


			do _watchSelectedChanges = ->
				scp.$watch 'selected', ( newVal, oldVal ) ->
					if _.isArray( newVal )
						selectedIds = _.pluck( newVal, '_id')
						scp.data.available = _.filter scp.data.options , (elm) ->
							return not _.contains( selectedIds, elm._id)
					else
						scp.data.available = angular.copy( scp.data.options )


			# do _watchForChanges = ->
			# 	_$menu = $(elm).find('.options')

			# 	_adjustMenu = ->
			# 		_$menu.css('y', 0)
			# 		wh = $(window).height() + $(document).scrollTop()
			# 		mh = _$menu.outerHeight() + _$menu.offset().top + 10
			# 		dif = wh - mh
			# 		_$menu.css('y', dif) if dif < 0

			# 	scp.$watch( '[data.toggles.showMenu, data.toggles.showFilter, data.toggles.showAddForm]', (nv, ov) ->
			# 		if _.contains( nv, true )
			# 			_adjustMenu()
			# 	, true )

			# 	scp.$watch( 'options', (nv, ov) ->
			# 		_adjustMenu()
			# 	, true )

			# TODO: store muscle form over MuscleService
			scp.add = (event) ->
				event.preventDefault()
				event.stopPropagation()

				form = angular.copy( scp.data.newMuscleForm )
				form.group = form.group.id
				musclesService.upsert( form ).then ( data ) ->
					scp.data.available.push( data )
					scp.data.newMuscleForm.name = ''
					# scp.options.push( data )
					# scp.data.newMuscle = ''

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
				scp.data.available.push( scp.selected[index] )
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
