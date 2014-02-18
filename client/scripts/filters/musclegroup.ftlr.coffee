angular.module("BodyApp").filter "musclegroup", ->
	( exercises, musclegroup ) ->
		if musclegroup?.id isnt 0
			filtered = _.filter exercises, ( e ) -> 
				return _.contains( _.pluck( e.muscles, 'group' ), musclegroup.id )

			return filtered

		return exercises
