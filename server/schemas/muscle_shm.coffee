mongoose = require 'mongoose'

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
			id = action[1]
			if /^[0-9a-fA-F]{24}$/.test id
				this.model('Muscle').findById id, (err, doc ) ->
					cb err if err
					cb null, doc
			else
				cb new Error("Invalid Oid")

		when 'group'
			group = action[1]
			this.model('Muscle').find { group :group }, (err, docs) ->
				cb err if err
				cb null, docs

		when 'name'
			name = decodeURI(action[1])
			this.model('Muscle').findOne { name : name}, (err, doc) ->
				cb err if err

				if doc is null
					cb new Error("Name not found")
				else
					cb null, doc
		else
			cb new Error("Action does not match any pattern")

exports.Muscle = mongoose.model 'Muscle', muscle
