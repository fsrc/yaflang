_      = require('lodash')
stream = require('stream')
chalk  = require('chalk')
D      = require('./definitions')

colors = {}
colors[D.DELIMIT_START]       = chalk.green.bold
colors[D.DELIMIT_ENDER]       = chalk.green.bold
colors[D.DELIMIT_BOTH]        = chalk.red.bold
colors[D.DELIMIT_PUNCTUATION] = chalk.bold.magenta
colors[D.DELIMIT_SPACE]       = chalk.dim
colors[D.DELIMIT_LINE]        = chalk.dim
colors[D.DELIMIT_LITERAL]     = chalk.white.bold
colors[D.DELIMIT_KEYWORD]     = chalk.blue
colors[D.DELIMIT_INTEGER]     = chalk.yellow
colors[D.DELIMIT_DECIMAL]     = chalk.cyan

class InspectStream extends stream.Transform
  constructor: (@xs) ->
    super(objectMode: true)

  _transform: (token, enc, next) ->
    if token.type.delimit != D.DELIMIT_FILE
      process.stdout.write(colors[token.type.delimit](token.value))

    @push(token)
    next()


exports.pipe = (stream) -> stream.pipe(new InspectStream())

