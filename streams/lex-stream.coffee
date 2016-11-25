_      = require('lodash')
stream = require('stream')
D      = require('./definitions')


class LexStream extends stream.Transform
  constructor: (@xs) ->

    # Local that keeps state
    @state =
      new_file : true  # Flag that say if we just started
      indent   : 0     # Current indent level
      current  : null  # Current token - used if a token is several chars long
      tokens   : []    # The tokens we have parsed
      row      : 1     # Current row file position
      col      : 0     # Current col file position

    super(objectMode: true)

  # Override the _transform function
  _transform: (chunk, enc, next) ->
    data = chunk
      .toString(enc)         # Create string based on encoding
      .replace("\r\n", "\n") # Iron out face differences in data
      .replace("\r", "\n")

    # Do the thing and receive the new state
    @state = _.reduce(data
      , (st, char) ->
        # Check if we just started a tokenize process
        if st.new_file
          st.tokens.push(
            type: D.NEW_FILE
            row: 0
            col: 0
            len: 0)
          # We are now officially in the file
          st.new_file = false

        # Increase the column count
        st.col += 1

        # Check if this is a single char token
        if D.IS_SINGLE_CHAR_TOKEN(char) == true
          if st.current?
            st.current += char
          else
            st.current = char.toString()

        # This was not a single char token
        else
          if st.current?
            # We know now that this is a multichar so
            # we can create and pass on the token.
            st.tokens.push(
              type: D.MULTICHAR
              value: st.current
              row: st.row
              col: st.col - st.current.length
              len: st.current.length)

            st.current = null

          # Retreive the classification of the character
          type = D.SINGLE_CHAR_TOKEN_MAP[char]

          # Now we have all info about the token so we
          # add it to the array of tokens
          st.tokens.push(
            type: type
            value: char
            row: st.row
            col: st.col
            len: 1)

          # We found a new line
          if type.delimit == D.DELIMIT_LINE
            st.col = 0   # Reset the column counter
            st.row += 1  # Increase the row count

        st
      , @state)

    # Reclassified tokens
    tokens = _(@state.tokens)

      # Join white space into a single big space
      .reduce((memo, token) ->
          last = _.last(memo)
          if token.type.delimit == D.DELIMIT_SPACE and
            (last.type.delimit == D.DELIMIT_SPACE or
             last.type.delimit == D.DELIMIT_LINE)
              last.len += token.len
              last.value += token.value
          else
            memo.push(token)
          memo
        , [])

      # Reclassify multichar into keywords
      .map((token) ->
          if token.type == D.MULTICHAR and D.IS_KEYWORD(token.value)
            token.type = D.KEYWORD

          token)

      # Reclassify multichar into numbers
      .map((token) ->
          # Is it an integer?
          if token.type == D.MULTICHAR and D.IS_INTEGER(token.value)
            token.type = D.INTEGER

          # Is it an decimal
          else if token.type == D.MULTICHAR and D.IS_DECIMAL(token.value)
            token.type = D.DECIMAL

          token)

      # Reclassify multichar into strings
      .reduce((memo, token) ->
          last = _.last(memo)

          if (token.type.delimit == D.DELIMIT_LITERAL or
              token.type.delimit == D.DELIMIT_SPACE or
              token.type == last?.type) and
              last.type.delimit == D.DELIMIT_BOTH

             last.value += token.value
             last.len += token.len

             token.type = D.STRING if token.type == last.type

          else
            memo.push(token)

          memo
        , [])


    # Pass our tokens on to the next consumer
    _.map(tokens, (token) =>
      @push(token)
    )
    next()


exports.pipe = (stream) -> stream.pipe(new LexStream())

