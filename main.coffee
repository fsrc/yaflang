fs     = require("fs")
async  = require("async")
_      = require("lodash")
stream = require("stream")


lexer   = require("./streams/lex-stream")
parser  = require("./streams/parse-stream")
inspect = require("./streams/inspect-stream")

# Define handy helpers
log   = console.error
print = console.log

PATH = "./code-examples"


# Entry point for lexer
main = (files, callback) ->
  _(files)
    .map((file) -> fs.createReadStream(file, {encoding:'utf8', autoClose:true}))
    .map((stream) -> stream.on('error', callback))
    .map(lexer.pipe)
    .map(inspect.pipe)
    .map(parser.pipe)
    .map((stream) ->
      stream.on('data', (node) ->
        callback(null, node)))
    .value()

fs.readdir(PATH, (err, files) ->
  main(files.map((f) -> "#{PATH}/#{f}"), (err, output) ->
    if err?
      log("There was an error")
      log(err)
    else
      logfile = fs.createWriteStream('./generated-data.log', { flags: "a", encoding: "utf8" })
      logfile.write("#########################################")
      logfile.write(JSON.stringify(output, null, 2))
    ))

