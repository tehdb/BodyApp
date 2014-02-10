angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", ( q, to, cpl, tch ) ->
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

			# TODO: select filtered
			scope.selected.push( scope.options[index] )
			scope.options.splice( index, 1)
			scope.showmenu = false

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

					elem.click( (event) ->
						event.preventDefault()
						event.stopPropagation()
						that.toggleMenu()
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
