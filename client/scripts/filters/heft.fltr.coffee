angular.module("BodyApp").filter "heft", ->
	( val, type ) ->
		return "#{val} kg"
