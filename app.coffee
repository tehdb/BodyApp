express = require("express")
routes = {
	common :	require( "./server/routes/common.rt" )
	exercises :	require( "./server/routes/exercises.rt" )
	muscles :	require( "./server/routes/muscles.rt" )
}
path = require( "path" )
db = require( "./server/db" )
# io = require('socket.io').listen(9999)

app = express()

app
	.set( "port", 9000 )
	.set( "views", __dirname + "/server/views" )
	.set( "view engine", "jade" )
	.use( express.logger("dev") )
	.use( express.bodyParser() )
	.use( express.methodOverride() )
	.use( app.router )
	.use( express.static(path.join(__dirname, "public")) )
	.use( express.errorHandler({dumpExceptions: true, showStack: true}) )
	
	# routes
	.options(/\/api\/\w*\/(add|get)/,		routes.common.allowOrigin )

	.get(	"/",							routes.common.index() )

	.get(	"/api/exercises/list",			routes.exercises.list(db) )
	.get(	"/api/exercises/get/:id",		routes.exercises.find(db) )
	.post(	"/api/exercises/upsert",		routes.exercises.upsert(db) )
	.post(	"/api/exercises/delete/:id",	routes.exercises.delete(db) )
	
	.get(	"/api/muscles/list",			routes.muscles.getMuscles(db) )
	.post(	"/api/muscles/add",				routes.muscles.addMuscle(db) )
	.get(	"/api/muscles/get/:ids",		routes.muscles.getMusclesByIds(db) )

	.listen( app.get("port") )