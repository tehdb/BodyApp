ExerciseSchema = require('../schemas/exercise.schm')

exports.getExercises = (db) ->
	return (req, res) ->

		ExerciseSchema.find({}, (err, docs) ->
			if err
				res.status(500).json({
					status : 'failure'
				})
			else
				res.send( docs )
		)

exports.getExercise = (db) ->
	return (req, res) ->

		ExerciseSchema.findById( req.params.id, (err, doc) ->
			if err
				res.status(500).json({
					status : 'failure'
				})
			else
				res.send( doc )
		)



exports.addExercise = (db) ->
	return (req, res) ->

		res.format
			json : ->
				rb = req.body

				record = new ExerciseSchema({
					title : rb.title
					descr : rb.descr
					muscles : rb.muscles
				})


				ExerciseSchema.update( _id : { _id : rb._id }, record, {upsert : true}, (err, rec) ->
					console.log err
				#record.save( (err, rec) ->
					if err
						res.status(500).json({
							status : 'failure'
						})
					else
						res.send( rec )
						# res.status(200).json({
						# 	status : 'success'
						# })
				)
