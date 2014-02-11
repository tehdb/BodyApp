mongoose = require 'mongoose'

shema = mongoose.Schema({
		name : String
		group : Number
	},{
		collection : 'muscles'
	}
)

module.exports = mongoose.model('muscle', shema)