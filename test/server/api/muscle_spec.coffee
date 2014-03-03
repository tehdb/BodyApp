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

describe "muscle api selects", ->
	that = @
	that.tempMuscleArray = []

	# insert temp data
	before (done) ->
		for i in [1..3]
			that.tempMuscleArray.push({
				group : 11
				name : "select test value #{i}"
			})

		request(
			{
				method : 'PUT'
				uri : "#{HOST}upsert"
				json : that.tempMuscleArray
			}, (err, res, body) ->
				that.tempMuscleArray = body
				done()
		)

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
						done() if ++removeCount is removeLength



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
					expect( res.statusCode ).to.equal 500
					done()


	it "should return null if muscle name can't be found", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/name-XXX"
				}
				, (err, res, body) ->
					expect( res.statusCode ).to.equal 500
					done()


	it "should return error by invalid action", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/invalid-action"
				}
				, (err, res, body) ->
					# console.log body
					expect( res.statusCode ).to.equal 500
					done()




