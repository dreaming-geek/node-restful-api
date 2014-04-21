
mongoose = require 'mongoose'
Schema = mongoose.Schema

BearSchema = new Schema
    name: String

module.exports = mongoose.model 'Bear', BearSchema