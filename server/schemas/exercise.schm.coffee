mongoose = require 'mongoose'

schema = mongoose.Schema()
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

# TODO: validate data before save

# exerciseSchema.pre('validate', (next) ->

# 	next()
# )

# exerciseSchema.pre('save', (next) ->
# 	# this.title
# 	# this.descr
# 	# this.muscles
# 	next()
# )

exports.Exercise = mongoose.model 'Exercise', schema
