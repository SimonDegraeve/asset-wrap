fs = require 'fs'
path = require 'path'
nib = require 'nib'
sass = require 'node-sass'
Asset = require('../asset').Asset

class exports.SassAsset extends Asset
  ext: 'css'
  name: 'sass'
  type: 'text/css'
  compile: ->
    outputStyle = if @config.compress and @config.compress is true then 'compressed' else 'expanded'
    paths = @config.paths or []

    fs.readFile @src, 'utf8', (err, data) =>
      return @emit 'error', err if err?
      sass.render
        data: data
        includePaths: paths.concat [path.dirname @src]
        outputStyle: outputStyle
        error: (err) => 
          return @emit 'error', err
        success: (data) => 
          @data = data
          return @emit 'compiled'
