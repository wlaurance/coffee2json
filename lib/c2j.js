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
    var clean, filename;
    clean = parse(data);
    filename = argv.o.split('.')[0] + '.json';
    return fs.writeFile(argv.o + '/' + filename, clean, function(err) {
      if (err) throw err;
      return console.log('it saved');
    });
  };

  parse = function(d) {
    return console.log(d.toString());
  };

}).call(this);
