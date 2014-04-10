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
				# $scope.data.muscleForm = _.omit( preset, '$$hashKey' )

		$scope.upsert = (event) ->
			event.preventDefault()
			event.stopPropagation()
			console.log $scope.data.form
			# $scope.data.form.muscles = _.pluck( $scope.data.form.muscles, '_id')
			$instance.close( 'upserted' )

			# e_srv.upsert(scope.data.form).then (data) ->
			# 	$instance.close( 'upserted' )

		# 		
		# $scope.upsert = (event) ->
		# 	event.preventDefault()
		# 	event.stopPropagation()
		# 	m_srv.upsert( $scope.data.muscleForm ).then ( data ) ->
		# 		$instance.close( 'upserted' )

		# $scope.remove = (event) ->
		# 	event.preventDefault()
		# 	event.stopPropagation()

		# 	if confirm("delete #{$scope.data.muscleForm.name}?")
		# 		m_srv.remove( $scope.data.muscleForm ).then ( data) ->
		# 			$instance.close( 'deleted' )

		$scope.dismiss = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.dismiss( 'dismiss call' )

		return
])
