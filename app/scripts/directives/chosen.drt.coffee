angular.module("BodyApp").directive( "thChosen", [ "$q", "$timeout", "$compile", "$templateCache", ( q, to, cpl, tch ) ->
	restrict : "A"
	scope : true
	controller : [ "$scope", "$element", "$attrs", "$transclude", (scope, elem, attrs, transclude ) ->
		scope.unselect = (index, event ) ->
			event.preventDefault()
			event.stopPropagation()
			
			scope.selected.splice( index, 1)
			console.log "unselect"
		]

	templateUrl : "tpl/chosen.tpl.html"
	link : (scope, elem, attrs ) ->

		scope.options = scope[attrs.thChosen]
		scope.selected = [
			{
				name : "option 1"
			},{
				name : "option 2"
			},{
				name : "option 3"
			},{
				name : "option 4"
			},{
				name : "option 5"
			}
		]

		elem.click( (event) ->
			console.log "click"
			return false
		)

		# class Chosen
		# 	constructor : (elem) ->
		# 		self = @
		# 		



		# do init = ->
		# 	new Chosen(elem)

])