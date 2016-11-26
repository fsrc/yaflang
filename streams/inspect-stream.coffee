_      = require('lodash')
stream = require('stream')
chalk  = require('chalk')
D      = require('./definitions')
tty    = require('tty')

colors = {}
colors[D.DELIMIT_START]       = chalk.green.bold
colors[D.DELIMIT_ENDER]       = chalk.green.bold
colors[D.DELIMIT_BOTH]        = chalk.red.bold
colors[D.DELIMIT_PUNCTUATION] = chalk.bold.magenta
colors[D.DELIMIT_SPACE]       = chalk.dim
colors[D.DELIMIT_LINE]        = chalk.dim
colors[D.DELIMIT_LITERAL]     = chalk.white.bold
colors[D.DELIMIT_KEYWORD]     = chalk.blue.bold
colors[D.DELIMIT_INTEGER]     = chalk.yellow
colors[D.DELIMIT_DECIMAL]     = chalk.yellow
colors[D.DELIMIT_STRING]      = chalk.yellow


bg = [chalk.bgBlack,
      chalk.bgRed,
      chalk.bgGreen,
      chalk.bgYellow,
      chalk.bgBlue,
      chalk.bgMagenta,
      chalk.bgCyan,
      chalk.bgWhite]

class InspectStream extends stream.Transform
  constructor: (@xs) ->
    process.stdout.write("\n")
    _.each(bg, (bg) -> process.stdout.write(bg(" ")))
    process.stdout.write("\n")
    process.stdout.write("\n")
    @bg_index = 0
    super(objectMode: true)
    @next = null

    process.stdin.resume()
    process.stdin.setEncoding('utf8')

  _transform: (token, enc, next) ->
    if token.type.delimit != D.DELIMIT_FILE
      # process.stdout.write(bg[@bg_index].call(colors[token.type.delimit], (token.value)))
      process.stdout.write(colors[token.type.delimit](token.value))
      @bg_index += 1
      if @bg_index > bg.length - 1
        @bg_index = 0


    @push(token)
    # process.stdin.once( 'data', (key) -> next())
    next()


exports.pipe = (stream) -> stream.pipe(new InspectStream())

