angular.module("BodyApp").filter "musclegroup", ->
	# ( exercises, musclegroup ) ->
	# 	if musclegroup?.id isnt 0
	# 		filtered = _.filter exercises, ( e ) ->
	# 			return _.contains( _.pluck( e.muscles, 'group' ), musclegroup.id )

	# 		return filtered

	# 	return exercises

	( list, groupId, type ) ->

		if groupId isnt 0
			switch type
				when 'exercises'
					filtered = _.filter list, ( element ) ->
						return _.contains( _.pluck( element.muscles, 'group' ), groupId )
					return filtered

				when 'muscles'
					return _.filter list, (element) ->
						return element.group is groupId
		return list


