express = require("express")
routes = {
	common :	require( "./server/routes/common.rt" )
	muscle :	require( "./server/routes/muscle.rt" )
}
# exercises :	require( "./server/routes/exercises.rt" )
# muscles :	require( "./server/routes/muscles.rt" )
# sets :		require( "./server/routes/sets.rt" )
#exercise : 	require( "./server/routes/exercise.rt" )
# promotion : require( "./server/routes/promotion.rt" )
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

	# .get(	"/api/exercises/list",			routes.exercises.list(db) )
	# .get(	"/api/exercises/get/:id",		routes.exercises.find(db) )
	# .post(	"/api/exercises/upsert",		routes.exercises.upsert(db) )
	# .post(	"/api/exercises/delete/:id",	routes.exercises.delete(db) )

	# .get(	"/api/muscles/list",			routes.muscles.getMuscles(db) )
	# .post(	"/api/muscles/add",				routes.muscles.addMuscle(db) )
	# .get(	"/api/muscles/get/:ids",		routes.muscles.getMusclesByIds(db) )





	.get(	"/api/muscle/select/:id?",		routes.muscle.select )
	.post(	"/api/muscle/upsert",					routes.muscle.upsert )

	# .get(	"/api/exercise/select/:id?/:action?",	routes.exercise.select() )
	# .post(	"/api/exercise/upsert",					routes.exercise.upsert() )

	# .get( 	"/api/promotion/select/:id/:action?",	routes.promotion.select(db) )
	# .post(	"/api/promotion/upsert",				routes.promotion.upsert(db) )

	.listen( app.get("port") )
