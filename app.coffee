express = require("express")
routes = require("./server/routes")
http = require("http")
path = require("path")
db = require("./server/db")
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
	.get( "/", routes.index() )

	.options("/api/exercises/list", routes.options )
	.get( "/api/exercises/list", routes.getExercises(db) )
	.post( "/api/exercises/list", routes.getExercises(db) )

	.options("/api/exercises/add", routes.options )
	.put( "/api/exercises/add", routes.addExercise(db) )
	.post( "/api/exercises/add", routes.addExercise(db) )

	.options("/api/exercises/get/:id", routes.options )
	.get( "/api/exercises/get/:id", routes.getExercise(db) )
	.post( "/api/exercises/get/:id", routes.getExercise(db) )

	.options("/api/muscles/list", routes.options )
	.get( "/api/muscles/list", routes.getMuscles(db) )
	#.post( "/api/muscles/list", routes.getMuscles(db) )

	.options("/api/muscles/add", routes.options )
	.put( "/api/muscles/add", routes.addMuscle(db) )
	.post( "/api/muscles/add", routes.addMuscle(db) )



http.createServer(app).listen( app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")
)
