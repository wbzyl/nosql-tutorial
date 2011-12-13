var csv = require('csv')
, cradle = require('cradle')
, fs = require('fs');

function usage(when) {
  var scriptName = process.argv[1].split('/').pop();
  if (when) {
    console.info('Usage: node ' + scriptName + ' CITIES COUNTRIES DBNAME(must exist)');
    console.info("  Insert data from 'cities.csv' into CouchDB 'places' database.");
    console.info('An example:');
    console.info('  (1) create database: curl -X PUT http://localhost:5984/cities');
    console.info('  (2) run: node ' + scriptName + ' cities.csv countries.csv cities');
    process.exit(1);
  };
};

var argv = process.argv.splice(2);
usage(argv.length !== 3);

var cities = argv[0];
var countries = argv[1];
var dbname = argv[2];

var db = new(cradle.Connection)('http://localhost', 5984).database(dbname)

console.time('total-time');

// "CountryId", "Country", ...
// 1, "Afghanistan", ...

var countries = fs.readFileSync(countries, 'UTF-8').split('\n');

countries.shift(); // remove header line

var regex = /^(\d+),"([^"]+)"/;
var countryID = [];

countries.forEach(function(line, index, array) {
  var match = line.match(regex);
  if (match) {
    var i = parseInt(match[1]);
    var name = match[2];
    countryID[i] = name;
  };
});

// "CityId","CountryID","RegionID","City","Latitude","Longitude","TimeZone","DmaId","Code"
// 14676,197,3279,"Krakow","50.083","19.917","+01:00",0,"KRAK

csv()
  .fromPath(__dirname + '/' + cities, { columns: true })
  .transform(function(data) {
    delete data.CityId;
    delete data.RegionID;
    delete data.DmaId;
    delete data.Code;
    // w przykładach z GeoCouch na stronie https://github.com/couchbase/geocouch
    // autor zapisuje dane geo w taki sposób:
    //   "loc": [-122.270833, 37.804444]
    // zamienimy dane geo na ten format;
    // wtedy będziemy mogli użyć bez zmian funkcji spatial ze tej strony
    data.loc = [parseFloat(data.Longitude), parseFloat(data.Latitude)];
    data.Country = countryID[parseInt(data.CountryID)];

    delete data.Longitude; // długość geograficzna
    delete data.Latitude;  // szerokość geograficzna
    delete data.CountryID;

    return data;
  })
  .on('data', function(data, index) {
    db.save(data, function(err, res) {
      if (err) {
        console.error(err);
        // process.exit(1);
      } else {
        // console.dir(data);
      };
    });
  })
  .on('end', function(count) {
    console.info('Number of records: ' + count);
    console.timeEnd('total-time');
  })
  .on('error', function(error) {
    console.error(error.message);
  });
