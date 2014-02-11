mongoose = require 'mongoose'

shema = mongoose.Schema({
		title : String
		descr : String
		muscles : Array 
	},{
		collection : 'exercises'
	}
)
# TODO: validate data before save

# exerciseShema.pre('validate', (next) ->

# 	next()
# )

# exerciseShema.pre('save', (next) ->
# 	# this.title
# 	# this.descr
# 	# this.muscles
# 	next()
# )

module.exports = mongoose.model('exercise', shema)