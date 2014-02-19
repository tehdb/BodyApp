angular.module("BodyApp").controller "ExerciseCtrl", [ 
	"$scope",
	"$routeParams",
	"$location",
	"ExercisesService",
	( scp, rps, lcn, es ) ->
		scp.data = {
			exercise : null
			muscles : null
		}

		es.getExercise( rps.id ).then (exercise) ->
			scp.data.exercise = exercise


		es.getMuscles().then (muscles) ->
			scp.data.muscles = muscles


		_hideEditExerciseModal = (cb)->
			modal = $('#editExerciseModal').modal('hide')


			if _.isFunction(cb)
				modal.one 'hidden.bs.modal', ->
					cb()

		scp.submitForm = ->
			exercise = _.pick( scp.data.exercise, '_id', 'title', 'descr')
			exercise.muscles = _.pluck( scp.data.exercise.muscles, '_id')

			es.updateExercise( exercise ).then (data) ->
				_hideEditExerciseModal()
				

		scp.deleteExercise = (event)->
			event.preventDefault()
			event.stopPropagation()
			es.deleteExercise( scp.data.exercise._id ).then (data) ->
				_hideEditExerciseModal ->
					scp.safeApply ->
						lcn.path('/exercises')

]
