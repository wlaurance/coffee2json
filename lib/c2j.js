(function() {
  var argv, coffee2json, fs, parse, print, spawn;

  fs = require('fs');

  argv = require('optimist').argv;

  print = require('sys').print;

  spawn = require('child_process').spawn;

  exports.run = function() {
    var t;
    t = spawn('coffee', ['-o', argv.o, '-cwbp', argv.i]);
    return t.stdout.on('data', function(d) {
      return coffee2json(d);
    });
  };

  coffee2json = function(data) {
    var file, filename;
    file = argv.i.split('/');
    filename = file[file.length - 1].split('.')[0];
    filename = argv.o + '/' + filename + '.json';
    return parse(data, filename);
  };

  parse = function(d, out) {
    var primary, replace, temp;
    temp = argv.o + '/' + process.pid;
    replace = '../node_modules/.bin/replace';
    fs.writeFileSync(temp, d);
    primary = spawn('lib/parse.sh', [temp, out]);
    return primary.on('exit', function(code) {
      return console.log('Wrote ' + out);
    });
  };

}).call(this);
