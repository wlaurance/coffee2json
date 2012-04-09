#!/usr/bin/env node
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
  base = argv.o
  if base[base.length-1] isnt '/'
    base = base + '/'
  filename = base + filename + '.json'
  parse data, base, filename

parse = (d, base, out) ->
  temp = base + process.pid
  fs.writeFileSync temp, d
  p = path.dirname fs.realpathSync(__filename)
  primary = spawn  p + '/parse.sh', [temp, out]
  primary.on 'exit', (code) ->
    if code is 0
      time = (new Date).toString().split(' ')[4]
      console.log  time + ' - compiled ' + out
    else
      console.log 'ERROR ' + out

  primary.stderr.on 'data', (d) ->
    try 
      JSON.parse do d.toString 
    catch e
      jsonlint = spawn 'jsonlint', [out]
      jsonlint.stdout.on 'data', (f)->
        console.log f.toString()

