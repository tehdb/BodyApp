angular.module("BodyApp").filter "exercise", ->
	( list, query, type ) ->

		switch type
			# filter by text query
			when 'text'
				if query?.length >= 3
					return _.filter list, (exercise) ->
						res = false
						if exercise.title.search( query ) isnt -1
							res = true
						return res

			# filter by muscle group id
			when 'group'
				return list if query is 0

				return _.filter list, (exercise) ->
					res = false
					for muscle in exercise.muscles
						if muscle.group.id is query
							res = true
							break
					return res

		return list


