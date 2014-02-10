describe "main controllers tests", ->
	beforeEach( module("BodyApp") )

	mainCtrl = null
	$s = null

	beforeEach inject( ($controller, $rootScope )->
		$s = $rootScope.$new()
		mainCtrl = $controller("MainCtrl", {
			$scope : $s
		})
	)

	it 'should safe apply method exist', ->
		expect( typeof $s.safeApply ).toBe 'function'

