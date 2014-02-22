_ = require("underscore")
async = require("async")
mongoose = require 'mongoose'
Muscle = require('../schemas/muscle.shm').Muscle


#	select all : 		undefined
#	select by id : 		id-[Oid]
#	select by groupt : 	group-[Number]
exports.select = (req, res, next) ->
	action = req.params.action

	# select all
	if not action?
		Muscle.find {}, (err, docs) ->
			next err if err
			res.json docs

	else if /(id|group)-[A-Za-z0-9]+/.test action
		action = action.split("-")
		switch action[0]
			when 'id'
				id = action[1]
				if /^[0-9a-fA-F]{24}$/.test id
					Muscle.findById id, (err, doc ) ->
						next err if err
						res.json doc
				else
					next new Error("Invalid Oid")

			when 'group'
				Muscle.find { group : action[1] }, (err, docs) ->
					next err if err
					res.json docs
			else
				res.json { empty : true }
	else
		res.json { empty : true }


_upsertOne = ( obj, cb ) ->
	Muscle.findOne { '_id' : obj._id }, (err, doc) ->
		if doc?
			delete obj._id
			Muscle.findByIdAndUpdate doc._id, obj, (err, doc ) ->
				throw err if err
				cb( doc )

			# NOT DELETE!!!
			# Muscle.update { _id : id },  obj, {upsert:true, multi:false}, (err) ->
			# 	res.status(500).json({status : 'rejected', message : err }) if err
			# 	res.send obj
		else
			muscle = new Muscle( obj)
			muscle.save (err, doc) ->
				throw err if err
				cb( doc )

exports.upsert = (req, res) ->
	res.format
		json : ->
			rb = req.body

			if _.isArray( rb )
				musclesArr = []
				async.each(
					rb
					, (obj, cb) ->
						_upsertOne obj, (doc) ->
							musclesArr.push( doc )
							cb()
					, (err) ->
						res.status(500).json({status : 'rejected', message : err }) if err
						res.send musclesArr
				)

			else
				_upsertOne rb, (doc) ->
					res.send doc





