mongoose = require 'mongoose'

schema = mongoose.Schema({
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
})

exports.Promotion = mongoose.model( 'Promotion', schema )