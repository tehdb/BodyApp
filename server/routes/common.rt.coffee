_ = require("underscore")
async = require("async")



exports.index = () ->
	return (req, res) ->
		res.render("index", {
			title : "app"
		})

exports.allowOrigin = (req, res) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
	res.header('Access-Control-Allow-Headers', 'Content-Type')
	res.end()


exports.select = ( model ) ->
	(req, res, next) ->
		action = req.params.action

		# select all
		if not action?
			model.find {}, (err, docs) ->
				next err if err
				res.json docs
		else
			m = new model()
			if m.getActionRegex().test action
				m.handleAction action, (err, docs) ->
					next err if err
					res.json docs

			else
				res.json { empty : true }



_upsertOne = ( obj, model, cb ) ->

	model.findOne { '_id' : obj._id }, (err, doc) ->
		if doc?
			delete obj._id
			model.findByIdAndUpdate doc._id, obj, (err, doc ) ->
				throw err if err
				cb( doc )
		else
			m = new model( obj)
			m.save (err, doc) ->
				throw err if err
				cb( doc )

exports.upsert = ( model ) ->
	(req, res) ->
		res.format
			json : ->
				rb = req.body

				if _.isArray( rb )
					resultArr = []
					async.each(
						rb
						, (obj, cb) ->
							_upsertOne obj, model, (doc) ->
								resultArr.push( doc )
								cb()
						, (err) ->
							next err if err
							res.send resultArr
					)

				else
					_upsertOne rb, model, (doc) ->
						res.send doc


