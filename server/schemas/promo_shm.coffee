mongoose = require 'mongoose'
ObjectID = require('mongodb').ObjectID

promo = mongoose.Schema(
	{
		exercise : {
			type : String
			unique : true
			required : true
		},
		progress : [{
			date : {
				type : Date
				default : Date.now
			},
			sets : [{
				inc : Number
				heft : Number
				reps : Number
			}]
		}]
	},{
		collection : 'promos'
	}
)

promo.methods.getActionRegex = ->
	return /(id|exercise)-[A-Za-z0-9]+/


promo.methods.handleAction = (action, cb) ->
	action = action.split("-")
	switch action[0]
		when 'id'
			try
				id = new ObjectID( action[1] )
			catch err
				return cb( new Error("Invalid Oid") )

			@model('Promo').findById id, (err, doc ) ->
				return cb( err ) if err
				cb( null, doc )

		when 'exercise'
			exercise = decodeURI(action[1])
			@model('Promo').findOne { exercise : exercise}, (err, doc) ->
				return cb( err ) if err
				if doc then cb( null, doc ) else cb( new Error("Exercise not found") )


		# TODO:
		# when 'last'
		# when 'lastweek'
		# when 'lastyear'
		else
			cb( new Error("Action does not match any pattern") )


exports.Promo = mongoose.model( 'Promo', promo )
