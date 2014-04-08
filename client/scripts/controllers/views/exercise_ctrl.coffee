angular.module("BodyApp").controller "ExerciseCtrl", [
	"$scope", "$routeParams", "$location", "ExercisesService", "PromosService",
	( scp, routeParams, location, exercisesService, promosService ) ->
		scp.data = {
			exercise : null
			muscles : null
			completable : false
			sets : null
			set : {
				value : null
				index : 0
			}
			upsertModal : {
				show : false
				pos : null
				confirmed : false
				set : null
			}
		}

		do _init = ->
			exercisesService.getById( routeParams.id ).then (exercise) ->
				scp.data.exercise = exercise
				# exercisesService.getMuscles().then (muscles) ->
				#	scp.data.muscles = muscles

				promosService.getLastProgress( scp.data.exercise._id ).then ( progress ) ->
					# scp.data.sets = progress.sets
					scp.data.progress = progress
					scp.data.set.value = scp.data.progress.sets[scp.data.set.index]
					scp.data.upsertModal.set = angular.copy scp.data.set.value



		scp.$watch "data.upsertModal.confirmed", (nv, ov) ->
			if nv is true
				scp.data.completable = true if scp.data.completable is false

				scp.data.set.value.heft = scp.data.upsertModal.set.heft
				scp.data.set.value.reps = scp.data.upsertModal.set.reps
				# scp.data.set.value = _.pick( scp.data.upsertModal.set, "heft", "reps" )
				scp.data.set.value.inc = scp.data.set.index + 1
				scp.data.set.value.type = "complete"


				if ++scp.data.set.index > scp.data.progress.sets.length - 1
					scp.data.progress.sets.push {
						inc : scp.data.set.index + 1
						heft : scp.data.set.value.heft
						reps : scp.data.set.value.reps
					}

				scp.data.set.value = scp.data.progress.sets[scp.data.set.index]
				scp.data.upsertModal.set = angular.copy scp.data.set.value
				scp.data.upsertModal.show = false
				scp.data.upsertModal.confirmed = false


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


		scp.complete = ->
			completed = _.where( scp.data.progress.sets, { type : "complete" })

			_.each completed , (elm, idx, list) ->
				completed[idx] = _.pick( elm, "inc", "heft", "reps" )

			promosService.add( scp.data.exercise._id, completed ).then ( progress ) ->
				scp.data.progress = progress
				scp.data.set.index = 0
				scp.data.set.value = scp.data.progress.sets[scp.data.set.index]
				scp.data.upsertModal.set = angular.copy scp.data.set.value
				scp.data.completable = false


		scp.submitForm = ->
			exercise = _.pick( scp.data.exercise, '_id', 'title', 'descr')
			exercise.muscles = _.pluck( scp.data.exercise.muscles, '_id')

			exercisesService.updateExercise( exercise ).then (data) ->
				_hideEditExerciseModal()


		scp.deleteExercise = (event)->
			event.preventDefault()
			event.stopPropagation()
			exercisesService.deleteExercise( scp.data.exercise._id ).then (data) ->
				_hideEditExerciseModal ->
					scp.safeApply ->
						location.path('/exercises')

]
