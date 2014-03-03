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
				next new Error("Invalid action")



_upsertOne = ( obj, model, cb ) ->

	model.findOne { '_id' : obj._id }, (err, doc) ->
		if doc?
			delete obj._id
			model.findByIdAndUpdate doc._id, obj, (err, doc ) ->
				cb( err, doc )
		else
			m = new model( obj)
			m.save (err, doc) ->
				cb( err, doc )

exports.upsert = ( model ) ->
	(req, res, next) ->
		res.format
			json : ->
				rb = req.body

				if _.isArray( rb )
					resultArr = []
					async.each(
						rb
						, (obj, cb) ->
							_upsertOne obj, model, ( err, doc) ->
								throw err if err
								resultArr.push( doc )
								cb()
						, (err) ->
							next err if err
							res.send resultArr
					)

				else
					_upsertOne rb, model, ( err, doc) ->
						next err if err
						res.send doc

#
# DELETE : /api/exercise/remove/
# {"_id":"530506d8c96d36a583ea1175"}
#
exports.remove = ( model ) ->
	(req, res, next) ->
		res.format
			json : ->
				id = req.body._id
				if /^[0-9a-fA-F]{24}$/.test id
					model.findById id, (err, doc) ->
						next err if err
						if doc?
							model.findByIdAndRemove doc._id, (err, doc ) ->
								next err if err
								res.status(200).json({ message : "success" })
						else
							next new Error("Oid not found")
				else
					next new Error("Invalid Oid")




