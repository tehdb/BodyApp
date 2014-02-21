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


exports.Muscle = mongoose.model 'Muscle', shema
