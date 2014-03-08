angular.module("BodyApp").controller "MuscleController", [
	"$scope", "$routeParams", "ExercisesService", "MusclesService",
	( scope, params, exercisesService, musclesService ) ->
		scope.data = {

		}

		musclesService.getById( params.id ).then (data) ->
			scope.data.muscle = data
			scope.data.muscle.group = musclesService.getGroupById( data.group )

]
