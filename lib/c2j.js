(function() {
  var argv, coffee2json, fs, parse, path, print, spawn;

  fs = require('fs');

  argv = require('optimist').argv;

  print = require('sys').print;

  spawn = require('child_process').spawn;

  path = require('path');

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
    var p, primary, temp;
    temp = argv.o + '/' + process.pid;
    fs.writeFileSync(temp, d);
    p = path.dirname(fs.realpathSync(__filename));
    primary = spawn(p + '/parse.sh', [temp, out]);
    primary.stdout.on('data', function(d) {
      return console.log(d.toString());
    });
    return primary.on('exit', function(code) {
      return console.log('Wrote ' + out);
    });
  };

}).call(this);
