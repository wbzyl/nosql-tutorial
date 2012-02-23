#### {% title "GeoCouch" %}

Zaczniemy od prostego przykładu z funkcją *spatial*
dla [GeoCouch](https://github.com/couchbase/geocouch).

Zaczynamy od utworzenia bazy *places*:

    :::bash
    curl -X PUT http://127.0.0.1:5984/places

i zapisania w niej współrzędnych kilku miejsc.
Dane zapiszemy hurtem w bazie:

    :::bash
    curl -X POST -H "Content-Type: application/json" --data @places.json http://localhost:5984/places/_bulk_docs

Link do użytego powyżej pliku {%= link_to "places.json", "/node/db/places.json" %}.

Do zapisania funkcji spatial oraz funkcji listowej użyjemy prostego skryptu
oraz programu *couchapp*:

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

    http://localhost:5984/tatry/717a1e4c809daa85f957863e070014c1w

Oto wynik:

    :::json
    {
        _id: "717a1e4c809daa85f957863e070014c1",
        _rev: "1-e3f7e43e154f263194d4bedca630039c",
        owner: "25196109@N06",
        secret: "2ef3dbeb20",
        server: "7064",
        farm: 8,
        title: "Panorama in der Hohen Tatra",
        accuracy: "16",
        place_id: "WwoSYGxUUrm4yzs",
        woeid: "503425",
        geometry: {
          type: "Point",
          coordinates: [
            19.925261,
            49.246743
          ]
        },
        image_url_medium: "http://farm8.static.flickr.com/7064/6912045953_2ef3dbeb20_m.jpg"
    }

Po przeklikaniu powyższego url zobaczymy fajne zdjęcie.
A na stronie:

    http://www.flickr.com/services/api/explore/flickr.places.getInfo

możemy przeklikać *place_id*, aby dowiedzieć się co to za miejsce.

Spatial view:

    :::js flickr.js
    var couchapp = require('couchapp');

    ddoc = {
      _id: '_design/photos'
      , views:   {}
      , lists:   {}
      , shows:   {}
      , spatial: {}
    }
    module.exports = ddoc;

    ddoc.spatial.points = function(doc) {
      if (doc.title) {
        emit(doc.geometry, {title: doc.title, image: doc.image_url_medium});
      };
    };

Przykładowe zapytanie:

    :::bash
    http://localhost:5984/tatry/_design/photos/_spatial/points?bbox=0,0,180,90&limit=2

Dopisujemy funkcję listową:

    :::js
    ddoc.lists.wkt = function(head, req) {
      var row;
      start({
        "headers": { "Content-Type": "text/html" }
      });
      while (row = getRow()) {
        // log(JSON.stringify(row));
        send("<p><a href='" + row.value.image + "'>" + row.value.title + "</a>\n" );
      };
    };

Przykładowe zapytanie:

    http://localhost:5984/tatry/_design/photos/_spatial/_list/wkt/points?bbox=0,0,180,90
