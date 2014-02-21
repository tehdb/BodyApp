Exercise = require('../schemas/exercise.schm').Exercise


exports.list = (db) ->
	return (req, res) ->
		Exercise.find {}, (err, docs) ->
			if err
				res.status(500).json({ status : 'failure' })
				return false

			res.send(docs)


exports.find = (db) ->
	return (req, res) ->
		Exercise.findById req.params.id, (err, doc) ->
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

				Exercise.findById rb._id, (err, doc) ->
					if doc?
						Exercise.findByIdAndUpdate doc._id, exercise, (err, rec) ->
							if err
								res.status(500).json({ status : 'failure' })
								return false

							res.send(rec)
					else
						es = new Exercise(exercise)
						es.save (err, rec) ->
							if err
								res.status(500).json({ status : 'failure'})
								return false

							res.send( rec )


exports.delete = (db) ->
	return (req, res) ->
		Exercise.findByIdAndRemove req.params.id, (err, doc) ->
			if err
				res.status(500).json({ status : 'failure' })
				return false

			res.send(true)
