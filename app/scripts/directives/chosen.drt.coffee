angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", "$filter", ( q, to, cpl, tch, f ) ->
	restrict : "A"
	scope : true
	controller : [ "$scope", "$element", "$attrs", "$transclude", (scp, elm, atr, trs ) ->
		_selectedMuscleGroup = 0 # TODO: prevent emit and on

		scp.$on 'dropdown.select', (event, data ) ->
			_selectedMuscleGroup = data[0]

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

			scp.showmenu = false

			# scp.updateData( scp.selected ) if typeof scp.updateData is "function"
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
				opt = {
					name : scp.newElement
					group : _selectedMuscleGroup
				}

				scp.options.push( opt )
				scp.newElement = ''
				scp.$emit( 'chosen.add', [ opt ] )
	]


	templateUrl : "tpl/chosen.tpl.html"
	link : (scp, elm, atr ) ->
			class Link
				constructor : ->
					that = @
					that.menu = elm.find('.options')
					scp.options = scp[atr.thChosen]
					scp.addform = scp[atr.thChosenAddform]
					scp.selected = []
					scp.searchText = ''
					scp.newElement = ''
					scp.showmenu = false

					# scp.temp = scp[ atr.thChosenSelected ]

					elm.click( (event) ->
						event.preventDefault()
						event.stopPropagation()
						that.toggleMenu()
					)

					scp.$on('form.submit', (event, data) ->
						scp.options = scp.options.concat( scp.selected )
						scp.selected = []
					)


				toggleMenu : ->
					that = @
					scp.safeApply ->
						scp.searchText = ""
						scp.showmenu = !scp.showmenu

						if scp.showmenu
							to( ->
								wh = $(window).height() - 60
								wot = $(document).scrollTop()
								mh = that.menu.outerHeight()
								mot = that.menu.parent().offset().top
								if mot + mh > wot + wh
									y =  -(( mot + mh ) - ( wot + wh ))
									that.menu.css('top', y + "px")
								else
									that.menu.css('top', "100%")
							,0)


			do -> new Link


])
