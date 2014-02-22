mongoose = require 'mongoose'

shema = mongoose.Schema(
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


shema.methods.getActionRegex = ->
	return /(id|group)-[A-Za-z0-9]+/


shema.methods.handleAction = (action, cb) ->
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
			this.model('Muscle').find { group : action[1] }, (err, docs) ->
				cb err if err
				cb null, docs
		else
			cb new Error("Action does not match any pattern")

exports.Muscle = mongoose.model 'Muscle', shema
