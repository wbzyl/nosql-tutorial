#### {% title "NodeJS i moduł node.couchapp.js" %}

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

Zaczynamy od instalacji modułu według wskazówek
z pliku [README](https://github.com/mikeal/node.couchapp.js/blob/master/README.md):

    npm install couchapp

Sprawdzamy instalację modułu próbując uruchomic program *couchapp*:

    → couchapp
    couchapp -- utility for creating couchapps
    Usage:
      couchapp <command> app.js http://localhost:5984/dbname
    Commands:
      push   : Push app once to server.
      sync   : Push app then watch local files for changes.
      boiler : Create a boiler project.


## Przykład użycia

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


## GeoCouch

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
