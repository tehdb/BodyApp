angular.module('BodyApp').controller('ModalInstanceCtrl', [
	'$scope', '$modalInstance', 'tempData',
	($scope, $modalInstance, tempData) ->
		

		console.log tempData

		$scope.close = ->
			$modalInstance.close('closed')

		$scope.dismiss = ->
			$modalInstance.dismiss('dismiss')

		return
])


angular.module('BodyApp').controller('FeaturesController', [
	'$scope', '$modal',
	( $scope, $modal ) ->
		$scope.data = {
			title : "Features"
			isCollapsed : true
			tempData : { 1: 'tehdb', 2: 'murs'}
		}


		$scope.openModal = () ->
			modalInstance = $modal.open({
				template: '"{{templates/dialogs/testModal.html}}"'
				controller: 'ModalInstanceCtrl'
				resolve: {
					tempData: ->
						return $scope.data.tempData
				}
			})

			modalInstance.result.then( 
				( data ) ->
					console.log "1", data
				, ( data ) ->
					console.log "2", data
					#console.log('Modal dismissed at: ' + new Date())
			)


		return
])
