_      = require('lodash')
stream = require('stream')
D      = require('./definitions')

class ParseStream extends stream.Transform
  constructor: (@xs) ->
    @state =
      ast: []

    super(objectMode: true)

  _transform: (chunk, enc, next) ->

    @push(chunk)
    next()


exports.pipe = (stream) -> stream.pipe(new ParseStream())

