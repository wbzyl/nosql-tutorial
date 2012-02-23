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
[CouchClient](https://github.com/creationix/couch-client)
i [Cradle](https://github.com/cloudhead/cradle).
Oba moduły instalujemy globalnie:

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


## Przykład użycia rozszerzenia GeoCouch


Przerobimy przykład z funkcją spatial z [GeoCouch](https://github.com/couchbase/geocouch).

Zaczynamy od utworzenia bazy *places*:

    :::bash
    curl -X PUT http://127.0.0.1:5984/places

Współrzędne kilku miejsc na mapie zapiszemy hurtem w bazie *places*:

    :::bash
    curl -X POST -H "Content-Type: application/json" --data @places.json http://localhost:5984/places/_bulk_docs

Link do użytego powyżej pliku {%= link_to "places.json", "/node/db/places.json" %}.

Do zapisania funkcji spatial oraz funkcji listowej użyjemy poniższego skryptu:

    :::javascript geo.js
    var couchapp = require('couchapp');

    ddoc = {
      _id: '_design/default'
      , views:   {}
      , lists:   {}
      , shows:   {}
      , spatial: {}
    }
    module.exports = ddoc;

    ddoc.spatial.points = function(doc) {
      if (doc.loc) {
        emit({
            type: "Point",
            coordinates: [doc.loc[0], doc.loc[1]]
          },
             [doc._id, doc.loc]);
      };
    };

    ddoc.lists.wkt = function(head, req) {
      var row;
      while (row = getRow()) {
        log(JSON.stringify(row));
        send("POINT(" + row.value[1] + ")\n");
      };
    };

**Uwaga:** Funkcje spatial używają tej samej funkcji *emit* co widoki.

Zapisujemy obie funkcje w bazie *places* jako design documents:

    :::bash
    couchapp push geo.js http://localhost:5984/places

Teraz możemy odpytać bazę:

    :::bash
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=0,0,180,90'
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=110,-60,-30,15&plane_bounds=-180,-90,180,90'
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/_list/wkt/points?bbox=-180,-90,180,90'

Miejsca zapisane w bazie:

{%= image_tag "/images/places.png", :alt => "[Places: Brasilia, …]" %}

Czy wyniki są OK?

Zobacz też [database queries](http://sitr.us/2009/06/30/database-queries-the-couchdb-way.html) (2009).


## Flickr & GeoCouch

GeoCouch implementuje standard [GeoJSON](http://geojson.org/geojson-spec.html).
W standardzie zdefiniowano wiele typów *Geometry*.
Najprostszy typ to *Point*. Oto przykład:

    :::json
    {
      "type": "Point",
      "coordinates": [100.0, 0.0]  // longitude, latitude (długość, szerokość)
    }

Tworzymy bazę *tatry*:

    :::bash
    curl -X PUT http://127.0.0.1:5984/tatry

I importujemy do niej dane z wcześniej pobranego z Flickr pliku *flickr_search-01.json*:

    :::js import.js
    var cradle = require("cradle")
    , util = require("util")
    , fs = require("fs");

    var connection = new(cradle.Connection)("localhost", 5984);
    var db = connection.database('tatry');

    var couchimport = function(filename) {
      var data = fs.readFileSync(filename, "utf-8");
      var flickr = JSON.parse(data);

      for (var p in flickr.photos.photo) {
        photo = flickr.photos.photo[p];

        var id = photo.id;
        var longitude = photo.longitude;
        var latitude  = photo.latitude;
        delete photo.id;
        delete photo.longitude;
        delete photo.latitude;

        if (longitude && latitude && longitude != 0 && latitude != 0) {
          console.log("[lng, lat] = ", photo.longitude, photo.latitude)

          photo.geometry = {"type": "Point", "coordinates": [longitude, latitude]};

          // flickr image codes: s – small, m – medium, z – big, b – bigger
          // http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[tsmzb].jpg
          photo.image_url_medium = ["http://farm",photo.farm,".static.flickr.com/",photo.server,"/",id,"_",photo.secret,"_z.jpg"].join("");

          db.save(photo.id, photo, function(er, ok) {
            if (er) {
              console.log("Error: " + er);
              return;
            }
          });
        }
      }
    };

    ["flickr_search-01.json"].forEach(function (name) {
      couchimport(name);
      console.log("imported data from:", name);
    });

Dane pobrałem w taki sposób:

    :::bash terminal
    curl "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=<MY-API-KEY>&text=$search&has_geo=true&extras=geo&per_page=250&format=json&nojsoncallback=1"

Pobieramy przykładowy dokument z bazy:

    http://localhost:5984/tatry/6912057723

Oto wynik:

    :::json
    {
       _id: "6912057723",
       _rev: "1-024844ff2699e058b8f1a44a14ab2fac",
       owner: "25196109@N06",
       secret: "6e81646d62",
       server: "7061",
       farm: 8,
       title: "Panorama in der Hohen Tatra",
       accuracy: "16",
       place_id: "WwoSYGxUUrm4yzs",
       woeid: "503425",
       geometry: {
         type: "Point",
         coordinates: [
           19.988036,
           49.228258
         ]
       },
       image_url_medium: "http://farm8.static.flickr.com/7061/6912057723_6e81646d62_z.jpg"
    }

Po przekilkaniu powyższego url zobaczymy fajne zdjęcie.
A na stronie:

    http://www.flickr.com/services/api/explore/flickr.places.getInfo

możemy przeklikać *place_id*, aby dowiedzieć się co to za miejsce.
