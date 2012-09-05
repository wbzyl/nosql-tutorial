var findit = require('findit'),
  fs = require('fs'),
  eyes = require('eyes'),
  xml2js = require('xml2js');

var mongo = require('mongodb'),
  Server = mongo.Server,
  Db = mongo.Db;

var server = new Server('localhost', 27017, {auto_reconnect: true});
var db = new Db('poliqarp', server);

db.open(function(err, db) {
  if(err) {
    console.error('ERROR:', 'could not connect to DB');
    process.exit(1);
  };

  db.collection('toks', function(err, collection) {
    findit.find('./frekwencyjny', function (file) {
      if (file.match(/morph.xml$/)) {
        console.log(file);

        var parser = new xml2js.Parser();
        parser.on('end', function(result) {
          var normalized = result.chunkList.chunk.tok.map(function(x) {
            return normalize(x);
          });
          // eyes.inspect(normalized);
          // save normalized tok array
          collection.insert(normalized, {safe: true}, function(err, result) {
            if (err) {
              console.error('ERROR when writing to DB:', result);
            }
          });
        });
        fs.readFile(file, function(err, data) {
          parser.parseString(data);
        });
      };
    });

    // console.log('closing DB connection!');
    // db.close();
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
