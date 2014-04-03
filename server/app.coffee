express = require("express")

# muscles :	require( "./server/routes/muscles.rt" )
# sets :		require( "./server/routes/sets.rt" )
#exercise : 	require( "./server/routes/exercise.rt" )
# promotion : require( "./server/routes/promotion.rt" )
path = require( "path" )
db = require( "./db" )
# io = require('socket.io').listen(9999)

app = express()

app
	.set( "port", 9000 )
	.set( "views", __dirname + "/views" )
	.set( "view engine", "jade" )
	.use( express.logger("dev") )
	.use( express.bodyParser() )
	.use( express.methodOverride() )
	.use( app.router )
	.use( express.static(path.join(__dirname, "/../public")) )
	#.use( express.errorHandler({dumpExceptions: true, showStack: false}) )

require('./routes/common_rt')(app)

app.listen( app.get("port") )
