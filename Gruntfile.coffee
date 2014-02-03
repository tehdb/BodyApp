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
					"app/scripts/**/*.coffee",
					"app/config/**/*.coffee",
					"app/database/**/*.json",
					"app/templates/**/*.jade",
					"app/styles/**/*.sass"
				]
				tasks : ["build"]

			config : 
				files : ["app/config/main.coffee"]
				tasks : ["coffee:config"]

			scripts :
				files : ["app/scripts/**/*.coffee", "app/database/**/*.json"]
				tasks : [
					"coffee:dist",
					"includes:database"
				]

			templates :
				files : ["app/templates/**/*.jade"]
				tasks : ["jade:dist"]

			styles :
				files : ["app/styles/**/*.sass"]
				tasks : ["compass:dist"]

		coffee :
			options :
				bare : true
				join : true
				sourceMap : true

			dist :
				files :
					".temp/bodyApp.js" : [
						"app/scripts/app.coffe",
						"app/scripts/**/*.coffee"
					]

			config :
				files : 
					"public/js/main.js" : "app/config/main.coffee"

		compass :
			dist :
				options :
					sassDir : "app/styles"
					cssDir : "public/css"

		jade :
			dist :
				files :
					"public/index.html" : "app/templates/index.jade"
					"public/tpl/home.html" : "app/templates/home.tpl.jade"
					"public/tpl/exercises.html" : "app/templates/exercises.tpl.jade"

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
