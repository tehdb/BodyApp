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

		compass :
			dist :
				options :
					sassDir : "client/styles"
					cssDir : "public/css"

		jade :
			dist :
				options :
					client: false
					pretty: false
				files : [{
					cwd : "client/templates"
					src : "**/*.jade"
					# dest : "public/tpl"
					dest : ".temp/templates"
					expand : true
					ext: ".html"
				}]

		# replace text in files using strings, regexs or functions
		replace :
			# escape single quotes in tempaltes for inclusion
			escape : 
				src: ['.temp/templates/**/*.html']
				overwrite: true
				replacements: [{
					from: 	/'/g
					to:		'\\\''
				}]


		includes :
			templates :
				options :
					includeRegexp : /['"]{{([^'"]+)}}['"]/
					# includeRegexp : /{{(.+)}}/
					debug : false
				files :
					"public/js/bodyApp.js" : ".temp/bodyApp.js"

		# fileregexrename :
		# 	dist :
		# 		options :
		# 			replacements : [{
		# 				pattern : "_tpl"
		# 				replacement : ""

		# 			}]
		# 		files : [{
		# 			cwd : "public/tpl"
		# 			src : "**/*.html"
		# 			dest : "public/tpl"
		# 			expand : true
		# 			ext: ".html"
		# 		}]


		uglify :
			options :
				# mangle : false
				compress : true
				# beautify : true
			scripts :
				files :
					"public/js/bodyApp.min.js" : "public/js/bodyApp.js"


		copy :
			utils :
				files :
					"public/js/utils.js" 	: "client/extra/utils.js"
			
			templates : 
				files : [{
					expand: true
					cwd: '.temp/templates/'
					src: ['**'],
					# src : ".temp/templates/*"
					dest : "public/tpl/"
				}]

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


	grunt.registerTask( "build", [
		"coffee:dist",
		"jade:dist",
		"replace:escape",
		"includes:templates",
		#"copy:templates",		# TODO: copy only 
		"compass:dist"
		# "fileregexrename:dist"
	])
	grunt.registerTask( "dwatch", ["watch:common"])
	grunt.registerTask( "server", ["connect:server:keepalive", "connect:livereload"])
	grunt.registerTask( "default", [] )
