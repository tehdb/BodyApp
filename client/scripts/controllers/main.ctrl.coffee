
angular.module("BodyApp").controller "MainCtrl", [ "$scope", ( scp ) ->
	scp.title = "main ctrl title"
	scp.sidebarShow = false

	scp.toggleSidebar = ( param ) ->
		if param? and typeof param is 'boolean'
			scp.sidebarShow = param
		else
			scp.sidebarShow = not scp.sidebarShow

	scp.safeApply = (fn) ->
		phase = this.$root.$$phase;
		if(phase == '$apply' || phase == '$digest')
			fn() if fn and typeof(fn) is 'function'
		else
			this.$apply(fn)
] #MainCtrl
