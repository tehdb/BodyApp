angular.module("BodyApp").filter "exercise", ->
	# ( exercises, musclegroup ) ->
	# 	if musclegroup?.id isnt 0
	# 		filtered = _.filter exercises, ( e ) ->
	# 			return _.contains( _.pluck( e.muscles, 'group' ), musclegroup.id )

	# 		return filtered

	# 	return exercises

	( list, text ) ->

		if text?.length >= 3

			filtered =  _.filter list, (element) ->
				return element.title.indexOf( text ) isnt -1

			console.log filtered
			return filtered
			# console.log list
			# console.log text
		# if groupId isnt 0
		# 	switch type
		# 		when 'exercises'
		# 			filtered = _.filter list, ( element ) ->
		# 				return _.contains( _.pluck( element.muscles, 'group' ), groupId )
		# 			return filtered

		# 		when 'muscles'
		# 			return _.filter list, (element) ->
		# 				return element.group.id is groupId
		return list


