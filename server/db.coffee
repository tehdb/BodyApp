mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/bodyapp'
module.exports = mongoose.connection