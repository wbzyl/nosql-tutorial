#### {% title "NodeJS ← Couchapp + CouchClient + Cradle" %}

Do tej pory, do umieszczenia dokumentu w bazie CouchDB
używaliśmy programu *curl*. W wypadku design documents,
oznaczało to że kod JavaScript wpisywany jako string
musiał być odpowiednio „quoted”.

Takie podejście ma dużą zaletę – przykłady łatwo jest
przeklikać na terminal i uruchomić.
Jednak gdy sami mamy taki przykład wpisać, lepiej
jest skorzystać z metody która umożliwi wpisywanie
kodu JavaScript jako kodu a nie napisu.

Poniżej opisuję jak to można zrobić korzystając z modułu
[couchapp](https://github.com/mikeal/node.couchapp.js).

Niestety, Couchapp nie nadaje się do odpytywania bazy CouchDB, ani do
zapisywania w niej dokumentów.

Dlatego do zapisywania dokumentów będziemy korzystać z modułów
CouchClient i Cradle. Oba moduły instalujemy globalnie:

    npm install -g couchapp
    npm install -g couch-client
    npm install -g cradle

Sprawdzamy jakie mamy moduły są zainstalowane:

    npm ls -g


## Zapisywanie danych w bazie

Zajmiemy się następującymi przypadkami danych zapisanych w plikach:

* format JSON; dane gotowe do umieszczenia
  hurtem w bazie; plik przykładowy
  {%= link_to "places.json", "/node/db/places.json" %}
  ({%= link_to "źródło", "/doc/node/db/places.json" %})
* format CSV, gdzie pierwszy
  wiersz zawiera nazwy pól; plik przykładowy
  {%= link_to "cities.csv", "/node/db/cities.csv" %}
  ({%= link_to "źródło", "/doc/node/db/cities.csv" %})


### JSON

Do zapisania danych z pliku *places.json* do bazy CouchDB
użyjemy prostego skryptu:

    :::javascript bulk_doc.js
    var argv = process.argv.splice(2);
    var filename = argv[0];
    var dbname = argv[1];

    var cc = require('couch-client')('http://localhost:5984/' + dbname)
    , fs = require('fs');

    var text = fs.readFileSync(filename, 'UTF-8');
    var json = JSON.parse(text);

    cc.request("POST", cc.uri.pathname + "/_bulk_docs", json, function(err, results) {
      if (err) throw err;
    });

Zobacz też rozbudowaną wersję tego skryptu:
{%= link_to "bulk_docs.js", "/node/db/bulk_docs.js" %}
({%= link_to "źródło", "/doc/node/db/bulk_docs.js" %}).
(*Uwaga:* funkcję *stripExt* można usunąć.)

Skrypt ten uruchamiamy na konsoli w taki sposób:

    node bulk_docs.js places.json places

*Uwaga:* Przed uruchomieniem skryptu musimy utworzyć bazę *places*:

    curl -X PUT http://localhost:5984/places


### CSV

Ze strony [Geobytes](http://www.geobytes.com/freeservices.htm)
pobieramy *GeoWorldMap.zip*. Archiwum zawiera plik
*cities.txt* z danymi 32227 miast. Przeniesiemy te dane do bazy CouchDB.

Do zapisania danych w bazie użyjemy skryptu. Jest on tylko nieco bardziej
skomplikowany od poprzedniego skryptu.

W skrypcie użyjemy modułu [CSV](https://github.com/wdavidw/node-csv-parser),
który musimy najpierw zainstalować:

    npm search csv      # szukamy czy ostatnio nie pojawiło się coś nowego
    npm install -g csv

Skrypt nazwiemy *csv_insert.js* i będziemy go uruchamiać w taki sposób:

    node csv_insert.js cities

Oto kod tego skryptu:

    :::javascript csv_insert.js
    var csv = require('csv')
    , cradle = require('cradle');

    var argv = process.argv.splice(2);
    var cities = 'cities.csv';  // plik cities.txt z GeoWorldMap po konwersji na utf-8
    var dbname = argv[0];
    var db = new(cradle.Connection)('http://localhost', 5984).database(dbname)

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
        // zamienimy współrzędne geograficzne na ten format;
        // wtedy będziemy mogli użyć bez zmian funkcji spatial ze tej strony
        data.loc = [parseFloat(data.Longitude), parseFloat(data.Latitude)];
        delete data.Longitude; // długość geograficzna
        delete data.Latitude;  // szerokość geograficzna

        return data;
      })
      .on('data', function(data, index) {
        db.save(data, function(err, res) {
          if (err) console.error(err);
        });
      })
      .on('end', function(count) {
        console.info('Number of records: ' + count);
      })
      .on('error', function(error) {
        console.error(error.message);
      });

Tak jak powyżej, link do rozbudowanej wersji:
{%= link_to "insert_csv.js", "/node/db/csv_insert.js" %}
({%= link_to "źródło", "/doc/node/db/csv_insert.js" %}).


## Moduł Couchapp

Moduł Couchapp zawiera plik wykonywalny *couchapp*.
Ułatwia on tworzenie aplikacji dla CouchDB.
Poniżej jest prosty przykład wyjaśniający co to znaczy.

    :::javascript aye.js
    var couchapp = require('couchapp');

    ddoc = {
      _id: '_design/default'
      , views: {}
      , lists: {}
      , shows: {}
    }
    module.exports = ddoc;

    ddoc.shows.aye = function(doc, req) {
      return {
        headers: { "Content-Type": "text/plain" },
        body: "Aye aye: " + req.query["q"] + "!\n"
      };
    };

Po wpisaniu powyższego kodu w pliku *aye.js*, bardzo łatwo jest zapisać
funkcję show w bazie:

    curl -X PUT http://localhost:5984/aye
    couchapp push aye.js http://localhost:5984/aye
    Preparing.
    Serializing.
    PUT http://localhost:5984/aye/_design/default
    Finished push. 1-8b19d3b6d7c00d6f51743968f77e9cbf

Na konie sprawdzamy, czy funkcja show została zapisana w bazie:

    curl -v http://localhost:5984/aye/_design/default/_show/aye/x?q=Captain


### Rozszerzenie GeoCouch

Przykład z funkcją listową z pliku *README*.

Dane:

    :::json geo.json
    {
      "docs": [
         {
           "_id": "oakland",
           "loc": [-122.270833, 37.804444]
         },
         {
           "_id": "augsburg",
           "loc": [10.898333, 48.371667]
         },
         {
           "_id": "namibia",
           "loc": [17.15, -22.566667]
         },
         {
           "_id": "australia",
           "loc": [135, -25]
         },
         {
           "_id": "brasilia",
           "loc": [-52.95, -10.65]
         }
      ]
    }

Tworzymy bazę *places* i zapiujemy w niej dane z JSON-a:

    curl -X POST -H "Content-Type: application/json" --data @geo.json http://127.0.0.1:5984/places/_bulk_docs

Plik dla *couchapp*:

    :::javascript geo.js
    var couchapp = require('couchapp');

    ddoc = {
      _id: '_design/default'
      , views:   {}
      , lists:   {}
      , shows:   {}
      , spatial: {}
    }

    ddoc.spatial.points = function(doc) {
      if (doc.loc) {
        emit({type: "Point", coordinates: [doc.loc[0], doc.loc[1]]}, [doc._id, doc.loc]);
      };
    };

    ddoc.lists.wkt = function(head, req) {
      var row;
      while (row = getRow()) {
        send("POINT(" + row.value[1] + ")\n");
      };
    };

    module.exports = ddoc;

Zapisujemy funkcje w bazie *places*:

    couchapp push geo.js http://localhost:5984/places

Kilka zapytań:

    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=0,0,180,90'
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=110,-60,-30,15&plane_bounds=-180,-90,180,90'
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/_list/wkt/points?bbox=-180,-90,180,90'


## Moduł Cradle + CSV

TODO: skleić CSV z Cradle.

    :::javascript readcsv.js
    var csv = require('csv');

    process.stdin.resume();

    csv()
      .fromStream(process.stdin, { columns: true })
      .transform(function(data){
        delete data.CityId;
        delete data.RegionID;
        delete data.DmaId;
        delete data.Code;
        return data;
      })
      .on('data',function(data,index){
        console.log('#'+index+' '+JSON.stringify(data));
      })
      .on('end',function(count){
        console.log('Number of lines: '+count);
      })
      .on('error',function(error){
        console.log(error.message);
      });

Użycie:

    node readcsv.js < cities.txt

Plik:

    :::csv cities.txt
    "CityId","CountryID","RegionID","City","Latitude","Longitude","TimeZone","DmaId","Code"
    42231,1,833,"Herat","34.333","62.2","+04:30",0,"HERA"
    5976,1,835,"Kabul","34.517","69.183","+04:50",0,"KABU"
    42230,1,852,"Mazar-e Sharif","36.7","67.1","+4:30",0,"MSHA"
    42412,2,983,"Korce","40.6162","20.7779","+01:00",0,"KORC"

Dodajemy coś do bazyy *places*:

    :::javascript places.js
    var cradle = require('cradle');
    var db = new(cradle.Connection)('http://localhost', 5984).database('places');

    db.get('augsburg', function (err, doc) {
      console.log(JSON.stringify(doc));
    });

    db.merge('augsburg', {
      region: 'Bavaria'
    }, function (err, res) {
      if (err) {
        // Handle error
      } else {
        // Handle success
      }
    });

    db.save('krakow', {
      loc: [50.083, 19.917],
      region: 'małopolska'
    }, function(err, res) {
      if (err) {
        console.log('Error when saving krakow');
      } else {
        console.log('Saved krakow');
      }
    });

    db.save('gdynia', {
      loc: [54.5, 18.55]
    }, function(err, res) {
      // Handle response
    });

    db.save('warsaw', {
      loc: [52.25, 21.00]
    }, function(err, res) {
      // Handle response
    });

Użycie:

    node places.js


**Nie działają zapytania GEO**: zamienić na zwykłe zapytanie do bazy *ls*.

Odpytywanie bazy za pomocą programu *curl*:

    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=0,0,180,90'

programu dla Cradle:

    :::javascript query.js
    var cradle = require('cradle');
    var db = new(cradle.Connection)('http://localhost', 5984).database('places');
    db.view('default/_spatial/points', {'bbox': '0,0,180,90'}, function (err, res) {
        res.forEach(function (row) {
            sys.puts(row.name + " is on the " +
                     row.force + " side of the force.");
        });
    });

Zob. [database queries](http://sitr.us/2009/06/30/database-queries-the-couchdb-way.html) (2009)


## Moduł CouchClient

**TODO:** sprawdzić czy zapytania GEO działają
z [couch-client](https://github.com/creationix/couch-client).


