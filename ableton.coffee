fs = require 'fs'
zlib = require 'zlib'
concat = require 'concat-stream'
cheerio = require 'cheerio'
{Parser, Builder} = require 'xml2js'

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

onLoad = (callback, parseMode) ->
  return (xml) ->
    switch parseMode
      when 'xmlstring'
        callback(null, xml)
      when 'dom'
        dom = cheerio.load(xml)
        callback(null, dom)
      when 'js'
        parser = new Parser(mergeAttrs: yes)
        parser.parseString(xml, callback)
      else
        throw new Error("Invalid parse mode #{parseMode}.")

# Class for reading and writing the Ableton Live project file format
class Ableton
  constructor: (@path, @parseMode = 'dom') ->

  read: (callback) ->
    fs.createReadStream(@path).on('error', fsError(callback, @path))
      .pipe(zlib.createGunzip()).on('error', unzipError(callback, @path))
      .pipe(concat(onLoad(callback, @parseMode)))

  write: (xml, callback) ->
    unless xml
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
