console.time('total-time');

function usage(when) {
  var scriptName = process.argv[1].split('/').pop();
  if (when) {
    console.info('Usage: node ' + scriptName + ' FILENAME DBNAME(must exist)');
    console.info("  Bulk insert data from 'places.json\' into CouchDB 'places' database.");
    console.info('An example:');
    console.info('  (1) create database: curl -X PUT http://localhost:5984/places');
    console.info('  (2) run: node ' + scriptName + ' places.json places');
    process.exit(1);
  };
};

function stripExt(name) {
  var i = name.lastIndexOf('.');
  return i == -1 ? name : name.slice(0, i);
};

var argv = process.argv.splice(2);
usage(argv.length !== 2);

var filename = argv[0];
var dbname = argv[1];

var cc = require('couch-client')('http://localhost:5984/' + dbname)
, fs = require('fs');

var text = fs.readFileSync(filename, 'UTF-8');
var json = JSON.parse(text);

cc.request("POST", cc.uri.pathname + "/_bulk_docs", json, function(err, results) {
  if (err) {
    throw err;
  } else { 
    console.info(json.docs.length + ' records was written to database: ' + dbname);
  };
});

console.timeEnd('total-time');
