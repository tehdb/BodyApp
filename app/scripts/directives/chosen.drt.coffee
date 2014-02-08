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

		scope.dropdown = (event) ->
			event.preventDefault()
			event.stopPropagation()
			#$(event.currentTarget).dropdown()

			console.log $(event.currentTarget)

	]


	templateUrl : "tpl/chosen.tpl.html"
	link : (scope, elem, attrs ) ->

		scope.options = scope[attrs.thChosen]
		scope.selected = []
		scope.searchText = ''
		scope.newElement = ''

		scope.showmenu = false


		elem.click( (event) ->
			scope.safeApply ->
				scope.searchText = ""
				scope.showmenu = !scope.showmenu
			return false
		)

])
