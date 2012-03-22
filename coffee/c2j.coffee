fs = require 'fs'
argv = require('optimist').argv
{print} = require 'sys'
{spawn} = require 'child_process'

exports.run = ->
  t = spawn 'coffee', ['-o', argv.o, '-cwbp' , argv.i]
  t.stdout.on 'data', (d) ->
    coffee2json d

coffee2json = (data)->
  file = argv.i.split('/')
  filename = file[file.length-1].split('.')[0]
  filename = argv.o + '/' + filename + '.json'
  parse data, filename

parse = (d, out) ->
  temp = argv.o + '/' + process.pid
  replace = '../node_modules/.bin/replace'
  fs.writeFileSync temp, d
  primary = spawn 'lib/parse.sh', [temp, out]
  primary.on 'exit', (code) ->
    console.log 'Wrote ' + out

