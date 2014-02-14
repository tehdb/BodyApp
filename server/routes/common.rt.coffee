# ExerciseSchema = require('../schemas/exercise.schm')
# MusclesSchema = require('../schemas/muscle.schm')


exports.index = () ->
	return (req, res) ->
		res.render("index", {
			title : "app"
		})

exports.allowOrigin = (req, res) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS')
	res.header('Access-Control-Allow-Headers', 'Content-Type')
	res.end()
