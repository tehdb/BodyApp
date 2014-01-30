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
					"app/templates/**/*.jade",
					"app/styles/**/*.sass"
				]
				tasks : ["build"]

			scripts :
				files : ["app/scripts/**/*.coffee"]
				tasks : ["coffee:dist"]

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
					"public/js/bodyApp.js" : [
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
	grunt.registerTask( "build", ["coffee:dist", "compass:dist", "jade:dist"])
	grunt.registerTask( "dwatch", ["watch:common"])
	grunt.registerTask( "server", ["connect:server:keepalive", "connect:livereload"])

	grunt.registerTask( "default", [] )
