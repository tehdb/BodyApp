mongoose = require 'mongoose'

exercise = mongoose.Schema(
	{
		title : {
			type : String
			unique : true
			required : true
		},
		descr : String
		muscles : [{
			muscle : String
		}]
	},{
		collection : 'exercises'
	}
)

exercise.methods.getActionRegex = ->
	return /(id|group|muscle)-[A-Za-z0-9]+/


exercise.methods.handleAction = (action, cb) ->
	action = action.split("-")
	switch action[0]
		when 'id'
			id = action[1]
			if /^[0-9a-fA-F]{24}$/.test id
				this.model('Exercise').findById id, (err, doc ) ->
					cb err if err
					cb null, doc
			else
				cb new Error("Invalid Oid")

		# when 'group'
		# 	this.model('Muscle').find { group : action[1] }, (err, docs) ->
		# 		cb err if err
		# 		cb null, docs
		else
			cb new Error("Action does not match any pattern")

exports.Exercise = mongoose.model 'Exercise', exercise
