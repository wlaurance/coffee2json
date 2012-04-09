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
    var base, file, filename;
    file = argv.i.split('/');
    filename = file[file.length - 1].split('.')[0];
    base = argv.o;
    if (base[base.length - 1] !== '/') base = base + '/';
    filename = base + filename + '.json';
    return parse(data, base, filename);
  };

  parse = function(d, base, out) {
    var p, primary, temp;
    temp = base + process.pid;
    fs.writeFileSync(temp, d);
    p = path.dirname(fs.realpathSync(__filename));
    primary = spawn(p + '/parse.sh', [temp, out]);
    primary.on('exit', function(code) {
      var time;
      if (code === 0) {
        time = (new Date).toString().split(' ')[4];
        return console.log(time + ' - compiled ' + out);
      } else {
        return console.log('ERROR ' + out);
      }
    });
    return primary.stderr.on('data', function(d) {
      var jsonlint;
      try {
        return JSON.parse(d.toString());
      } catch (e) {
        jsonlint = spawn('jsonlint', [out]);
        return jsonlint.stdout.on('data', function(f) {
          return console.log(f.toString());
        });
      }
    });
  };

}).call(this);
