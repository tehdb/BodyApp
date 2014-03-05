mongoose = require 'mongoose'
ObjectID = require('mongodb').ObjectID

muscle = mongoose.Schema(
	{
		name : {
			type : String
			unique : true
			required : true
		},
		group : {
			type : Number
			required : true
		}
	},{
		collection : 'muscles'
	}
)


muscle.methods.getActionRegex = ->
	return /(id|group|name)-[A-Za-z0-9]+/


muscle.methods.handleAction = (action, cb) ->
	action = action.split("-")
	switch action[0]
		when 'id'
			try
				id = new ObjectID( action[1] )
			catch err
				return cb new Error("Invalid Oid")

			@model('Muscle').findById id, (err, doc ) ->
				if err then cb err else cb null, doc


		when 'group'
			group = action[1]
			@model('Muscle').find { group :group }, (err, docs) ->
				cb err if err
				cb null, docs

		when 'name'
			name = decodeURI(action[1])
			@model('Muscle').findOne { name : name}, (err, doc) ->
				cb err if err

				if doc is null
					cb new Error("Name not found")
				else
					cb null, doc
		else
			cb new Error("Action does not match any pattern")

exports.Muscle = mongoose.model 'Muscle', muscle
