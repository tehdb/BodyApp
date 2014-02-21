Muscle = require('../schemas/muscle.shm').Muscle
_ = require("underscore")
async = require("async")

#	action = undefined : select all muscles
# 	action = id-XXX	:
exports.select = (req, res) ->
	action = req.params.action

	# select all
	if not action?
		Muscle.find {}, (err, docs) ->
			throw err if err
			res.send docs
	else if /(id|group)-[A-Za-z0-9]+/.test action
		action = action.split("-")
		switch action[0]
			when 'id'
			# select by id
				Muscle.findById action[1], (err, doc ) ->
					res.status(500).json({status : 'rejected', message : err }) if err
					res.send doc

			when 'group'
				Muscle.find { group : action[1] }, (err, docs) ->
					res.status(500).json({status : 'rejected', message : err }) if err
					res.send docs


_upsertOne = ( obj, cb ) ->
	Muscle.findOne { '_id' : obj._id }, (err, doc) ->
		if doc?
			delete obj._id
			Muscle.findByIdAndUpdate doc._id, obj, (err, doc ) ->
				throw err if err
				cb( doc )

			# NOT DELETE!!!
			# Muscle.update { _id : id },  obj, {upsert:true, multi:false}, (err) ->
			# 	res.status(500).json({status : 'rejected', message : err }) if err
			# 	res.send obj
		else
			muscle = new Muscle( obj)
			muscle.save (err, doc) ->
				throw err if err
				cb( doc )

exports.upsert = (req, res) ->
	res.format
		json : ->
			rb = req.body
			if _.isArray( rb )
				musclesArr = []
				async.each(
					rb
					,(obj, cb) ->
						_upsertOne obj, (doc) ->
							musclesArr.push( doc )
							cb()
					,(err) ->
						res.status(500).json({status : 'rejected', message : err }) if err
						res.send musclesArr
				)

			else
				_upsertOne rb , (doc) ->
					res.send doc





