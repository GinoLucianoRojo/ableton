fs = require 'fs'
zlib = require 'zlib'
concat = require 'concat-stream'
{Parser, Builder} = require 'xml2js'
cheerio = require 'cheerio'

fsError = (callback) ->
  fn = (error) ->
    switch error.code
      when 'ENOENT'
        callback(new Error("'#{path}' does not exist"), null)
      when 'EISDIR'
        callback(new Error("'#{path}' is a directory"), null)
      else
        console.log error
        callback(new Error('Unknown error'))

  return fn

unzipError = (callback) ->
  return (error) ->
    callback(new Error("'#{path}' is not a valid Ableton project"), null)

onLoad = (callback, stringMode) ->
  return (xml) ->
    if stringMode
      callback(null, xml)
    else
      dom = cheerio.load(xml)
      callback(null, dom)

# Class for reading and writing the Ableton Live project file format
class Ableton
  constructor: (@path, @stringMode = false) ->

  read: (callback) ->
    parser = new Parser(mergeAttrs: yes)
    global.path = @path

    fs.createReadStream(path).on('error', fsError(callback))
      .pipe(zlib.createGunzip()).on('error', unzipError(callback))
      .pipe(concat(onLoad(callback, @stringMode)))

  write: (data, callback) ->
    unless data
      callback(new Error("No data to write"), null)
      return

    builder = new Builder()
    global.path = @path

    ws = fs.createWriteStream(path)
    ws.on('error', fsError(callback))

    xml = builder.buildObject(data)

    zlib.gzip(xml, (error, data) ->
      fs.writeFile(path, data, (error) ->
        callback(error, null)
      )
    )

module.exports = Ableton
