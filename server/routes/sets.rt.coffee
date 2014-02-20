

#	- 		- last
#	all
#	week
#	month
#	year
#	10
#	10-20
exports.get = (db) ->
	return (req, res) ->
		exrcid = req.params.id
		action = req.params.action

		if not action?
			out = "get last sets"

		else if /[a-z]+/.test action
			switch action
				when "all"
					out = "get all sets"

				when "week"
					out = "get week data"

				when "month"
					out = "get month data"

				when "year"
					out = "get year data"

		else if /[0-9]+-?[0-9]*/.test action
			count = action.split("-")

			if count.length is 1
				out = "get last #{action}"

			else if count[1] isnt ''
				out = "get from #{count[0]} to #{count[1]}"





		res.send( out || "no match" )

exports.add = (db) ->
	return (req, res) ->
		res.format
			json : ->
				rb = req.body

				# {
				# 	id : "exercise-id"
				#	sets : "array or object"
				# }
				res.send( rb )
