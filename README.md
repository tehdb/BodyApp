ToDo
 - ~~edit/delete exercise~~
 - refactor muscle chosen
 - filter/search exercises
 - exercises page
 	- set list
 	- add/edit set dialog
 	- store sets
 	- progress diagram
	 - zoom exercise image
 - training days page
 - use npm passport for user authentication


Get started

	npm install		# get required node.js modules
	bower install	# get required vendor packages

	mongod 			# start monogdb
	npm start		# start server

	grunt dwatch 	# watch for changes and compile client source




set/get enviroment variables

	NODE_ENV=production node app.js
	app.configure('production', function(){})


run tests
	mocha -w  --compilers coffee:coffee-script test/server/api/muscle_spec.coffee


