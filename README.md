ToDo

- home

- exercises
	- ~~edit / delete exercise~~
	- filter / search exercises
	- refactor muscle chosen

- exercise
	- promo api
	- ~~promo service~~
	- ~~promo route + view~~
	- ~~add~~ / edit set dialog
	- progress diagram

- training days page

- use npm passport for user authentication


Prerequisites

	nodejs, mongodb, sass/compass
	
	global npm packages:
		npm install nodemon -g
		npm install coffee-script -g
		npm install bower -g
		npm install grunt-cli -g



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


