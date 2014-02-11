angular.module("BodyApp").directive "thDropdown", [ () ->
	restrict : "A"
	scope : true
	link : ( scp, elm, atr ) ->
		class Link
			constructor : () ->
				scp.selected = "button"
				elm.addClass('th-dropdown')

				@label = angular.element("<span>").addClass("th-label").text( scp.selected  )
				@menu = angular.element("<ul>").addClass("th-menu").hide().appendTo(elm)
				@initToggle()
				@initMenu()

			initMenu : ->
				that = @
				options = scp[atr.thDropdown]
				return if not options

				for opt, idx in options
					angular.element("<li>")
						.addClass("th-option")
						.data('id', opt.id)
						.text( opt.name )
						.appendTo( @menu )
						.click( (event) ->
							event.preventDefault()
							event.stopPropagation()
							target = $(this)
							scp.selected = target.text()
							that.label.text( scp.selected )
							scp.$emit( 'dropdown.select', [ target.data('id')] )
							that.menu.hide()
						)

			initToggle : ->
				that = @

				angular.element("<button>")
					.addClass('btn btn-default dropdown-toggle th-toggle')
					.attr("type", "button")
					.append( that.label )
					.append( '<span class="caret"></span>')
					.click( (event) ->
						event.preventDefault()
						event.stopPropagation()
						that.toggleMenu()
					).appendTo( elm )

			toggleMenu : ->
				that = @
				if that.menu.is(':visible')
					that.menu.hide()
				else
					that.menu.show()
					mw = that.menu.outerWidth()
					mh = that.menu.outerHeight()
					mot = that.menu.parent().offset().top

					wh = $(window).height() - 60
					wot = $(document).scrollTop()

					if mot + mh > wot + wh
						y =  -(( mot + mh ) - ( wot + wh ))
						that.menu.css('top', y + "px")
					else
						that.menu.css('top', "100%")


		do -> new Link()
]
