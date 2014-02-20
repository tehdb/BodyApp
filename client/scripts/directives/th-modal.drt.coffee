angular.module("BodyApp").directive "thModal", [ 
	"$q",	"$timeout",
	( q,	tmt ) ->
		restrict : "E"
		scope : {
			show : "=" # or "=options"
			pos : "="
			confirm : "="
		}
		replace : true
		transclude : true
		templateUrl : "tpl/th-modal.tpl.html"
		link : (scp, elm, atr ) ->
			_$content = elm.find('.th-modal-content:first')
			scp.data = {
				confirmable : false
			}

			scp.apply = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.confirm = true if scp.confirm?
				scp.show = false

			scp.cancel = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.confirm = false if scp.confirm?
				scp.show = false



			scp.$watch "show", (nv,ov) ->
				if nv is true
					scp.data.confirmable = true if _.isBoolean( scp.confirm )

					y = scp.pos?[1]
					if _.isNumber(y) and y > 10
						y -= Math.round( _$content.height() / 2 )
						_$content.css({ y : y })

]