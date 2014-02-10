angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", "$filter", ( q, to, cpl, tch, f ) ->
	restrict : "A"
	scope : true
	controller : [ "$scope", "$element", "$attrs", "$transclude", (scope, elem, attrs, transclude ) ->
		scope.unselect = (index, event ) ->
			event.preventDefault()
			event.stopPropagation()
			scope.options.push( scope.selected[index] )
			scope.selected.splice( index, 1)

		scope.select = ( index, event ) ->
			event.preventDefault()
			event.stopPropagation()

			# select the right option from filtered options
			if scope.searchText isnt ''
				filtered = f("filter")( scope.options, scope.searchText )
				selected = filtered[index]

				scope.selected.push( selected )
				for opt, idx in scope.options
					if opt.$$hashKey is selected.$$hashKey
						scope.options.splice( idx, 1)
						break

			# select unfiltered option
			else 
				scope.selected.push( scope.options[index] )
				scope.options.splice( index, 1)

			scope.showmenu = false

			# TODO: что-то умнее придумать, а не вызыват метод родительского конструктора
			# scope.updateData( scope.selected ) if typeof scope.updateData is "function"
			scope.$emit( 'chosen.update', [scope.selected] )

		scope.prevent = (event) ->
			event.preventDefault()
			event.stopPropagation()

		scope.clear = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scope.searchText = ""

		scope.add = (event) ->
			event.preventDefault()
			event.stopPropagation()
			if scope.newElement isnt ''
				scope.options.push({
					name : scope.newElement
					group : 1
				})

				scope.newElement = ''
	]


	templateUrl : "tpl/chosen.tpl.html"
	link : (scope, elem, attrs ) ->
			class Link
				constructor : ->
					that = @
					that.menu = elem.find('.options')
					scope.options = scope[attrs.thChosen]
					scope.addform = scope[attrs.thChosenAddform]
					scope.selected = []
					scope.searchText = ''
					scope.newElement = ''
					scope.showmenu = false

					# scope.temp = scope[ attrs.thChosenSelected ]

					elem.click( (event) ->
						event.preventDefault()
						event.stopPropagation()
						that.toggleMenu()
					)

					scope.$on('form.submit', (event, data) ->
						scope.options = scope.options.concat( scope.selected )
						scope.selected = []
					)


				toggleMenu : ->
					that = @
					scope.safeApply ->
						scope.searchText = ""
						scope.showmenu = !scope.showmenu

						if scope.showmenu
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
