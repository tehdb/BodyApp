angular.module("BodyApp").controller( "ExerciseCtrl", [
	"$scope", "$routeParams", "$location", "$modal", "ExercisesService", "PromosService",
	( $scope, $routeParams, $location, $modal, exercises_srv, promos_srv ) ->
		# defaults
		$scope.data = {
			exercise : null
			completable : false
			curSetIdx: 0
		}

		# init
		do ->
			exercises_srv.getById( $routeParams.id ).then (exercise) ->
				$scope.data.exercise = exercise
				promos_srv.getLastProgress( $scope.data.exercise._id ).then ( progress ) ->
					$scope.data.progress = progress

		# public
		$scope.doSetModal = (event) ->
			event.preventDefault()
			event.stopPropagation()

			presetFn = -> return $scope.data.progress.sets[ $scope.data.curSetIdx ]

			$modal.open({
				template: '"{{templates/dialogs/set.html}}"'
				controller: 'SetDialogCtrl'
				resolve: { preset: presetFn }
			}).result.then( (data) ->
				# set completable on first done set
				$scope.data.completable = true if not $scope.data.completable

				# update set with new data, set type to complete
				$scope.data.progress.sets[ $scope.data.curSetIdx ] = _.extend( data, {type:  "complete"})

				# append empty set to progress if no more previous sets
				if ++$scope.data.curSetIdx > $scope.data.progress.sets.length - 1
					curSet = $scope.data.progress.sets[ $scope.data.curSetIdx - 1 ]
					newSet = angular.copy( _.omit( curSet, 'type' ) )
					newSet.inc = $scope.data.curSetIdx + 1
					$scope.data.progress.sets.push( newSet )
			)


		$scope.completeExercise = (event) ->
			event.preventDefault()
			event.stopPropagation()
			completed = _.where( $scope.data.progress.sets, { type : "complete" } )

			promos_srv.add( $scope.data.exercise._id, completed ).then ( progress ) ->
				$scope.data.progress = progress
				$scope.data.curSetIdx = 0
				$scope.data.completable = false

])
