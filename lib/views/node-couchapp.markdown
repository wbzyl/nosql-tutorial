#### {% title "NodeJS & Couchapp + Cradle + CouchClient" %}

Do tej pory, aby umieścić dokument w bazie używaliśmy
programu *curl*. W przypadku design documents, wymagało
to od nas uwagi przy zapisywaniu kodu Javascript
w napisach – trudno jest poprawnie wpisać zagnieżdżone napisy.

Ale takie podejście ma dużą zaletę – takie przykłady łatwo jest
przeklikać na terminal i uruchomić.
Jednak gdy sami mamy taki przykład przgotować, lepiej
jest skorzystać z metody która umożliwia wpisywanie
kodu bezpośrednio.

Poniżej opisuję jak to można zrobić korzystając z modułu
NodeJS [node.couchapp.js](https://github.com/mikeal/node.couchapp.js).
Wadą tego rozwiązania jest to, że wymaga umiejętności
programowania w Javascripcie.

Moduł Couchapp nie nadaje się do odpytywania bazy CouchDB, ani do
zapisywania w niej dokumentów. Zamiast niego skorzystamy z modułu
Cradle.

Oba moduły instalujemy globalnie:

    npm install -g couchapp
    npm install -g cradle


## Moduł Couchapp

Teraz wzorując się na przykładzie z *README.md* kodujemy przykład z *maye.json*:

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
        headers: { "Content-Type": "text/html" },
        body: "<h2>Aye aye: " + req.query["q"] + "</h2>\n<p>" + doc.quotation + "</p>\n"
      }
    }

Po wpisaniu powyższego kodu w pliku *aye.js*, zapisujemy funkcję show w bazie
(swoje dane uwierzytelniające wpisujemy tylko gdy zabezpieczyliśmy dostęp do CouchDB hasłem):

    couchapp push aye.js http://User:Pass@localhost:5984/ls
    Preparing.
    Serializing.
    PUT http://wbzyl:******@localhost:5984/ls/_design/default
    Finished push. 2-7068bcbdcec03650a8dee623e5afe1a1

Sprawdzamy, czy wszystkie polecenia wykonane zostały bez błędu:

    curl -v http://localhost:5984/ls/_design/default/_show/aye/1?q=Captain


## Rozszerzenie GeoCouch

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


