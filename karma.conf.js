// Karma configuration
// Generated on Tue Jan 21 2014 15:22:56 GMT+0100 (CET)

module.exports = function(config) {
	config.set({
		basePath: "",
		frameworks: ["jasmine"],
		files: [
			"public/vendor/jquery/jquery.js",
			"public/vendor/angular/angular.js",
			"public/vendor/angular-mocks/angular-mocks.js",
			"public/vendor/angular-route/angular-route.js",
			//"public/vendor/angular-bindonce/bindonce.js",
			".temp/bodyApp.js",
			"test/unit/**/*.spec.coffee"
		],
		exclude: [],
		reporters: ["progress"],
		port: 9876,
		colors: true,
		logLevel: config.LOG_INFO,
		autoWatch: true,
		browsers: ["Chrome"],
		captureTimeout: 60000,
		singleRun: false
	});
};
