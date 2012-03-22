fs = require 'fs'
argv = require('optimist').argv
{print} = require 'sys'
{spawn} = require 'child_process'

exports.run = ->
  t = spawn 'coffee', ['-o', argv.o, '-cwbp' , argv.i]
  t.stdout.on 'data', (d) ->
    coffee2json d

coffee2json = (data)->
  clean = parse data
  filename = argv.o.split('.')[0] + '.json'
  fs.writeFile argv.o + '/' + filename, clean, (err)->
    if err
      throw err
    console.log 'it saved'


parse = (d) ->
  console.log d.toString()
