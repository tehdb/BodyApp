angular.module("BodyApp")
.directive( "chosen", [
	"$q", "$timeout", "$compile", 
	( q, timeout, compile ) ->
		restrict : "E"
		scope : {
			placeholder : "@"
			options : "="
			selected : "="
		}
		replace : true
		transclude : true
		templateUrl : "tpl/directives/chosen.html"
		link : (scope, element, attrs ) ->

			_optionTemplate = null

			do ->
				ot = element.find( "div[option-template]" )
				cls = ot.attr('option-template')
				tpl = '<div class="' + cls + '">' + ot.html() + '</div>'
				_optionTemplate = tpl

			## set default data ################################################
			scope.data = {
				showMenu : false
				selected : []
				available : null
				multiSelect : []
			}


			## init watchers ###################################################
			scope.$watch( 'options', (nv, ov) ->
				scope.data.available = angular.copy nv if nv?
			, true)
			
			scope.getOptionTemplate = ->
				return _optionTemplate 


			## public methods ##################################################
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
]).directive( "chosenOption", [
	"$compile",
	(compile) ->
		scope : {
			template : "&"
			option : "="
		}
		restrict : "E"
		replace : true
		template : '<div class="option"></div>'
		link : (scope, element, attrs ) ->
			_template= scope.template()
			
			if not _.isUndefined( _template )
				element.html( compile( _template )(scope) )


])
