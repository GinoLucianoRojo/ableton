module.exports = (grunt) ->
  require('time-grunt')(grunt)

  grunt.initConfig
    coffee:
      compile:
        files:
          'ableton.js': 'ableton.coffee'

    mochaTest:
      test:
        options:
          timeout: 2000
          reporter: 'spec'
          require: ['coffee-script/register']
        src: [
          'test/helper.coffee'
          'test/specs/*.coffee'
        ]

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      main:
        src: ['ableton.coffee', 'test/**/*.coffee', 'Gruntfile.coffee']

  require('jit-grunt')(grunt)

  grunt.registerTask 'default', ['coffee']
  grunt.registerTask 'lint', ['coffeelint']
  grunt.registerTask 'doc', ['codo']
  grunt.registerTask 'test', ['lint', 'mochaTest']
