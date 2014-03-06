_ = require("underscore")
async = require("async")
ObjectID = require('mongodb').ObjectID

HttpError = require('../errors/HttpError').HttpError

models = {
	muscle : 	require('../schemas/muscle_shm').Muscle
	exercise : 	require('../schemas/exercise_shm').Exercise
	promo : 	require('../schemas/promo_shm').Promo
}


module.exports = (app) ->
	app
		.get(		"/",									_index() )

		.options(	/\/api\/\w*\/(select|upsert|remove)/, 	_allowOrigin )

		.get(		"/api/muscle/select/:action?",			_select( models.muscle ) )
		.put(		"/api/muscle/upsert",					_upsert( models.muscle ) )
		.delete(	"/api/muscle/remove",					_remove( models.muscle ) )

		.get(		"/api/exercise/select/:action?",		_select( models.exercise ) )
		.put(		"/api/exercise/upsert",					_upsert( models.exercise ) )
		.delete(	"/api/exercise/remove",					_remove( models.exercise ) )

		.get(		"/api/promo/select/:action?",			_select( models.promo ) )
		.put(		"/api/promo/upsert",					_upsert( models.promo ) )
		.delete(	"/api/promo/remove",					_remove( models.promo ) )

		.use (err, req, res, next ) ->
			res.status( err.status ).json( {"message" : err.message } )


_index = () ->
	return (req, res) ->
		res.render("index", {
			title : "app"
		})


_allowOrigin = (req, res) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
	res.header('Access-Control-Allow-Headers', 'Content-Type')
	res.end()


_select = ( model ) ->
	(req, res, next) ->
		action = req.params.action

		# select all
		if not action?
			model.find {}, (err, docs) ->
				return next( new HttpError(404, err.message ) ) if err # TODO: handle system error
				res.json docs
		else
			m = new model()
			if m.getActionRegex().test action
				m.handleAction action, (err, docs) ->
					return next( new HttpError(404, err.message ) ) if err
					res.json docs

			else
				next new HttpError( 404, "Invalid action")


_upsertOne = ( obj, model, cb ) ->
	model.findOne { '_id' : obj._id }, (err, doc) ->
		if doc?
			delete obj._id
			model.findByIdAndUpdate doc._id, obj, (err, doc ) ->
				cb( err, doc )
		else
			m = new model( obj )
			m.save (err, doc) ->
				cb( err, doc )


_upsert = ( model ) ->
	(req, res, next) ->
		res.format
			json : ->
				rb = req.body

				# TODO: move upsert to schema methods
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
							return next( new HttpError(404, err.message ) ) if err # TODO: handle system error
							res.send resultArr
					)

				else
					_upsertOne rb, model, ( err, doc) ->
						return next( new HttpError(404, err.message ) ) if err # TODO: handle system error
						res.send doc

#
# DELETE : /api/exercise/remove/
# {"_id":"530506d8c96d36a583ea1175"}
#
_remove = ( model ) ->
	(req, res, next) ->
		res.format
			json : ->
				try
					id = new ObjectID( req.body._id )
				catch err
					return cb new Error("Invalid Oid")

				model.findById id, (err, doc) ->
					next err if err # TODO: handle system error
					if doc?
						model.findByIdAndRemove doc._id, (err, doc ) ->
							next err if err
							res.status(200).json({ message : "success" })
					else
						next new HttpError( 404, "Oid not found")





