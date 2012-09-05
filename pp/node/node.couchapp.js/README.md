# node.couchapp.js

Coś użytecznego:

    sudo tcpdump -i lo -n -s 0 -w - port 5984

Po kolei, tworzymy aplikacje.

Aplikacja 01:

    curl -X PUT http://127.0.0.1:5984/couchapp_01
    couchapp push app_01.js http://localhost:5984/couchapp_01

Aplikacja 02:

    curl -X PUT http://127.0.0.1:5984/couchapp_02
    couchapp push app_02.js http://localhost:5984/couchapp_02

Wchodzimy na strone:

    http://localhost:5984/couchapp_02/_design/app/_show/foo

Aplikacja 03 z attachments:

    curl -X PUT http://127.0.0.1:5984/couchapp_03
    couchapp push app_03.js http://localhost:5984/couchapp_03

Wchodzimy na strone:

    http://localhost:5984/couchapp_03/_design/app/index.html


## Aplikacja 04 z show + szablon Mustache

[CommonJS modules in CouchDB](http://caolanmcmahon.com/posts/commonjs_modules_in_couchdb):

To add a module to a design document you need to store it as a string
(much as you would for any other function)

    {
        "_id": "_design/app",
        "lib": {
            "mymodule": "exports.name = 'my module';"
        },
        "mymodule2": "exports.name = 'my module 1';"
    }

Teraz można

    require('lib/mymodule')
    require('mymodule2')

Uwagi:

* paths are from the root of the design doc
* relative paths start with '..' or '.' and are relative to the current module
  (so, from `lib/mymodule`, you could do `require('../mymodule1')`)
* you can’t require modules from within view i.e. **map/reduce** functions

However, CouchDB v1.1.x:

    {
        "_id": "_design/app",
        "lib": {
            // modules here would not be accessible from view functions
        },
        "views": {
            "lib" {
                // this module is accessible from view functions
                "module": "exports.test = 'asdf';"
            },
            "commonjs": {
                "map": function (doc) {
                    var val = require('views/lib/module').test;
                    emit(doc._id, val);
                }
            }
        }
    }

Przykład:

    curl -X PUT http://127.0.0.1:5984/couchapp_04
    curl -X POST -H "Content-Type: application/json" --data @lec.json http://localhost:5984/couchapp_04/_bulk_docs
    couchapp push app_04.js http://localhost:5984/couchapp_04

Wchodzimy na strone:

    http://localhost:5984/couchapp_04/_design/app/_show/quotation/4


## TODO (does not work): Aplikacja 05 z show + szablon Dust

[Dust](http://akdubya.github.com/dustjs/)

Przykład:

    curl -X PUT http://127.0.0.1:5984/couchapp_05
    curl -X POST -H "Content-Type: application/json" --data @lec.json http://localhost:5984/couchapp_05/_bulk_docs
    couchapp push app_05.js http://localhost:5984/couchapp_05

Wchodzimy na strone:

    http://localhost:5984/couchapp_05/_design/app/_show/quotation/4

## Aplikacja 05 – Led Zeppelin

Dwa dokumenty:

    { "docs":
      [
        {
          "_id": "led-zeppelin-ii",
          "title": "Led Zeppelin II",
          "released": "October 22, 1969",
          "songs": ["Whole Lotta Love"]
        },
        {
          "_id": "led-zeppelin-iii",
          "title": "Led Zeppelin III",
          "released": "October  5, 1970",
          "songs": ["Friends","That's the Way"]
        }
      ]
    }

Zapisujemy je w bazie:

    curl -X PUT http://127.0.0.1:5984/couchapp_06
    cd led_zeppelin

    curl -X POST -H "Content-Type: application/json" --data @led_zeppelin.json http://127.0.0.1:5984/couchapp_06/_bulk_docs

Każdy dokument zawiera po jednym załączniku (okładka albumu):

    cover.jpg

Dodajemy załączniki:

    curl -X PUT http://127.0.0.1:5984/couchapp_06/led-zeppelin-ii/cover.jpg?rev=1-... -H "Content-Type: image/jpg" --data-binary @led-zeppelin-ii.jpg
    curl -X PUT http://127.0.0.1:5984/couchapp_06/led-zeppelin-iii/cover.jpg?rev=1-... -H "Content-Type: image/jpg" --data-binary @led-zeppelin-iii.jpg

Wchodzimy na stronę:

    http://localhost:5984/couchapp_06/_design/app/_show/info/led-zeppelin-iii


## GeoCouch

    couchapp push geo.js http://localhost:5984/places
    curl -X POST -H "Content-Type: application/json" --data @geo.json http://127.0.0.1:5984/places/_bulk_docs
    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=0,0,180,90'

Ostatnie zapytanie powinno zwrócić:

    {
      "update_seq":9,
      "rows":[
         {"id":"augsburg",
          "bbox":[10.898333,48.371667,10.898333,48.371667],
          "geometry":{"type":"Point","coordinates":[10.898333,48.371667]},
          "value":["augsburg",[10.898333,48.371667]]}
      ]
    }

Australia & Brasilia:

    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/points?bbox=110,-60,-30,15&plane_bounds=-180,-90,180,90'

Wyniki:

    {
      "update_seq":15,
      "rows":[
         {"id":"australia",
          "bbox":[135,-25,135,-25],
          "geometry":{"type":"Point", "coordinates":[135,-25]},
          "value":["australia",[135,-25]]},
         {"id":"brasilia",
          "bbox":[-52.95,-10.65,-52.95,-10.65],
          "geometry":{"type":"Point", "coordinates":[-52.95,-10.65]},
          "value":["brasilia",[-52.95,-10.65]]}
      ]
    }


### Funkcje listowe

Zapytanie:

    curl -X GET 'http://localhost:5984/places/_design/default/_spatial/_list/wkt/points?bbox=-180,-90,180,90'

powinno zwrócić:

    POINT(-122.270833,37.804444)
    POINT(10.898333,48.371667)
    POINT(135,-25)
    POINT(-52.95,-10.65)
    POINT(17.15,-22.566667)
