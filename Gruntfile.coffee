"use strict"

module.exports = (grunt) ->
	require('load-grunt-tasks')(grunt)	# Load grunt tasks automatically
	require('time-grunt')(grunt) 		# Time how long tasks take
	grunt.initConfig
		watch :
			options :
				livereload : true

			common :
				files :	[
					"app/scripts/**/*.coffee",
					"app/database/**/*.json",
					"app/templates/**/*.jade",
					"app/styles/**/*.sass"
				]
				tasks : ["build"]

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
					# "public/js/bodyApp.js" : [
					".temp/bodyApp.js" : [
						"app/scripts/app.coffe",
						"app/scripts/**/*.coffee"
					]
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
				#beautify : true
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



	# grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.registerTask( "build", ["coffee:dist", "includes:database", "compass:dist", "jade:dist"])
	grunt.registerTask( "dwatch", ["watch:common"])
	grunt.registerTask( "server", ["connect:server:keepalive", "connect:livereload"])

	grunt.registerTask( "default", [] )
