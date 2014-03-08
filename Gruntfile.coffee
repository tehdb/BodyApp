"use strict"

module.exports = (grunt) ->
	require('load-grunt-tasks')(grunt)	# Load grunt tasks automatically
	require('time-grunt')(grunt)		# Time how long tasks take

	grunt.initConfig
		watch :
			options :
				livereload : true

			common :
				files :	[
					"client/scripts/**/*.coffee",
					"client/config/**/*.coffee",
					"client/database/**/*.json",
					"client/templates/**/*.jade",
					"client/styles/**/*.sass"
				]
				tasks : ["build"]

			config :
				files : ["client/config/main.coffee"]
				tasks : ["coffee:config"]

			scripts :
				files : ["client/scripts/**/*.coffee", "client/database/**/*.json"]
				tasks : [
					"coffee:dist",
					"includes:database"
				]

			templates :
				files : ["client/templates/**/*.jade"]
				tasks : ["jade:dist"]

			styles :
				files : ["client/styles/**/*.sass"]
				tasks : ["compass:dist"]

		coffee :
			options :
				bare : true
				join : true
				sourceMap : true

			dist :
				files :
					".temp/bodyApp.js" : [
						"client/scripts/app.coffe",
						"client/scripts/**/*.coffee"
					]

			config :
				files :
					"public/js/main.js" : "client/config/main.coffee"

		compass :
			dist :
				options :
					sassDir : "client/styles"
					cssDir : "public/css"

		jade :
			dist :
				files :
					# "public/index.html" : "client/templates/index.jade"
					"public/tpl/home.html" : "client/templates/home.tpl.jade"
					"public/tpl/exercises.html" : "client/templates/exercises.tpl.jade"
					"public/tpl/muscles.html" : "client/templates/muscles_tpl.jade"
					"public/tpl/muscle.html" : "client/templates/muscle.jade"

					"public/tpl/exercise.html" : "client/templates/exercise.tpl.jade"
					"public/tpl/muscle-chosen.tpl.html" : "client/templates/directives/muscle-chosen.tpl.jade"
					"public/tpl/th-modal.tpl.html" : "client/templates/directives/th-modal.tpl.jade"
					"public/tpl/th-number-input.tpl.html" : "client/templates/directives/th-number-input.tpl.jade"
					"public/tpl/dropdown.tpl.html" : "client/templates/directives/dropdown.tpl.jade"
		uglify :
			options :
				# mangle : false
				compress : true
				# beautify : true
			scripts :
				files :
					"public/js/bodyApp.min.js" : "public/js/bodyApp.js"

		includes :
			database :
				options :
					includeRegexp : /['"]{{([^'"]+)}}['"]/
					debug : true
				files :
					"public/js/bodyApp.js" : ".temp/bodyApp.js"

		connect :
			options :
				port : 9000
				livereload : 35729
				hostname : "localhost"

			server :
				options :
					base : "public"

			livereload :
				options :
					open : true
					base : "public"


	grunt.registerTask( "build", ["coffee:dist", "coffee:config", "includes:database", "compass:dist", "jade:dist"])
	grunt.registerTask( "dwatch", ["watch:common"])
	grunt.registerTask( "server", ["connect:server:keepalive", "connect:livereload"])
	grunt.registerTask( "default", [] )
