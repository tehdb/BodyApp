exports.index = () ->
	return (req, res) ->
		res.render("index", {
			title : "app"
		})


exports.addExercise = (db) ->
	return (req, res) ->
		res.format
			http : ->
				res.send( "http request not alowed" )

			json : ->
				rb = req.body

				# db.get('data').findOne(

				# )


exports.getExercise = (db) ->
	return (req, res) ->
		res.send("exercise from mongodb")
