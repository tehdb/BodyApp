ExerciseSchema = require('../schemas/exercise.schm')


exports.list = (db) ->
	return (req, res) ->
		ExerciseSchema.find {}, (err, docs) ->
			if err
				res.status(500).json({ status : 'failure' })
				return false

			res.send(docs)


exports.find = (db) ->
	return (req, res) ->
		ExerciseSchema.findById req.params.id, (err, doc) ->
			if err
				res.status(500).json({ status : 'failure' })
				return false

			res.send(doc)


#	insert or update exercise
#
#	@param db [mongoose.connection]
#

exports.upsert = (db) ->
	return (req, res) ->
		res.format
			json : ->
				rb = req.body
				exercise = {
					title : rb.title
					descr : rb.descr
					muscles : rb.muscles
				}

				ExerciseSchema.findById rb._id, (err, doc) ->
					if doc?
						ExerciseSchema.findByIdAndUpdate doc._id, exercise, (err, rec) ->
							if err
								res.status(500).json({ status : 'failure' })
								return false

							res.send(rec)
					else
						es = new ExerciseSchema(exercise)
						es.save (err, rec) ->
							if err
								res.status(500).json({ status : 'failure'})
								return false

							res.send( rec )


exports.delete = (db) ->
	return (req, res) ->
		ExerciseSchema.findByIdAndRemove req.params.id, (err, doc) ->
			if err
				res.status(500).json({ status : 'failure' })
				return false

			res.send(true)
