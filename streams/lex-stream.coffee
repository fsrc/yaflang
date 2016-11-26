_      = require('lodash')
stream = require('stream')

D               = require('./definitions')
classify_tokens = require('./classify-tokens')



class LexStream extends stream.Transform
  constructor: (@xs) ->

    # Local that keeps state
    @state =
      current  : null  # Current token - used if a token is several chars long
      indent   : 0     # Current indent level
      row      : 1     # Current row file position
      col      : 0     # Current col file position
      tokens   : [     # The tokens we have parsed
        type: D.NEW_FILE
        row: 0         # Initialize with the new file token
        col: 0
        len: 0
      ] 

    super(objectMode: true)

  # Override the _transform function
  _transform: (chunk, enc, next) ->
    data = chunk
      .toString(enc)         # Create string based on encoding
      .replace("\r\n", "\n") # Iron out face differences in data
      .replace("\r", "\n")

    # Do the thing and receive the new state
    @state = _.reduce(data, classify_tokens.classify, @state)

    # Reclassified tokens
    tokens = _(@state.tokens)
      .reduce(classify_tokens.join_white_space, [])
      .reduce(classify_tokens.into_strings, [])
      .map(   classify_tokens.into_keywords)
      .map(   classify_tokens.into_numbers)

    # Pass our tokens on to the next consumer
    _.map(tokens, (token) => @push(token))

    next()


exports.pipe = (stream) -> stream.pipe(new LexStream())

