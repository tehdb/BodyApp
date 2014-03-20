angular.module("BodyApp")
.directive( "chosen", [

	"$q", "$timeout",
	( q, timeout ) ->
		restrict : "E"
		scope : {
			options : "="
			optionTitle : "@"
			placeholder : "@"
			selected : "="
		}
		replace : true
		transclude : false
		templateUrl : "tpl/directives/chosen.html"
		link : (scope, element, attrs ) ->

			scope.data = {
				showMenu : false
				selected : []
				available : null
				multiSelect : []
			}

			scope.$watch( 'options', (nv, ov) ->
				scope.data.available = angular.copy nv if nv?
			, true)


			scope.toggleMenu =  ->
				scope.data.showMenu = !scope.data.showMenu

				return false


			scope.select = (index) ->
				option = scope.data.available.splice( index, 1)



				scope.data.selected.push( option[0] )
				return false

			scope.isMultiSelected = ( index ) ->
				_.contains( scope.data.multiSelect, index )

			scope.multiSelect = (event, index) ->
				event.preventDefault()
				event.stopPropagation()

				if index is -1
					console.log scope.data.multiSelect
					scope.data.showMenu = false
				else
					if scope.isMultiSelected( index )
						scope.data.multiSelect = _.without( scope.data.multiSelect, index )
					else
						scope.data.multiSelect.push( index )


			scope.unselect = (index) ->
				option = scope.data.selected.splice( index, 1 )
				scope.data.available.push( option[0] )
				return false




			return
])
