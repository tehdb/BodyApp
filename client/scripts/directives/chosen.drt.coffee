angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", "$filter", ( q, tmt, cpl, tch, f ) ->
	restrict : "E"
	scope : {
		options : "=" # or "=options"
		addform : "=addform"
	}
	replace : true
	templateUrl : "tpl/chosen.tpl.html"

	link : (scp, elm, atr ) ->
		scp.selected = []
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
			#tmt( ->
			_$menu.css('y', 0)
			wh = $(window).height() + $(document).scrollTop()
			mh = _$menu.outerHeight() + _$menu.offset().top + 10
			dif = wh - mh
			_$menu.css('y', dif) if dif < 0
			#, 11)

		scp.$watch( '[toggles.showMenu, toggles.showFilter, toggles.showAddForm]', (nv, ov) ->
			if _.contains( nv, true )
				_adjustMenu()
		, true )

		scp.$watch( 'options', (nv, ov) ->
			_adjustMenu()
		, true )
			#console.log nv, ov

		scp.$on 'dropdown.select', (event, data ) ->
			event.preventDefault()
			event.stopPropagation()
			_selectedMuscleGroup = data[0]

		scp.$on 'form.submit', (event, data) ->
			scp.options = scp.options.concat( scp.selected )
			scp.selected = []

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

		scp.select = ( index, event ) ->
			event.preventDefault()
			event.stopPropagation()

			# select the right option from filtered options
			if scp.searchText isnt ''
				filtered = f("filter")( scp.options, scp.searchText )
				selected = filtered[index]

				scp.selected.push( selected )
				for opt, idx in scp.options
					if opt.$$hashKey is selected.$$hashKey
						scp.options.splice( idx, 1)
						break

			# select unfiltered option
			else
				scp.selected.push( scp.options[index] )
				scp.options.splice( index, 1)

			scp.toggles.showMenu = false
			scp.$emit( 'chosen.update', [scp.selected] )

		scp.prevent = (event) ->
			event.preventDefault()
			event.stopPropagation()

		scp.clear = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.searchText = ""

		scp.add = (event) ->
			event.preventDefault()
			event.stopPropagation()

			if scp.newElement isnt '' and _selectedMuscleGroup isnt 0
				scp.$emit( 'chosen.add', {
					name : scp.newElement
					group : _selectedMuscleGroup
				})
				scp.newElement = ''
])
