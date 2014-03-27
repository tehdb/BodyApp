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
			scope.type = scope.type || 'modal'
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
				$_content.css({
					'max-width' : if ww >= 768 then 600 else ww - 20
				})

				ah = $_content.actual( 'outerHeight' )
				aw = $_content.actual( 'outerWidth' )

				x = scope.trigger?.clientX || Math.round( ww / 2)
				y = scope.trigger?.clientY || Math.round( wh / 2)
				
				$_content.css({
					x : x - Math.round( aw / 2 )
					y : y - Math.round( ah / 2 )
					opacity : 0
					scale : 0
				})


				switch scope.position
					when 'top'
						x = Math.round( (ww - aw ) / 2 )
						y = 10 

					when 'center'
						x = Math.round( (ww - aw ) / 2 )
						y = Math.round( (wh - ah ) / 2 )

					when 'bottom'
						x = Math.round( (ww - aw ) / 2 )
						y = Math.round( (wh - 20 - ah ) )

					when 'top-left'
						x = 10
						y = 10

					when 'left'
						x = 10
						y = Math.round( (wh - ah ) / 2 )

					when 'right'
						x = ww - aw - 10
						y = Math.round( (wh - ah ) / 2 )

					when 'top-right'
						x = ww - aw - 10
						y = 10

					when 'bottom-left'
						x = 10
						y = wh - ah - 10

					when 'bottom-right'
						x = ww - aw - 10
						y = wh - ah - 10

					else # defaul top
						x = Math.round( (ww - aw ) / 2 )
						y = 10 


				$_content.transition({
					x : if x < 10 then 10 else x
					y : if y < 10 then 10 else y
					opacity : 1
					scale : 1
				}, 400, 'out', ->
					# console.log "end?"
				)

				if (y + ah + 10) > wh then element.addClass('overflow') else element.removeClass('overflow')

				# element.css({
				# 	'overflow-y' : if (y + ah + 10) > wh then 'scroll' else 'hidden'
				# })
				# 
			_positionRelative = ->
				console.log scope.trigger.target
				# x = scope.trigger?.clientX || Math.round( ww / 2)
				# y = scope.trigger?.clientY || Math.round( wh / 2)
				
			_applyPosition = ->
				switch scope.type
					when 'modal' then _positionAbsolute()
					when 'popover' then _positionRelative()
					when 'tooltip' then _initTooltip()

		

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
