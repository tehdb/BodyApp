angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", "$filter", ( q, tmt, cpl, tch, f ) ->
	restrict : "E"
	scope : {
		options : "=" # or "=options"
		addform : "=addform"
		selected : "="
	}
	replace : true
	templateUrl : "tpl/chosen.tpl.html"

	link : (scp, elm, atr ) ->
		#console.log scp.selected
		#scp.selected = scp.selected || []
		scp.available = null

		scp.searchText = ''
		scp.newElement = ''

		scp.toggles = {
			showMenu : false
			showFilter : false
			showAddForm : false
		}

		_selectedMuscleGroup = 0
		_$menu = $(elm).find('.options')


		_adjustMenu = ->
			_$menu.css('y', 0)
			wh = $(window).height() + $(document).scrollTop()
			mh = _$menu.outerHeight() + _$menu.offset().top + 10
			dif = wh - mh
			_$menu.css('y', dif) if dif < 0


		do _watchOptionChanges = ->
			scp.$watch( 'options' , (nv,ov) ->
				if nv? and not ov?
					scp.available = angular.copy(nv)
				else if nv? and ov? and nv isnt ov
					lastIdx = nv.length - 1
					newOption = nv[lastIdx]
					if newOption._id?
						scp.available.push( angular.copy(newOption) )
			, true )


		do _watchSelectedChanges = ->
			scp.$watch( 'selected', (nv,ov) ->
				if nv?.length is 0 and ov?.length > 0
					scp.available = angular.copy( scp.options )
			, true )


		# do _watchForChanges = ->
		_watchForChanges = ->
			scp.$watch( '[toggles.showMenu, toggles.showFilter, toggles.showAddForm]', (nv, ov) ->
				if _.contains( nv, true )
					_adjustMenu()
			, true )

			scp.$watch( 'options', (nv, ov) ->
				_adjustMenu()
			, true )


		scp.add = (event) ->
			event.preventDefault()
			event.stopPropagation()
			if scp.newElement isnt '' and _selectedMuscleGroup isnt 0
				newOption = {
					name : scp.newElement
					group : _selectedMuscleGroup
				}
				scp.options.push( newOption )
				scp.newElement = ''


		scp.$on 'dropdown.select', (event, data ) ->
			event.preventDefault()
			event.stopPropagation()
			_selectedMuscleGroup = data[0]

		scp.toggleMenu = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.searchText = ""
			scp.toggles.showMenu = !scp.toggles.showMenu

		scp.toggleFilter = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.toggles.showFilter =  !scp.toggles.showFilter

		scp.toggleAddForm = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.toggles.showAddForm =  !scp.toggles.showAddForm

		scp.unselect = (index, event ) ->
			event.preventDefault()
			event.stopPropagation()
			scp.options.push( scp.selected[index] )
			scp.selected.splice( index, 1)

		scp.select = (index, event) ->
			event.preventDefault()
			event.stopPropagation()

			# select the right option from filtered options
			if scp.searchText isnt ''
				filtered = f("filter")( scp.available, scp.searchText )
				selected = filtered[index]
				scp.selected.push( selected )
				for opt, idx in scp.available
					if opt.$$hashKey is selected.$$hashKey
						scp.available.splice( idx, 1)
						break

			# select unfiltered option
			else
				scp.selected.push( scp.available[index] )
				scp.available.splice( index, 1)

			scp.toggles.showMenu = false


		scp.prevent = (event) ->
			event.preventDefault()
			event.stopPropagation()

		scp.clear = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.searchText = ""
])
