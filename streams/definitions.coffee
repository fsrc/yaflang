_ = require('lodash')

exports.DELIMIT_START       = 'starter'
exports.DELIMIT_ENDER       = 'ender'
exports.DELIMIT_BOTH        = 'both'
exports.DELIMIT_PUNCTUATION = 'punctuation'
exports.DELIMIT_SPACE       = 'space'
exports.DELIMIT_LINE        = 'line'
exports.DELIMIT_LITERAL     = 'literal'
exports.DELIMIT_FILE        = 'file'
exports.DELIMIT_STRING      = 'string'
exports.DELIMIT_INTEGER     = 'integer'
exports.DELIMIT_DECIMAL     = 'decimal'
exports.DELIMIT_BODY        = 'fn'

exports.DELIMIT_KEYWORD     = 'keyword'

exports.MULTICHAR    = { name: "multichar",   delimit: exports.DELIMIT_LITERAL }
exports.NEW_LINE     = { name: 'newline',     delimit: exports.DELIMIT_LINE }
exports.WHITE_SPACE  = { name: 'white_space', delimit: exports.DELIMIT_SPACE }
exports.PAREN_START  = { name: '(',           delimit: exports.DELIMIT_START }
exports.PAREN_END    = { name: ')',           delimit: exports.DELIMIT_ENDER }
exports.SQUARE_START = { name: '[',           delimit: exports.DELIMIT_START }
exports.SQUARE_END   = { name: ']',           delimit: exports.DELIMIT_ENDER }
exports.CURLY_START  = { name: '{',           delimit: exports.DELIMIT_START }
exports.CURLY_END    = { name: '}',           delimit: exports.DELIMIT_ENDER }
exports.ARROW_START  = { name: '<',           delimit: exports.DELIMIT_START }
exports.ARROW_END    = { name: '>',           delimit: exports.DELIMIT_ENDER }
exports.COLON        = { name: ':',           delimit: exports.DELIMIT_PUNCTUATION }
exports.DOUBLE_QUOTE = { name: '"',           delimit: exports.DELIMIT_BOTH }
exports.SINGLE_QUOTE = { name: "'",           delimit: exports.DELIMIT_BOTH }
exports.NEW_FILE     = { name: "new_file",    delimit: exports.DELIMIT_FILE }
exports.END_FILE     = { name: "end_file",    delimit: exports.DELIMIT_FILE }

exports.KEYWORD      = { name: "keyword",     delimit: exports.DELIMIT_KEYWORD }
exports.STRING       = { name: "string",      delimit: exports.DELIMIT_STRING }

exports.INTEGER      = { name: "integer",     delimit: exports.DELIMIT_INTEGER }
exports.DECIMAL      = { name: "decimal",     delimit: exports.DELIMIT_DECIMAL }

exports.SINGLE_CHAR_TOKEN_MAP =
  '\n': exports.NEW_LINE
  ' ' : exports.WHITE_SPACE
  '\t': exports.WHITE_SPACE
  '(' : exports.PAREN_START
  ')' : exports.PAREN_END
  '[' : exports.SQUARE_START
  ']' : exports.SQUARE_END
  '{' : exports.CURLY_START
  '}' : exports.CURLY_END
  '<' : exports.ARROW_START
  '>' : exports.ARROW_END
  ':' : exports.COLON
  '"' : exports.DOUBLE_QUOTE
  "'" : exports.SINGLE_QUOTE

exports.KEYWORDS =
  def: { name: "def" }
  int: { name: "int" }
  dec: { name: "dec" }
  str: { name: "str" }
  fun: { name: "fn" }

KEYWORD_KEYS           = _.keys(exports.KEYWORDS)
SINGLE_CHAR_TOKEN_KEYS = _.keys(exports.SINGLE_CHAR_TOKEN_MAP)

exports.IS_SINGLE_CHAR_TOKEN = (value) -> _.indexOf(SINGLE_CHAR_TOKEN_KEYS, value) != -1 ? false : true
exports.IS_KEYWORD = (value) -> _.indexOf(KEYWORD_KEYS, value) != -1 ? false : true
exports.IS_INTEGER = (value) -> /^\d+$/.test(value)
exports.IS_DECIMAL = (value) -> /^\d+\.\d+$/.test(value)

