# Ableton [![Build Status](https://travis-ci.org/lavelle/ableton.svg)](https://travis-ci.org/lavelle/ableton)

Parser for Ableton Live's .als file format.

## Install

```bash
$ npm install --save ableton
```

## Use

```js
// Initialise
var Ableton = require('ableton');
var ableton = new Ableton('/path/to/project.als');

// Read
ableton.read(function(error, $) {
  if (error) {
    console.error(error);
  }
  else {
    // `data` is a .
    console.log($('ableton').attr('creator'));
  }
});

// Write
var xml = ... // An XML string representing an Ableton project file
ableton.write(xml, function(error) {
  if (error) {
    console.log(error);
  }
  else {
    console.log('Written successfully to ' + ableton.path);
  }
});
```

## License

MIT
