angular.module("BodyApp").controller( "MuscleDialogCtrl", [
	'$scope', '$modalInstance', 'MusclesService', 'preset',
	( $scope, $instance, m_srv, preset ) ->
		
		# defaults
		$scope.data = {
			title: 'muscle dialog'
			delup: false 						# delete or update flag
			muscleGroups: m_srv.getGroups()
			muscleForm: {
				group : m_srv.getGroups()?[0]
				name : ''
			} 
		}

		# init
		do ->
			if not _.isNull( preset )
				$scope.data.delup = true
				$scope.data.muscleForm = _.omit( preset, '$$hashKey' )

		$scope.upsert = (event) ->
			event.preventDefault()
			event.stopPropagation()
			m_srv.upsert( $scope.data.muscleForm ).then ( data ) ->
				$instance.close( 'upserted' )

		$scope.remove = (event) ->
			event.preventDefault()
			event.stopPropagation()

			if confirm("delete #{$scope.data.muscleForm.name}?")
				m_srv.remove( $scope.data.muscleForm ).then ( data) ->
					$instance.close( 'deleted' )

		$scope.dismiss = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.dismiss( 'dismiss call' )

		return
])
