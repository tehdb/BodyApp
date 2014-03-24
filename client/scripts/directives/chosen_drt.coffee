angular.module("BodyApp")
.directive( "chosen", [
	"$q", "$timeout", "$compile",
	( q, timeout, compile ) ->
		restrict : "E"
		scope : {
			placeholder : "@"
			optionLabel : "@"
			fullscreen : "@"
			options : "="
			selected : "="
		}
		replace : true
		transclude : true
		templateUrl : "tpl/directives/chosen.html"
		link : (scope, element, attrs ) ->
			_optionTemplate = null

			_initScopeData = ->
				scope.data = {
					showMenu : false
					# selected : []
					available : null
					multiSelect : []
				}

			_initOptionTemplate = ->
				ot = element.find( "div[option-template]" )
				cls = ot.attr('option-template')
				tpl = '<div class="' + cls + '">' + ot.html() + '</div>'
				_optionTemplate = tpl

			_initWatchers = ->
				scope.$watch( 'options', (nv, ov) ->
					scope.data.multiSelect = []
					scope.data.available = angular.copy nv if nv?
				, true)

			_initFullScreen = ->
				oh = $(window).height()
				oh -= element.find('.control-panel-top:first').outerHeight()
				oh -= element.find('.control-panel-bottom:first').outerHeight()
				oh -= element.find('.addons:first').outerHeight()
				oh -= 10
				element.find('.options:first ul:first').css('max-height', oh)


			do ->
				_initScopeData()
				_initOptionTemplate()
				_initWatchers()
				_initFullScreen() if scope.fullscreen is 'true'

			scope.getOptionTemplate = ->
				return _optionTemplate


			## public methods ##################################################
			scope.toggleMenu = ( event ) ->
				event.preventDefault()
				event.stopPropagation()

				scope.data.showMenu = !scope.data.showMenu

			scope.select = ( event, index) ->
				event.preventDefault()
				event.stopPropagation()
				option = scope.data.available.splice( index, 1)
				scope.selected.push( option[0] )
				scope.data.multiSelect = []
				scope.data.showMenu = false


			scope.isMultiSelected = ( index ) ->
				_.contains( scope.data.multiSelect, index )

			scope.multiSelect = (event, index) ->
				event.preventDefault()
				event.stopPropagation()

				if index is 'apply'
					selected = scope.data.available.multisplice( scope.data.multiSelect )
					_.each selected, (element) ->
						scope.selected.push( element )

					scope.data.multiSelect = []
					scope.data.showMenu = false

				else if index is 'all'
					# toggle select/unselect all
					if scope.data.multiSelect.length isnt scope.data.available.length
						_.each scope.data.available, (element, index ) ->
							scope.data.multiSelect.push( index ) if  !scope.isMultiSelected(index)
					else
						scope.data.multiSelect = []

						# console.log "unselect"

				else
					if scope.isMultiSelected( index )
						scope.data.multiSelect = _.without( scope.data.multiSelect, index )
					else
						scope.data.multiSelect.push( index )


			scope.unselect = (event, index) ->
				event.preventDefault()
				event.stopPropagation()
				option = scope.selected.splice( index, 1 )
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
