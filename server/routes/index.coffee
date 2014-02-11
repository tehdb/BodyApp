ExerciseSchema = require('../schemas/exercise.schm')
MusclesSchema = require('../schemas/muscle.schm')

allowOrigin = (res) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
	res.header('Access-Control-Allow-Headers', 'Content-Type')

exports.index = () ->
	return (req, res) ->
		res.render("index", {
			title : "app"
		})


exports.options = (req, res) ->
	allowOrigin( res )
	res.end()


exports.getExercises = (db) ->
	return (req, res) ->
		allowOrigin( res )

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
		allowOrigin( res )

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
		allowOrigin( res )

		res.format
			# http : ->
			# 	res.send( "http request not alowed" )

			json : ->
				rb = req.body
				record = new ExerciseSchema({
					title : rb.title
					descr : rb.descr
					muscles : rb.muscles
				})

				record.save( (err) ->
					if err
						res.status(500).json({
							status : 'failure'
						})
					else
						res.status(200).json({
							status : 'success'
						})
				)


exports.addMuscle = (db) ->
	return (req, res) ->
		allowOrigin( res )
		res.format
			json : ->
				record = new MusclesSchema( req.body )
				record.save (err, rec) ->
					if err
						res.status(500).json({
							status : 'failure'
						})
					else
						res.status(200).json({
							status : 'success'
							message : rec._id
						})

exports.getMuscles = (db) ->
	return (req, res) ->
		allowOrigin( res )
		MusclesSchema.find {}, (err, docs) ->
			if err
				res.status(500).json({
					status : 'failure'
				})
			else
				res.send( docs )
