Muscle = require('../schemas/muscle.shm').Muscle



exports.select = (req, res) ->
	muscleId = req.params.id
	
	#action = req.params.action
	# "/api/muscles/select/id-XXX"
	# "/api/muscles/select/group-XXX-XXX-XXX"
	# "/api/muscles/select/name-XXX"


	# select all
	if not muscleId? 
		Muscle.find {}, (err, muscles) ->
			throw err if err
			res.send muscles
	else
		# select by group
		
		
		# select by id
		Muscle.findById muscleId, (err, muscle ) ->
			throw err if err
			res.send muscle



exports.upsert = (req, res) ->
	res.send("upsert")