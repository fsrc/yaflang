_ = require('lodash')
D = require('./definitions')

# Start or continue on a multichar
multichar_token = (st, char) ->
  # Is there an ongoing token?
  if st.current?
    st.current += char

  # If not, convert the char to string
  else
    st.current = char.toString()

  st

# End a multichar token
end_multichar_token = (st, char) ->
  st.tokens.push(
    type:  D.MULTICHAR                 # We know now that this
    value: st.current                  # is a multichar so we
    row:   st.row                      # can create and pass on
    col:   st.col - st.current.length  # the token.
    len:   st.current.length)          #

  st.current = null
  st

# Creates a token from a valid single char
single_char_token = (st, char) ->
  # Retreive the classification of the character
  type = D.SINGLE_CHAR_TOKEN_MAP[char]

  st.tokens.push(   #
    type:  type     # Now we have all info
    value: char     # about the token so
    row:   st.row   # we add it to the
    col:   st.col   # array of tokens
    len:   1)       #

  st

exports.classify = (st, char) ->

  # Increase the column count
  st.col += 1

  # Check if this is a multichar token
  if not D.IS_SINGLE_CHAR_TOKEN(char)
    st = multichar_token(st, char)

  # This was a single char token
  else
    
    # If we have a multichar going on, end it.
    st = end_multichar_token(st, char) if st.current?

    # Handle the single char
    st = single_char_token(st, char)

    # We found a new line
    if D.SINGLE_CHAR_TOKEN_MAP[char].delimit == D.DELIMIT_LINE
      st.col = 0   # Reset the column counter
      st.row += 1  # Increase the row count

  st



exports.join_white_space = (memo, token) ->
  # Fetch the last processed token
  last = _.last(memo) 

  if token.type.delimit == D.DELIMIT_SPACE and # If current token matches
    (last.type.delimit == D.DELIMIT_SPACE or   # space or new line then we
     last.type.delimit == D.DELIMIT_LINE)      # adopt this token into the last
      last.len += token.len
      last.value += token.value
  else
    memo.push(token)

  memo

exports.into_keywords = (token) ->
  if token.type == D.MULTICHAR and D.IS_KEYWORD(token.value)
    token.type = D.KEYWORD

  token

exports.into_numbers = (token) ->
  # Is it an integer?
  if token.type == D.MULTICHAR and D.IS_INTEGER(token.value)
    token.type = D.INTEGER

  # Is it an decimal
  else if token.type == D.MULTICHAR and D.IS_DECIMAL(token.value)
    token.type = D.DECIMAL

  token

exports.into_strings = (memo, token) ->
  last = _.last(memo)

  # Start string
  if last?.type.delimit == D.DELIMIT_BOTH
    last.value += token.value
    last.len += token.len

    # End string
    if token.type == last.type
       last.type = D.STRING

  else
    memo.push(token)

  memo

exports.into_booleans = (token) ->
  # Is it an integer?
  if token.type == D.KEYWORD and D.IS_BOOLEAN(token.value)
    console.log token
    token.type = D.BOOLEAN

  token
