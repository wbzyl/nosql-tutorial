#### {% title "NodeJS ← Couchapp + CouchClient + Cradle" %}

Do tej pory, do umieszczenia dokumentu w bazie CouchDB
używaliśmy programu *curl*. W wypadku design documents,
oznaczało to że kod JavaScript wpisywany jako string
musiał być odpowiednio „quoted”.

Takie podejście ma dużą zaletę – przykłady łatwo jest
przeklikać na terminal i uruchomić.
Jednakże, kiedy sami mamy taki przykład wpisać, lepiej
jest skorzystać z metody która umożliwi wpisywanie
kodu JavaScript jako kodu a nie jako napisu.

Poniżej opisuję jak to można zrobić korzystając z modułu
[couchapp](https://github.com/mikeal/node.couchapp.js):

    git clone git://github.com/mikeal/node.couchapp.js.git
    cd node.couchapp.js
    npm install
    npm link .

Moduł ten nie nadaje się do zapisywania dokumentów w bazie CouchDB,
dlatego do zapisywania dokumentów w bazie użyjemy modułów
[CouchClient](https://github.com/creationix/couch-client)
i [Cradle](https://github.com/cloudhead/cradle):

    npm install -g couch-client
    npm install -g cradle

Być może czasami warto by było skorzystać z modułu *request*:

    npm install -g request


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

    :::bash
    node bulk_docs.js places.json places

*Uwaga:* Przed uruchomieniem skryptu musimy utworzyć bazę *places*:

    :::bash
    curl -X PUT http://localhost:5984/places


### CSV

Ze strony [Geobytes](http://www.geobytes.com/freeservices.htm)
pobieramy *GeoWorldMap.zip*. Archiwum zawiera plik
*cities.txt* z danymi 32227 miast. Przeniesiemy te dane do bazy CouchDB.

Do zapisania danych w bazie użyjemy skryptu. Jest on tylko nieco bardziej
skomplikowany od poprzedniego skryptu.

W skrypcie użyjemy modułu [CSV](https://github.com/wdavidw/node-csv-parser),
który musimy najpierw zainstalować:

    :::bash
    npm search csv      # szukamy czy ostatnio nie pojawiło się coś nowego
    npm install csv

Skrypt nazwiemy *csv_insert.js* i będziemy go uruchamiać w taki sposób:

    :::bash
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


## Node CouchApp

Moduł Node Couchapp zawiera plik wykonywalny *couchapp*.
Ułatwia on tworzenie aplikacji dla CouchDB.

Oto prosty przykład

    :::javascript aye.js
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

    :::bash
    curl -X PUT http://localhost:5984/aye
    couchapp push aye.js http://localhost:5984/aye
    Preparing.
    Serializing.
    PUT http://localhost:5984/aye/_design/default
    Finished push. 1-8b19d3b6d7c00d6f51743968f77e9cbf

Po zapisaniu funkcji show *aye* w *_design/default* w bazie *aye*,
możemy ją wykonać, np. w taki sposób:

    :::bash
    curl -v http://localhost:5984/aye/_design/default/_show/aye/x?q=Captain
