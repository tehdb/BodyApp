angular.module("BodyApp").filter "exercise", ->
	( list, query, type ) ->

		switch type
			when 'text'
				if query?.length >= 3
					return _.filter list, (exercise) ->
						return exercise.title?.indexOf( query ) isnt -1 or exercise.descr?.indexOf(query) isnt -1
			when 'group'
				return list if query is 0

				return _.filter list, (exercise) ->
					res = false
					for muscle in exercise.muscles
						if muscle.group.id is query
							res = true
							break
					# _.each exercise.muscles, (muscle) ->
					# 	# console.log muscle.group.id is query
					# 	return true if muscle.group.id is query
					return res

		return list


