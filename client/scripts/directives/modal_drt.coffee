angular.module("BodyApp").directive "modal", [
	"$q", "$timeout",
	( q, timeout ) ->
		restrict : "E"
		scope : {
			title : "@"
			show : "=" # or "=options"
			position : "@"
			confirm : "="

		}
		replace : true
		transclude : true
		templateUrl : "tpl/directives/modal.html"
		link : (scope, element, attrs ) ->

			$_content = element.find('.th-modal-content:first')

			_applyPosition = ->
				switch scope.position
					#when 'top' # default

					when 'center'
						ah = $_content.actual( 'outerHeight' )
						wh = $(window).height()
						console.log ah, wh
						y = Math.round( (wh - ah ) / 2 )
						$_content.css({y:y}) if y > 0

					when 'bottom'
						ah = $_content.actual( 'outerHeight' )
						wh = $(window).height()
						y = Math.round( (wh - 20 - ah ) )
						$_content.css({y:y}) if y > 0




			scope.data = {
				confirmable : false
			}

			scope.apply = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scope.confirm = true if scope.confirm?
				scope.show = false

			scope.cancel = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scope.confirm = false if scope.confirm?
				scope.show = false

			scope.$watch "show", (nv,ov) ->
				if nv is true
					$('body').addClass('modal-open')
					scope.data.confirmable = true if _.isBoolean( scope.confirm )
					_applyPosition()
					# y = scope.pos?[1]
					# if _.isNumber(y) and y > 10
					# 	y -= Math.round( _$content.height() / 2 )
					# 	_$content.css({ y : y })
				else
					$('body').removeClass('modal-open')

]
