assert = require 'assert'

Ableton = require '../ableton.coffee'

a = new Ableton('test/empty.als')

a.read((error, $) ->
  assert.equal(error, null)
  assert.equal(typeof $, 'function')
  assert.equal($('ableton').find('creator').text(), 'Ableton Live 9.1.5')

  liveset = $('liveset')
  tracks = liveset.find('tracks')
  midi = tracks.find('miditrack')
  audio = tracks.find('audiotrack')

  tempo = liveset.find('mastertrack tempo manual').find('value').text()

  assert.equal(tempo.length, 3)
  assert.equal(tempo, '120')

  assert.equal(midi.length, 2)
  assert.equal(audio.length, 2)

  console.log 'Tests passed'
)

b = new Ableton('test/plugins.als', 'dom')

b.read((error, $) ->
  assert.equal(error, null)
  assert.equal(typeof $, 'function')
  assert.equal($('ableton').attr('creator'), 'Ableton Live 9.1.7')

  liveset = $('liveset')
  tracks = liveset.find('tracks')
  midi = tracks.find('miditrack')
  audio = tracks.find('audiotrack')

  tempo = parseInt(liveset.find('mastertrack tempo manual').attr('value'), 10)

  assert.equal(tempo, 125)

  assert.equal(midi.length, 2)
  assert.equal(audio.length, 0)

  console.log 'Tests passed'
)

b = new Ableton('test/plugins.als', 'js')

b.read((error, obj) ->
  assert.equal(error, null)
  assert.equal(typeof obj, 'object')
  assert.equal(obj.Ableton.Creator[0], 'Ableton Live 9.1.7')

  console.log 'Tests passed'
)
