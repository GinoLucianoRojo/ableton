fs = require 'fs'
zlib = require 'zlib'
concat = require 'concat-stream'
{Parser, Builder} = require 'xml2js'

# Class for reading and writing the Ableton Live project file format
class Ableton
  constructor: (@path) ->

  read: (callback) ->
    parser = new Parser(mergeAttrs: yes)
    path = @path

    fs.createReadStream(path)
      .on('error', (error) ->
        switch error.code
          when 'ENOENT' then callback("'#{path}' does not exist")
          when 'EISDIR' then callback("'#{path}' is a directory")
          else
            console.log error
            callback('unknown error')
      )
      .pipe(zlib.createGunzip())
      .on('error', (error) ->
        callback("'#{path}' is not a valid Ableton project"))
      .pipe(concat((xml) -> parser.parseString(xml, callback)))

  write: (data, callback) ->
    unless data
      callback("No data to write")
      return

    builder = new Builder()
    path = @path

    ws = fs.createWriteStream(path)
    ws.on('error', (error) ->
      switch error.code
        when 'ENOENT' then callback("'#{path}' does not exist")
        when 'EISDIR' then callback("'#{path}' is a directory")
        else
          console.log error
          callback('unknown error')
    )

    xml = builder.buildObject(data)

    zlib.gzip xml, (error, data) ->
      fs.writeFile path, data, (error) ->
        callback(error)

module.exports = Ableton
