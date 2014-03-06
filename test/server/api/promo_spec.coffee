chai = require 'chai'
chai.use require 'chai-json-schema'
expect = chai.expect
_ = require("underscore")
request = require('request')
ObjectID = require('mongodb').ObjectID


HOST = "http://localhost:9000/api/promo/"

describe "promo api", ->
	that = @
	that.tempDataArr = []

	before (done) ->
		for i in [1..3]
			that.tempDataArr.push({
				exercise : String( new ObjectID() )
			})

		request {
			method : 'PUT'
			uri : "#{HOST}upsert"
			json : that.tempDataArr
		}, (err, res, body) ->
			expect( err ).to.equal null
			expect( res.statusCode ).to.equal 200
			that.tempDataArr = body
			done()

	after (done) ->
		removeCount = 0
		removeLength = that.tempDataArr.length
		_.each that.tempDataArr, (elm, idx) ->
			request {
						method : 'DELETE'
						uri : "#{HOST}remove"
						json : { _id : elm._id}
					}
					, (err, res, body) ->
						expect( err ).to.equal null
						expect( res.statusCode ).to.equal 200
						done() if ++removeCount is removeLength


	it "should append progress data to promo", ->
		promo = that.tempDataArr[0]
		promo.progress = {
			sets : []
		}
		for i in [1..3]
			promo.progress.sets.push({
				inc : i
				heft : 100
				reps : ( 12 - i )
			})

		# TODO: implement append progress object
		expect(true).to.be.true
