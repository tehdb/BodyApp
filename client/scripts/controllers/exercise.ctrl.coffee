angular.module("BodyApp").controller "ExerciseCtrl", [
	"$scope", "$routeParams", "$location", "ExercisesService", "SetsService",
	( scp, rps, lcn, es, ss ) ->
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
			es.getExercise( rps.id ).then (exercise) ->
				scp.data.exercise = exercise

				es.getMuscles().then (muscles) ->
					scp.data.muscles = muscles

				ss.getLastExersiceSets( scp.data.exercise._id ).then (sets) ->
					scp.data.sets = sets || [{
						idx : 1
						heft : 50
						reps : 10
						type : "incomplete"
					}]
					scp.data.set.value = scp.data.sets[scp.data.set.index]
					scp.data.upsertModal.set = angular.copy scp.data.set.value



		scp.$watch "data.upsertModal.confirmed", (nv, ov) ->
			if nv is true
				scp.data.completable = true if scp.data.completable is false

				scp.data.set.value.heft = scp.data.upsertModal.set.heft
				scp.data.set.value.reps = scp.data.upsertModal.set.reps
				scp.data.set.value.type = "complete"


				if ++scp.data.set.index > scp.data.sets.length - 1
					scp.data.sets.push {
						idx : scp.data.set.index + 1
						heft : scp.data.set.value.heft
						reps : scp.data.set.value.reps
						type : "incomplete"
					}

				scp.data.set.value = scp.data.sets[scp.data.set.index]
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
			completed = _.where scp.data.sets, { type : "complete"}
			for c, i in completed
				completed[i] = _.pick c, "idx", "heft", "reps"

			ss.add( scp.data.exercise._id, completed ).then ( sets ) ->
				scp.data.sets = sets
				scp.data.set.index = 0
				scp.data.set.value = scp.data.sets[scp.data.set.index]
				scp.data.upsertModal.set = angular.copy scp.data.set.value
				scp.data.completable = false


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
