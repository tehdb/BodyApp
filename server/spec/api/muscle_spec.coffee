_ = require("underscore")
request = require('request')
frisby = require('frisby');
HOST = "http://localhost:9000/api/muscle/"




# 	frisby.create('select all muscles')
# 		.get("#{URL}select")
# 		.expectStatus(200)
# 		.expectHeaderContains('content-type', 'application/json')
# 		.expectJSONTypes("*", {
# 			name : String
# 			group : Number
# 	}).toss()

# xdescribe "select muscle by name", ->
# 	name = "spec test muscle"
# 	nameEncoded = encodeURI( name )

# 	frisby.create('get muscle by name')
# 		.get("#{URL}select/name-#{nameEncoded}")
# 		.expectStatus(200)
# 		.expectHeaderContains('content-type', 'application/json')
# 		.expectJSONTypes({
# 			name : String
# 			group : Number
# 		}).expectJSON({
# 			name : name
# 		}).toss()




describe "muscle api insert, update and remove tests", ->
	it "should insert, update and remove one muscle", ->
		that = @

		that.res = null
		that.status = ""
		that.data = {
			group: 7
			name: 'spec test muscle'
		}


		# insert muscle
		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : that.data
				}
				, (err, res, body) ->
					that.res = body
					that.status = "inserted"


		waitsFor( ->
			return that.status is "inserted"
		, "should insert a muscle", 4000 )

		# update muscle
		runs ->
			expect( that.res.name ).toEqual that.data.name
			expect( that.res.group ).toEqual that.data.group

			that.updatedName = "spec test muscle updated"
			that.res.name = that.updatedName
			request {
						method : 'PUT'
						uri : "#{HOST}upsert"
						json : that.res
					}
					, (err, res, body) ->
						that.res = body
						that.status = "updated"


		waitsFor( ->
			return that.status is "updated"
		, "should update a muscle", 4000)

		# remove muscle
		runs ->
			expect( that.res.name).toEqual that.updatedName

			request {
						method : 'DELETE'
						uri : "#{HOST}remove"
						json : { _id : that.res._id}
					}
					, (err, res, body) ->
						that.res = body
						that.status = "removed"

		waitsFor( ->
			return that.status is "removed"
		, "should remove a muscle", 4000)

		runs ->
			expect( that.res.message ).toBe "success"

	it "should insert and update an array of muscles", (done) ->
		that = @
		that.res = null
		that.status = ""
		that.data = []

		for i in [1..3]
			that.data.push({
				group : 11
				name : "insert test value #{i}"
			})

		# insert muscles
		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : that.data
				}
				, (err, res, body) ->
					that.res = body
					that.status = "inserted"

		waitsFor( ->
			return that.status is "inserted"
		, "should insert an array of muscles", 4000 )

		# update muscles
		runs ->
			expect( _.isArray( that.res) ).toBeTruthy()
			expect( that.res.length ).toBe 3

			_.each that.res, (elm, idx) ->
				that.res[idx].name += " updated"

			request {
						method : 'PUT'
						uri : "#{HOST}upsert"
						json : that.res
					}
					, (err, res, body) ->
						that.res = body
						that.status = "updated"

		waitsFor( ->
			return that.status is "updated"
		, "should update an array of muscles", 4000 )

		runs ->
			expect( _.isArray( that.res) ).toBeTruthy()
			expect( that.res.length ).toBe 3
			expect( that.res[0].name ).toContain "updated"
			expect( that.res[1].name ).toContain "updated"
			expect( that.res[2].name ).toContain "updated"

			# remove added muscles
			removedCount = 0
			_.each that.res, (elm, idx) ->
				request {
							method : 'DELETE'
							uri : "#{HOST}remove"
							json : { _id : elm._id}
						}
						, (err, res, body) ->
							done() if removedCount++ is idx


describe "muscle api select tests", ->
	that = @
	that.tempData = null

	before (done) ->
		data = []
		for i in [1..3]
			that.data.push({
				group : 11
				name : "select test value #{i}"
			})

		request(
			{
				method : 'PUT'
				uri : "#{HOST}upsert"
				json : data
			}, (err, res, body) ->
				that.tempData = JSON.parse( body )
				done()
		)

	after (done) ->
		removedCount = 0
		_.each that.tempData, (elm, idx) ->
			request {
						method : 'DELETE'
						uri : "#{HOST}remove"
						json : { _id : elm._id}
					}
					, (err, res, body) ->
						done() if removedCount++ is idx


	it "should select all muscles", (done) ->
		that = @
		that.res = null
		that.status = null
		# that.data = []
		# for i in [1..3]
		# 	that.data.push({
		# 		group : 11
		# 		name : "select test value #{i}"
		# 	})

		# request(
		# 	{
		# 		method : 'PUT'
		# 		uri : "#{HOST}upsert"
		# 		json : that.data
		# 	}, (err, res, body) ->
		# 		that.status = "inserted"
		# )

		# waitsFor( ->
		# 	return that.status is "inserted"
		# , "should insert a muscle", 4000 )

		# runs ->
		frisby.create('select all muscles')
			.get("#{HOST}select")
			.expectStatus(200)
			.expectHeaderContains('content-type', 'application/json')
			.expectJSONTypes("*", {
				name : String
				group : Number
			}).afterJSON( (data) ->
				# remove added muscles

			).toss()
			# request(
			# 	{
			# 		method : 'GET'
			# 		uri : "#{HOST}select"
			# 	}, (err, res, body) ->
			# 		expect( err ).toBe null
			# 		expect( res.statusCode ).toEqual 200

			# 		b = JSON.parse( body )
			# 		expect( b.length ).toEqual 3

			# )


	# it "should remove a muscle", (done) ->
	# 	that.data = {
	# 		_id : "5314622fc4ba149c27ffdbe8"
	# 	}

	# 	request(
	# 		{
	# 			method : 'DELETE'
	# 			uri : "#{HOST}remove"
	# 			json : data
	# 		}, (err, res, body) ->
	# 			expect( err ).toBe null
	# 			expect( res.statusCode ).toEqual 200
	# 			expect( body.message).toEqual "success"
	# 			done()
	# 	)





# describe "muscle api tests", ->
# 	host = "http://localhost:9000/api/muscle/"

# 	describe "insert, update and remove muscles", ->

# 		_insertMuscle = (muscle, cb) ->
#  			request(
# 				{
# 					method : 'PUT'
# 					uri : "#{HOST}upsert"
# 					json : data
# 				}, (err, res, body) ->
# 					# expect( err ).toBe null
# 					# expect( res.statusCode ).toEqual 200
# 					console.log body
# 					newMuscle = JSON.parse( body )
# 			)
# 		_updateMuscle = (muscle, cb) ->

# 		_remuveMuscle = (muscle, cb) ->


		# it "should insert muscle", (done) ->
		# 	data = {
		# 		group: 11
		# 		name: 'spec test muscle 123'
		# 	}

		# 	nameEncoded = encodeURI(data.name)
		# 	newMuscle = null

		# 	waitsFor( ->
		# 		request(
		# 			{
		# 				method : 'PUT'
		# 				uri : "#{HOST}upsert"
		# 				json : data
		# 			}, (err, res, body) ->
		# 				# expect( err ).toBe null
		# 				# expect( res.statusCode ).toEqual 200
		# 				console.log body
		# 				newMuscle = JSON.parse( body )
		# 		)
		# 	, "should insert new muscle", 5000 )

		# 	runs ->
		# 		expect(newMuscle.name).toEqual data.name
		# 		expect(newMuscle.group).toEqual data.group




xdescribe "muscle api tests", ->
	host = "http://localhost:9000/api/muscle/"

	xdescribe "insert, update and remove muscles", ->
		it "should insert muscle", (done) ->
			data = {
				group: 7
				name: 'spec test muscle'
			}

			nameEncoded = encodeURI(data.name)
			newMuscle = null

			waitsFor( ->
				request(
					{
						method : 'PUT'
						uri : "#{URL}upsert"
						json : data
					}, (err, res, body) ->
						# expect( err ).toBe null
						# expect( res.statusCode ).toEqual 200
						newMuscle = JSON.parse( body )
				)
			, "should insert new muscle", 5000 )

			runs ->
				expect(b.name).toEqual data.name
				expect(b.group).toEqual data.group

			request(
				{
					method : 'GET'
					uri : "#{host}select/name-#{nameEncoded}"
				}, (err, res, body) ->
					b = JSON.parse( body )
					request(
						{
							method : 'DELETE'
							uri : "#{host}remove"
						}, (err, res, body) ->


					)

			)

			request(
				{
					method : 'PUT'
					uri : "#{host}upsert"
					json : data
				}, (err, res, body) ->
					expect( err ).toBe null
					expect( res.statusCode ).toEqual 200
					console.log body
					b = JSON.parse( body )
					expect(b.name).toEqual data.name
					expect(b.group).toEqual data.group
					done()
			)

	describe "get muscles", ->
		it "should get all muscles", (done) ->
			request(
				{
					method : 'GET'
					uri : "#{host}select"
				}, (err, res, body) ->
					expect( err ).toBe null
					expect( res.statusCode ).toEqual 200
					b = JSON.parse( body )
					done()
			)


		it "should not get muscle if oid is invalid", (done) ->
			request(
				{
					method : 'GET'
					uri : "#{host}select/id-XXX"
				}, (err, res, body) ->
					expect( err ).toBe null
					expect( res.statusCode ).toEqual 500
					done()
			)


		it "should get muscle by name", (done) ->
			name = "spec test muscle 1"
			nameEncoded = encodeURI( name )
			request(
				{
					method : 'GET'
					uri : "#{host}select/name-#{nameEncoded}"
				}, (err, res, body) ->
					expect( err ).toBe null
					expect( res.statusCode ).toEqual 200
					b = JSON.parse( body )
					expect( b.name ).toBe name
					done()
			)

