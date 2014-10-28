# Ableton

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
ableton.read(function(error, data) {
  if (error) {
    console.error(error);
  }
  else {
    // `data` is a JS object representing the Ableton project.
    console.log(data);
  }
});

// Write
var data = ... // Get the object returned by a previous `read` call from somewhere
ableton.write(data, function(error) {
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
