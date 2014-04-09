angular.module("BodyApp").controller( "MuscleDialogCtrl", [
	'$scope', '$modalInstance', 'MusclesService', 'title',
	( $scope, $instance, ms_, title ) ->
		$scope.data = {
			title : title
			muscleGroups : ms_.getGroups()
			muscleGroup : ms_.getGroups()?[0]
		}

		$scope.dismiss = (event) ->
			event.preventDefault()
			event.stopPropagation()
			$instance.dismiss('dismiss')

		return
])
