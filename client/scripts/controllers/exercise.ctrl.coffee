angular.module("BodyApp").controller "ExerciseCtrl", [
	"$scope",
	"$routeParams",
	"$location",
	"ExercisesService",
	( scp, rps, lcn, es ) ->
		scp.data = {
			exercise : null
			muscles : null
			sets : null
			set : {
				active : null
				activeIdx : 0
				temp : null
			}
			activeSet : null
			activeSetIdx : 0
			upsertModal : {
				show : false
				pos : null 
				confirmed : false
			}
		}

		scp.data.sets = [
				{
					idx : 1
					heft : "100"
					reps : 12
					type : "previous"
				},{
					idx : 2
					heft : "100"
					reps : 10
					type : "previous"
				},{
					idx : 3
					heft : "100"
					reps : 8
					type : "previous"
				}
		]
		scp.data.activeSet = scp.data.sets[scp.data.activeSetIdx]


		es.getExercise( rps.id ).then (exercise) ->
			scp.data.exercise = exercise


		es.getMuscles().then (muscles) ->
			scp.data.muscles = muscles


		_hideEditExerciseModal = (cb)->
			modal = $('#editExerciseModal').modal('hide')


			if _.isFunction(cb)
				modal.one 'hidden.bs.modal', ->
					cb()

		scp.toggleUpsertModal = (event) ->
			event.preventDefault()
			event.stopPropagation()
			scp.data.upsertModal.show = not scp.data.upsertModal.show
			scp.data.upsertModal.pos = [event.pageX, event.pageY]

		scp.submitForm = ->
			exercise = _.pick( scp.data.exercise, '_id', 'title', 'descr')
			exercise.muscles = _.pluck( scp.data.exercise.muscles, '_id')

			es.updateExercise( exercise ).then (data) ->
				_hideEditExerciseModal()

		# scp.submitUpsertForm = ->
		# 	scp.data.activeSet.type = "current"
		# 	if ++scp.data.activeSetIdx > scp.data.sets.length - 1
		# 		scp.data.sets.push {
		# 			idx : scp.data.activeSetIdx + 1
		# 			heft : scp.data.activeSet.heft
		# 			reps : scp.data.activeSet.reps
		# 			type : "previous"
		# 		}

		# 	scp.data.activeSet = scp.data.sets[scp.data.activeSetIdx]
		# 	scp.data.upsertModal.show = false
		# 	console.log scp.data.upsertModal.confirmed
			# TODO: sove issue with "Referencing DOM nodes in Angular expressions is disallowed"
			#$('#upsertSetModal').modal('hide')



		scp.deleteExercise = (event)->
			event.preventDefault()
			event.stopPropagation()
			es.deleteExercise( scp.data.exercise._id ).then (data) ->
				_hideEditExerciseModal ->
					scp.safeApply ->
						lcn.path('/exercises')

]
