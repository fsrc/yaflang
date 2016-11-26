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
GENERATED_DATA_LOG_FILE = "./generated-data.log"

log_to_file = (file, text) ->
  logfile = fs.createWriteStream(file, { flags: "a", encoding: "utf8" })
  logfile.write(text)
  logfile.close()

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
  log_to_file(GENERATED_DATA_LOG_FILE, "###################################\n\n")

  main(files.map((f) -> "#{PATH}/#{f}"), (err, output) ->
    if err?
      log("There was an error")
      log(err)
    else
      log_to_file(
        GENERATED_DATA_LOG_FILE,
        JSON.stringify(output) + "\n")))

