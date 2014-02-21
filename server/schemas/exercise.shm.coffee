mongoose = require 'mongoose'

schema = mongoose.Schema(
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

exports.Exercise = mongoose.model 'Exercise', schema
