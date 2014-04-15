angular.module("BodyApp").controller( "ExerciseDialogCtrl", [
	'$scope', '$modalInstance', 'ExercisesService', 'preset',
	( $scope, $instance, e_srv, preset ) ->
		# defaults
		$scope.data = {
			title: 'exercise dialog'
			delup: false 				# delete or update flag
			form: {
				title: ''
				descr: ''
				muscles: null
			}
		}

		# init
		do ->
			if not _.isNull( preset )
				$scope.data.delup = true
				$scope.data.form = angular.copy( preset )

		$scope.upsert = (event) ->
			event.preventDefault()
			event.stopPropagation()
			e_srv.upsert( $scope.data.form ).then (data) ->
				$instance.close( 'upserted' )

		$scope.remove = (event) ->
			event.preventDefault()
			event.stopPropagation()

			if confirm("delete #{$scope.data.form.title}?")
				e_srv.remove( $scope.data.form ).then ( data) ->
					$instance.close( 'deleted' )

		$scope.dismiss = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.dismiss( 'dismiss call' )

		return
])
