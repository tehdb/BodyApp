angular.module("BodyApp").controller( "MuscleDialogCtrl", [
	'$scope', '$modalInstance', 'title',
	( $scope, $instance, title ) ->
		$scope.data = {
			title : title
		}


		return
])
