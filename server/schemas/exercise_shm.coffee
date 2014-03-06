mongoose = require 'mongoose'
ObjectID = require('mongodb').ObjectID

exercise = mongoose.Schema(
	{
		title : {
			type : String
			unique : true
			required : true
		},
		descr : String
		muscles : [{
			type : String
		}]
	},{
		collection : 'exercises'
	}
)

exercise.methods.getActionRegex = ->
	return /(id|title|muscle)-[A-Za-z0-9]+/


exercise.methods.handleAction = (action, cb) ->
	action = action.split("-")
	switch action[0]
		when 'id'
			try
				id = new ObjectID( action[1] )
			catch err
				return cb new Error("Invalid Oid")

			@model('Exercise').findById id, (err, doc ) ->
				cb err if err
				cb null, doc

		when 'title'
			title = decodeURI(action[1])
			@model('Exercise').findOne { title : title}, (err, doc) ->
				cb err if err
				if doc is null
					cb new Error("Title not found")
				else
					cb null, doc

		when 'muscle'
			muscle = action[1]
			@model('Exercise').find { muscles : muscle }, (err, docs) ->
				cb err if err
				if docs is null
					cb new Error("Muscle not found")
				else
					cb null, docs

		else
			cb new Error("Action does not match any pattern")

exports.Exercise = mongoose.model 'Exercise', exercise
