
angular.module("BodyApp").controller "MainCtrl", [ "$scope", ( $s ) ->
	$s.title = "main ctrl title"

	$s.safeApply = (fn) ->
		phase = this.$root.$$phase;
		if(phase == '$apply' || phase == '$digest')
			fn() if fn and typeof(fn) is 'function'
		else
			this.$apply(fn)
] #MainCtrl
