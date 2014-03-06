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
        "type" : "number"
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
    for i in [1..3]
      muscles = []
      muscles.push(new ObjectID) for i in [1..3]

      that.tempExerciseArray.push({
        title : "test title #{i}"
        descr : "test descr #{i}"
        muscles : muscles
      })

      request {
          method : 'PUT'
          uri : "#{HOST}upsert"
          json : that.tempMuscleArray
        }, (err, res, body) ->
          expect( err ).to.equal null
          expect( res.statusCode ).to.equal 200
          expect( body ).to.be.jsonSchema( EXERCICSE_ARRAY_SCHEMA )

          that.tempExerciseArray = body
          done()

  # remove temp data
#  after (done) ->
#    removeCount = 0
#    removeLength = that.tempExerciseArray.length
#    _.each that.tempExerciseArray, (elm, idx) ->
#      request {
#          method : 'DELETE'
#          uri : "#{HOST}remove"
#          json : { _id : elm._id}
#        }
#      , (err, res, body) ->
#        expect( err ).to.equal null
#        expect( res.statusCode ).to.equal 200
#        done() if ++removeCount is removeLength



  it "should work", ->
    expect(true).to.be.true