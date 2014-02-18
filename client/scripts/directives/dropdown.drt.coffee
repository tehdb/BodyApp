angular.module("BodyApp").directive "thDropdown", [ () ->
	restrict : "E"
	replace : true
	scope : {
		options : "=options"
		selected : "=selected"
		class : "@class"
	}
	templateUrl : "tpl/dropdown.tpl.html"
	link : ( scp, elm, atr ) ->
		scp.hideMenu = true
		# scp.selected =  {
		# 	name : "Select"
		# }
		_$menu = $(elm).find('.th-menu')


		scp.select = (event, idx) ->
			event.preventDefault()
			event.stopPropagation()
			scp.selected = scp.options[idx]
			scp.hideMenu = true
			# TODO: make the form dynamic
			#scp.$emit 'dropdown.select', [ scp.selected.id ]


		scp.toggle = (event)->
			event.preventDefault()
			event.stopPropagation()
			scp.hideMenu = not scp.hideMenu

		# _moveMenu = ->
		# 	_$menu.css('top', "100%")
		# 	wh = $(window).height() + $(document).scrollTop()
		# 	mh = _$menu.outerHeight() + _$menu.offset().top
		# 	dif = wh - mh
		# 	if dif < 0
		# 		_$menu.css('top', dif + "px")

		# scp.$watch 'hideMenu', (nv, ov) ->
		# 	if nv is false
		# 		_$menu.css('y', 0)
		# 		wh = $(window).height() + $(document).scrollTop()
		# 		mh = _$menu.outerHeight() + _$menu.offset().top + 10
		# 		dif = wh - mh
		# 		if dif < 0
		# 			_$menu.css('y', dif)


]
