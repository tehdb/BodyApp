chai = require 'chai'
chai.use require 'chai-json-schema'
expect = chai.expect
_ = require("underscore")
request = require('request')
ObjectID = require('mongodb').ObjectID


HOST = "http://localhost:9000/api/exercise/"

EXERCICSE_ARRAY_SCHEMA = {
	"type" : "array"
	"uniqueItems" : true
	"items" : {
		"type" : "object"
		"properties" : {
			"title" : {
				"type" : "string"
			}
		, "descr" : {
				"type" : "string"
			}
		, "muscles" : {
				"type" : "array"
				"items" : {
					"type" : "string"
				}
			}
		}
	}
}

describe "exercise api", ->
	that = @
	that.tempExerciseArray = []

	# insert temp data
	before (done) ->
		for exerciseCount in [1..3]
			muscles = []
			# muscles.push(new ObjectID) for muscleCount in [1..3]
			muscles.push( new ObjectID() ) for muscleCount in [1..3]

			that.tempExerciseArray.push({
				title : "test title #{exerciseCount}"
				descr : "test descr #{exerciseCount}"
				muscles : muscles
			})


		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : that.tempExerciseArray
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( body ).to.be.jsonSchema( EXERCICSE_ARRAY_SCHEMA )
					that.tempExerciseArray = body
					done()

	# remove temp data
	after (done) ->
		removeCount = 0
		removeLength = that.tempExerciseArray.length
		_.each that.tempExerciseArray, (elm, idx) ->
			request {
						method : 'DELETE'
						uri : "#{HOST}remove"
						json : { _id : elm._id}
					}
					, (err, res, body) ->
						expect( err ).to.equal null
						expect( res.statusCode ).to.equal 200
						done() if ++removeCount is removeLength


	it "should update one exercise", (done) ->
		exercise = that.tempExerciseArray[0]
		exercise.title += " updated"
		exercise.descr += " updated"
		exercise.muscles = []
		exercise.muscles.push( String(new ObjectID()) ) for i in [1..3]

		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : exercise
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200

					expect( body._id ).to.equal exercise._id
					expect( body.title ).to.equal exercise.title
					expect( body.descr ).to.equal exercise.descr
					expect( body.muscles ).to.have.members exercise.muscles
					done()

	it "should update array of exercises", (done) ->
		exercises = that.tempExerciseArray.slice(1,3)
		exercisesIds = _.pluck( that.tempExerciseArray, '_id' )
		_.each exercises, (elm, idx) ->
			exercises[idx].title += " updated"
			exercises[idx].descr += " updated"

		request {
					method : 'PUT'
					uri : "#{HOST}upsert"
					json : exercises
				}, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( body ).to.be.jsonSchema( EXERCICSE_ARRAY_SCHEMA )

					# TODO: возможно более тщательней тестировать, проверить группу или сортировку?
					_.each( body, (elm, idx) ->
						expect( elm.title ).to.have.string(" updated")
						expect( elm.descr ).to.have.string(" updated")
						expect( exercisesIds ).to.contain( elm._id )
					)
					done()


	it "should select all exercises", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( data ).to.have.length.of.at.least 3
					expect( data ).to.be.jsonSchema( EXERCICSE_ARRAY_SCHEMA )
					done()

	it "should select exercise by oid", (done) ->
		exercise = that.tempExerciseArray[0]

		request {
					method : 'GET'
					uri : "#{HOST}select/id-#{exercise._id}"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( data.title ).to.equal exercise.title
					expect( data.descr ).to.equal exercise.descr
					expect( data.muscles ).to.have.members exercise.muscles
					done()

	it "should return error by invalid oid", (done) ->
		request {
					method : 'GET'
					uri : "#{HOST}select/id-XXX"
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

	it "should return exercise by title", (done) ->
		exercise = that.tempExerciseArray[0]
		request {
					method : 'GET'
					uri : "#{HOST}select/title-#{exercise.title}"
				}
				, (err, res, body) ->
					data = JSON.parse( body )
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					expect( data.title ).to.equal exercise.title
					expect( data.descr ).to.equal exercise.descr
					expect( data.muscles ).to.have.members exercise.muscles
					done()

	it "should return exercise by muscle", (done) ->
		exercise = that.tempExerciseArray[0]
		request {
					method : 'GET'
					uri : "#{HOST}select/muscle-#{exercise.muscles[0]}"
				}
				, (err, res, body) ->
					expect( err ).to.equal null
					expect( res.statusCode ).to.equal 200
					data = JSON.parse( body )
					exercisesIds = _.pluck( data, '_id' )
					expect( exercisesIds ).to.have.members [exercise._id]
					done()




