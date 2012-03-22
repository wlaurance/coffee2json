fs = require 'fs'
argv = require('optimist').argv
{print} = require 'sys'
{spawn} = require 'child_process'
path = require 'path'

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
  fs.writeFileSync temp, d
  p = path.dirname fs.realpathSync(__filename)
  primary = spawn  p + '/parse.sh', [temp, out]
  primary.stdout.on 'data', (d) ->
    console.log do d.toString
  primary.on 'exit', (code) ->
    console.log 'Wrote ' + out

