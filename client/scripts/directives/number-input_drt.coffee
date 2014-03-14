angular.module("BodyApp").directive "thNumberInput", [
	"$q",	"$timeout",
	( q,	tmt ) ->
		restrict : "E"
		scope : {
			value : "=" # or "=options"
			class : "@"
			step : "@"
		}
		replace : true
		transclude : false
		templateUrl : "tpl/directives/number-input.html"
		link : (scp, elm, atr ) ->

			scp.increment = ->
				scp.value = parseFloat(scp.value, 10 ) if not _.isNumber( scp.value )
				scp.value += parseFloat(scp.step, 10 ) or 1

			scp.decrement = ->
				scp.value = parseFloat(scp.value, 10 ) if not _.isNumber( scp.value )
				scp.value -= parseFloat(scp.step, 10 ) or 1

]
