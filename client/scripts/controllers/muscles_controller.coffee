angular.module("BodyApp").controller "MusclesController", [
	"$scope", "ExercisesService", "MusclesService",
	( scope, exercisesService, musclesService ) ->
		scope.data = {
			title : "muscles"
			muscles : []
			filtered : null
			muscleGroup : musclesService.getGroups()?[0]
			muscleGroups : musclesService.getGroups()
			showMuscleModal : false
			edit : false
			form : {
				group : musclesService.getGroups()?[0]
				update : false
			}
		}

		console.log musclesService.getGroups()

		musclesService.getAll().then (data) ->
			scope.data.muscles = data

		scope.insertModal = ->
			scope.data.form = {
				group : musclesService.getGroups()?[0]
				name : ''
				update : false
			}
			scope.data.showMuscleModal = true

		scope.upsertModal = (index) ->
			muscle = scope.data.filtered[index]

			scope.data.form = {
				_id : muscle._id
				group : _.findWhere( scope.data.muscleGroups, { id : muscle.group })
				name : muscle.name
				update : true
			}

			scope.data.showMuscleModal = true

		scope.remove = ->
			data = _.omit( scope.data.form, 'update' )
			data.group = data.group.id
			musclesService.remove(data).then (data) ->
				scope.data.form = {
					group : musclesService.getGroups()?[0]
					update : false
				}
				scope.data.showMuscleModal = false

		scope.upsert = ->
			data = _.omit( scope.data.form, 'update' )
			data.group = data.group.id
			musclesService.upsert(data).then ( data )->
				scope.data.form.name = ''
				scope.data.showMuscleModal = false
				# console.log data
				# scope.data.muscles.push( data )
				# scope.data.form = {
				# 	group : scope.data.muscleGroups[0]
				# }



		# console.log scope.data.muscleGroups

		# scp.data = {
		# 	muscleGroups : es.getMuscleGroups()
		# 	muscleGroup : null
		# 	muscles : null
		# 	exercises : []
		# 	filtered : []
		# 	searchText : ''
		# 	addExerciseModal : {
		# 		show : false
		# 		confirmed : false
		# 	}

		# }

		# scp.data.muscleGroup = scp.data.muscleGroups[0]

		# scp.addForm = {
		# 	title : ''
		# 	descr : ''
		# 	muscles : []
		# }

		# es.getExercises().then((data) ->
		# 	console.log data
		# 	scp.data.exercises = data
		# ).catch( ->
		# 	console.log "cant load data"
		# )


		# es.getMuscles().then (data) ->
		# 	scp.data.muscles = data

		# # TODO: watch for changes on exercises/muscles

		# scp.submitForm = ->
		# 	if scp.exrcForm.$valid && scp.addForm.muscles.length > 0
		# 		muscleIds = []
		# 		_.each scp.addForm.muscles, (muscle) ->
		# 			muscleIds.push( muscle._id )
		# 		scp.addForm.muscles = muscleIds

		# 		es.addExercise( scp.addForm ).then (data) ->
		# 			# scp.data.exercises.push( data )
		# 			scp.addForm = {
		# 				title : ''
		# 				descr : ''
		# 				muscles : []
		# 			}
		# 			$('#addExerciseModal').modal('hide')
]
