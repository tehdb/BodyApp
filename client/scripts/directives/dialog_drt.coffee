angular.module("BodyApp").directive "dialog", [
	"$q", "$timeout", "SETTINGS"
	( q, timeout, sttgs ) ->
		restrict : "E"
		scope : {
			title : "@"
			show : "="
			type : "@"
			position : "@"
			trigger : "="
			confirm : "="

		}
		replace : true
		transclude : true
		templateUrl : "tpl/directives/dialog.html"
		link : (scope, element, attrs ) ->

			$_content = element.find('.dialog-content:first')
			# scope.position = scope.position || 'center'
			# console.log scope.position
			# scope.type = scope.type || 'modal'
			# scope.data = {
			# 	confirmable : false
			# }

			_initModal = ->
				element.addClass('type-modal').click (event) ->
					event.preventDefault()
					event.stopPropagation()
					scope.$apply ->
						scope.show = false

			_initPopuver = ->
				#

			_initTooltip = ->
				#

			do ->
				switch scope.type
					when 'modal' then _initModal()
					when 'popover' then _initPopuver()
					when 'tooltip' then _initTooltip()


			_positionAbsolute = ->
				wh = $(window).height()
				ww = $(window).width()

				# set max dialog size based on window size
				$_content.css({
					'max-width' : if ww >= 768 then 600 else ww - 20
				})

				# get dialog size
				ah = $_content.actual( 'outerHeight' )
				aw = $_content.actual( 'outerWidth' )

				# set defaults if no values present
				scope.position = scope.position || 'center'
				x = scope.trigger?.clientX || Math.round( ww / 2)
				y = scope.trigger?.clientY || Math.round( wh / 2)

				# start position relative to trigger or window center
				$_content.css({
					x : x - Math.round( aw / 2 )
					y : y - Math.round( ah / 2 )
					opacity : 0
					scale : 0
				})

				# top-left		top 		top-right
				# left 			center		right
				# bottom-left	bottom 		bottom-right
				pos = scope.position.split("-")
				x = switch
					when pos[1] is 'left' then 10
					when pos[1] is 'right' then (ww-aw-10)
					else Math.round( (ww - aw ) / 2 )
				y = switch
					when pos[0] is 'top' then 10
					when pos[0] is 'bottom' then (wh-ah-10)
					else Math.round( (wh - ah ) / 2 )

				# animate the appearance of the dialog
				# check if x,y coordinates are in the visible view
				$_content.transition({
					x : if x < 10 then 10 else x
					y : if y < 10 then 10 else y
					opacity : 1
					scale : 1
				}, 400, 'out', ->
					# trigger callback on animation end
				)

				# enable window scrolling if dialog height is larger then window
				if (y + ah + 10) > wh then element.addClass('overflow') else element.removeClass('overflow')

			_positionRelative = ->
				console.log scope.trigger.target
				# x = scope.trigger?.clientX || Math.round( ww / 2)
				# y = scope.trigger?.clientY || Math.round( wh / 2)

			_applyPosition = ->
				switch scope.type
					when 'modal' then _positionAbsolute()
					when 'popover' then _positionRelative()
					when 'tooltip' then _initTooltip()
					else _positionAbsolute()



			scope.prevent = (event) ->
				event.preventDefault()
				event.stopPropagation()
				console.log "prevent"

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
					# scope.data.confirmable = true if _.isBoolean( scope.confirm )

					_applyPosition()
				else
					$('body').removeClass('modal-open')

]
