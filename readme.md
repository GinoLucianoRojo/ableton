# Ableton [![Build Status](https://travis-ci.org/lavelle/ableton.svg)](https://travis-ci.org/lavelle/ableton)

> Parser for Ableton Live's .als file format.

## Intro

Ableton project files are just XML underneath, so the parser returns a [Cheerio][] object for the project file. You can then use all the normal jQuery commands to get the data out.

## Install

```bash
$ npm install --save ableton
```

## Use

### Initialise

```js
var Ableton = require('ableton');
var ableton = new Ableton('/path/to/project.als');
```

### Read

```js
ableton.read(function(error, $) {
  if (error) {
    console.error(error);
  }
  else {
    // `$` is the Cheerio root object.
    console.log($('ableton').attr('creator'));
  }
});
```

### Write

```js
var xml = ... // An XML string representing an Ableton project file.
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

[cheerio]: https://github.com/cheeriojs/cheerio
