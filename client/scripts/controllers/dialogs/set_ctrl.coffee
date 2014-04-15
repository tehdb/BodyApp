angular.module("BodyApp").controller( "SetDialogCtrl", [
	'$scope', '$modalInstance', 'preset',
	( $scope, $instance, preset ) ->
		# defaults
		$scope.data = {
			title: 'set dialog'
			form: null
		}

		# init
		do ->
			if not _.isNull( preset )
				$scope.data.form = angular.copy( preset )

		# $scope.upsert = (event) ->
		# 	event.preventDefault()
		# 	event.stopPropagation()
		# 	e_srv.upsert( $scope.data.form ).then (data) ->
		# 		$instance.close( 'upserted' )

		# $scope.remove = (event) ->
		# 	event.preventDefault()
		# 	event.stopPropagation()

		# 	if confirm("delete #{$scope.data.form.title}?")
		# 		e_srv.remove( $scope.data.form ).then ( data) ->
		# 			$instance.close( 'deleted' )

		$scope.done = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.close( $scope.data.form );

		$scope.dismiss = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.dismiss( 'dismiss call' )

		return
])
