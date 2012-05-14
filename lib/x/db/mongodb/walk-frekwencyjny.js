// http://mongodb.github.com/node-mongodb-native/api-generated/collection.html
// https://github.com/substack/node-findit
// https://github.com/Leonidas-from-XIV/node-xml2js/

var xml2js = require('xml2js')
, fs = require('fs')
, eyes = require('eyes')
, finder = require('findit').find('frekwencyjny')
, assert = require('assert');

var mongo = require('mongodb'),
  Server = mongo.Server,
  Db = mongo.Db;

var server = new Server('localhost', 27017, {auto_reconnect: true});
var db = new Db('poliqarp', server);

db.open(function(err, db) {
  assert.equal(null, err);

  db.collection('toks', function(err, collection) {
    assert.equal(null, err);

    finder.on('file', function (file, stat) {
      if (file.match(/morph.xml$/)) {
        console.log('processing', file);

        var parser = new xml2js.Parser();

        var data = fs.readFileSync(file, 'utf8');
        parser.parseString(data, function (err, result) {
          assert.equal(null, err);
          var normalized = result.chunkList.chunk.tok.map(function(x) {
            return normalize(x);
          });
          // eyes.inspect(normalized);
          // asynchroniczny zapis?
          collection.insert(normalized, {safe: true, fsync: false}, function(err, result) {
            assert.equal(null, err);
          });
          console.log('done with', file);
        });
      };
    });

    finder.on('end', function(err, result) {
      db.close();
      console.log('DONE: closed db connection');
      // setTimeout(function() {
      //   db.close();
      //   console.log('DONE: closed db connection');
      // }, 30000);
    });

  });

});

// remove @ attribute; convert lex attribute to array

function normalize(obj) {
  if ( !(obj.lex instanceof Array) ) {
    obj.lex = [ obj.lex ];
  };
  obj.lex.forEach(function(x) {
    delete x['@'];
  });
  return obj;
}
