mongoose = require 'mongoose'

shema = mongoose.Schema({
		name : String
		group : Number
	},{
		collection : 'muscles'
	}
)

exports.Muscle = mongoose.model('Muscle', shema)