MusclesSchema = require('../schemas/muscle.schm')

exports.addMuscle = (db) ->
	return (req, res) ->
		# allowOrigin( res )
		res.format
			json : ->
				record = new MusclesSchema( req.body )
				record.save (err, rec) ->
					if err
						res.status(500).json( { status : 'failure' } )
					else
						res.send( rec )

exports.getMuscles = (db) ->
	return (req, res) ->
		# allowOrigin( res )
		MusclesSchema.find {}, (err, docs) ->
			if err
				res.status(500).json( { status : 'failure' } )
			else
				res.send( docs )

exports.getMusclesByIds = (db) ->
	return (req, res) ->
		ids = req.params.ids.split(",")

		MusclesSchema.find { "_id" : { $in : ids} }, (err, docs) ->
			if err
				res.status(500).json( { status : 'failure' } )
			else
				res.send( docs )
