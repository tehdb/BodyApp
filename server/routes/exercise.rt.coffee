Exercise = require('../schemas/exercise.shm').Exercise

exports.select = (req, res) ->
	action = req.params.action

	if not action?
		Exercise.find {}, (err, docs) ->
			throw err if err
			res.send docs
	else if /(id)-[A-Za-z0-9]+/.test action
		action = action.split("-")
		switch action[0]
			when 'id'
				Exercise.findById action[1], (err, doc ) ->
					res.status(500).json({status : 'rejected', message : err }) if err
					res.send doc



exports.upsert = (req, res) ->
	res.format
		json : ->
			rb = req.body

			Exercise.findById rb._id, (err, doc) ->
				exercise = null
				if doc?
					delete rb._id
					Exercise.findByIdAndUpdate doc._id, rb, (err, doc ) ->
						res.status(500).json({status : 'rejected', message : err }) if err
						res.send doc
				else
					exercise = new Exercise( rb )
				exercise.save (err, doc) ->
					res.status(500).json({status : 'rejected', message : err }) if err
					res.send doc
