chai = require 'chai'
chai.use require 'chai-json-schema'
expect = chai.expect

_ = require("underscore")
request = require('request')

HOST = "http://localhost:9000/api/muscle/"
MUSCLE_ARRAY_SCHEMA = {
	"type" : "array"
	"uniqueItems" : true
	"items" : {
		"type" : "object"
		"properties" : {
			"name" : {
				"type" : "string"
			}
			, "group" : {
				"type" : "number"
			}
		}
	}
}


describe "muscle api", ->
	that = @
	that.tempMuscleArray = []

	# insert temp data
	before (done) ->
		for i in [1..3]
			that.tempMuscleArray.push({
				group : 11
				name : "select test value #{i}"
			})

		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : that.tempMuscleArray
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( body ).to.be.jsonSchema( MUSCLE_ARRAY_SCHEMA )

					that.tempMuscleArray = body
					done()

	# remove temp data
	after (done) ->
		removeCount = 0
		removeLength = that.tempMuscleArray.length
		_.each that.tempMuscleArray, (elm, idx) ->
			request {
						method : 'DELETE'
						uri : "#{HOST}remove"
						json : { _id : elm._id}
					}
					, (err, res, body) ->
						expect( err ).to.equal null
						expect( res.statusCode ).to.equal 200
						done() if ++removeCount is removeLength


	it "should update one muscle", (done) ->
		muscle = that.tempMuscleArray[0]
		muscle.name += " updated"
		muscle.group = 7

		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : muscle
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( body._id ).to.equal muscle._id
					expect( body.name ).to.equal muscle.name
					expect( body.group ).to.equal muscle.group
					done()


	it "should update array of muscles", (done) ->
		muscles = that.tempMuscleArray.slice(1,3)
		muscleIds = _.pluck( that.tempMuscleArray, '_id' )
		_.each muscles, (elm, idx) ->
			muscles[idx].name += " updated"

		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : muscles
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( body ).to.be.jsonSchema( MUSCLE_ARRAY_SCHEMA )

					# TODO: возможно более тщательней тестировать, проверить группу или сортировку?
					_.each( body, (elm, idx) ->
						expect( elm.name ).to.have.string(" updated")
						expect( muscleIds ).to.contain( elm._id )
					)
					done()

	it "should select all muscles", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( _.isArray(data) ).to.be.true
					expect( data ).to.have.length.of.at.least 3
					expect( data ).to.be.jsonSchema( MUSCLE_ARRAY_SCHEMA )
					done()


	it "should select muscle by oid", (done) ->
		muscle = that.tempMuscleArray[0]
		oid = muscle._id
		request {
					method : 'GET'
					uri : "#{HOST}select/id-#{oid}"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( data.name ).to.equal muscle.name
					expect( data.group ).to.equal muscle.group
					done()


	it "should select muscle by name", (done) ->
		muscle = that.tempMuscleArray[0]
		nameEncoded = encodeURI(muscle.name)

		request {
					method : 'GET'
					uri : "#{HOST}select/name-#{nameEncoded}"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( data.name ).to.equal muscle.name
					expect( data.group ).to.equal muscle.group
					done()


	it "should return error by invalid oid", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/id-XXX"
				}
				, (err, res, body) ->
					expect( res.statusCode ).to.equal 404
					done()


	it "should return null if muscle name can't be found", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/name-XXX"
				}
				, (err, res, body) ->
					expect( res.statusCode ).to.equal 404
					done()


	it "should return error by invalid action", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/invalid-action"
				}
				, (err, res, body) ->
					expect( res.statusCode ).to.equal 404
					done()




