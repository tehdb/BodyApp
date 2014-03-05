path = require('path')
util = require('util')
http = require('http')

#ошибки для выдачи посетителю
HttpError = (status, message) ->
	Error.apply(this, arguments)
	# Error.captureStackTrace(this, HttpError);
	@status = status
	@message = message || http.STATUS_CODES[status] || "Error"


util.inherits(HttpError, Error)

HttpError.prototype.name = 'HttpError'

exports.HttpError = HttpError
