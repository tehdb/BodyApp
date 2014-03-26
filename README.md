ToDo

- home


- exercises
	- ~~edit / delete exercise~~
	- ~~filter / search exercises~~
	- use chosen instead of muscle-chosen


- exercise
	- promo api
	- ~~promo service~~
	- ~~promo route + view~~
	- ~~add~~ / edit set dialog
	- progress diagram


- modal directive
	- ~~improve full screen behavior ( scroll, position )~~
	- ~~background on animation~~
	- fixed position( ~~top, center, bottom~~, top-left, top-right, bottom-left, bottom-right
	- dynamic position to event target



- chosen directive
	- ~~improve full screen behavior~
	- improve dropdown behavior


- number-input directive
	- remove prefix


- schedules page
	- upsert / delete schedules


- training days page


- use npm passport for user authentication


Prerequisites

	nodejs/npm, mongodb, compass/sass

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


