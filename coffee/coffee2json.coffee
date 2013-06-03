#!/usr/bin/env node
fs = require 'fs'
argv = require('optimist').argv
{print} = require 'util'
{spawn} = require 'child_process'
path = require 'path'
{sync} = require 'which'

bins = ['coffee', 'jsonlint']
for b in bins
  try
    sync b
  catch e
    throw e

exports.run = ->
  if argv.h?
    do help
  else if argv.v
    do version
  else if not argv.o? || not argv.i?
    do help
  else
    coffeeargs = '-cbp'
    coffeeargs += 'w' if argv.w?
    t = spawn 'coffee', ['-o', argv.o, coffeeargs , argv.i]
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

help = ->
  console.log 'coffee2json -i inputFile -o outputdirectory'

version = ->
  fs.realpath __filename, (err, resolvedpath) ->
    throw err if err
    cd = path.dirname resolvedpath
    fs.readFile cd + '/../package.json', (err, data) ->
      throw err if err
      info = JSON.parse data
      console.log 'v' + info.version
