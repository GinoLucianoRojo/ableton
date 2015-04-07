fs = require 'fs'
zlib = require 'zlib'
concat = require 'concat-stream'
cheerio = require 'cheerio'

fsError = (callback, path) ->
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

unzipError = (callback, path) ->
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
    fs.createReadStream(@path).on('error', fsError(callback, @path))
      .pipe(zlib.createGunzip()).on('error', unzipError(callback, @path))
      .pipe(concat(onLoad(callback, @stringMode)))

  write: (xml, callback) ->
    unless data
      callback(new Error('No data to write'))
      return

    global.path = @path

    zlib.gzip(xml, (error, data) ->
      if error
        callback(error)
      else
        fs.writeFile(path, data, (error) ->
          callback(error)
        )
    )

module.exports = Ableton
