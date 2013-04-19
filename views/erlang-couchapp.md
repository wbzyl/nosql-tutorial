#### {% title "Erlang ← Erica" %}

*Erica* to program napisany w języku Erlang ułatwiający
zapisywanie *design documents* w bazach CouchDB.
Erica ułatwia też tworzenie aplikacji webowych korzystających
z bazy CouchDB. Co więcej, zawiera prosty interfejs webowy
do edycji aplikacji.

Autorem programu [Erica](https://github.com/benoitc/erica)
jest Benoit Chesneau. Wiki pojawi się wkrótce.
Na razie te linki powinny nam wystarczyć:

- [Filesystem Mapping](http://couchapp.org/page/filesystem-mapping)
- [Getting Started](http://www.couchapp.org/page/getting-started)
- Darwin Biler,
  [Couchapp push testdb: You are not a server admin error](http://www.darwinbiler.com/couchapp-push-testdb-you-are-not-a-server-admin-error/)
- [Using couchapp with multiple design documents](http://couchapp.org/page/multiple-design-docs)


## Zapisywanie danych w bazie

W bazie *cities* zapiszemy miasta z pliku
[cities.json](https://github.com/nosql/data-refine/tree/master/data/json) (39336 miast).<br>
Dane te zapiszemy hurtem korzystając
z [_bulk_docs](http://localhost:5984/_utils/docs/api/database.html#post-db-bulk-docs).

Dokumenty zapisywane hurtem muszą być umieszczone w tablicy
przypisanej do pola *docs*:

    :::json
    {
      "docs": [
         {"country_id":197,"loc":[18.667,54.35],"code":"GDAN","time_zone":"+01:00","city":"Gdansk"},
         {"country_id":197,"loc":[18.55,54.5],"code":"GDYN","time_zone":"+01:00","city":"Gdynia"}
      ]
    }

Ale w pliku *cities.json* dokumenty są zapisane po jednym w wierszu:

    :::json
    {"country_id":197,"loc":[18.667,54.35],"code":"GDAN","time_zone":"+01:00","city":"Gdansk"}
    {"country_id":197,"loc":[18.55,54.5],"code":"GDYN","time_zone":"+01:00","city":"Gdynia"}

Za pomocą programu [sed](http://stackoverflow.com/questions/947404/sed-line-range-all-but-the-last-line),
można w prosty sposób przekształcić dane do wymaganego formatu:

    :::bash
    (echo '{"docs":[' ; cat cities.json | sed '$ ! s/$/,/' ; echo ']}' ) > cities.json.bulk

(Zobacz też [Unix Sed Tutorial: Append, Insert, Replace, and Count File Lines](http://www.thegeekstuff.com/2009/11/unix-sed-tutorial-append-insert-replace-and-count-file-lines/).)

Ale jeszcze prościej przekształca się dane za pomocą programu
[jq](https://github.com/stedolan/jq):

    :::bash
    cat cities.json | jq -s '{ docs: . }' > cities.json.bulk

Pozostaje utworzyć bazę *cities*:

    :::bash
    curl -X PUT localhost:5984/miasta

i zapisać w niej dane z pliku *cities.json.bulk*:

    :::bash
    curl -X POST -H "Content-Type: application/json" -d @cities.json.bulk localhost:5984/miasta/_bulk_docs


<blockquote>
 <p>{%= image_tag "/images/erica-couch.jpg", :alt => "[Erica Couch]" %}</p>
</blockquote>

# Erica

So need to make and mange design docs for couchdb?

    :::bash
    erica -c
    erica create-app appid=miasta

    tree miasta
      miasta/
      |-- .couchapprc
      |-- _attachments
      |-- _id
      |-- language
      |-- lists
      |-- shows
      `-- views
          `-- by_type
              `-- map.js

     cat miasta/_id
       _design/miasta

Usuwamy katalog *by_type* i w odpowiednich katalogach
zapisujemy pliki *info.js*, *map.js* i *reduce.js*:

    |-- shows
    |   `-- info.js
    `-- views
        `-- stat
            |-- map.js
            `-- reduce.js

Zawartość pliku *info.js*:

    :::js shows/info.js
    function(doc, req) {
      return {
        headers: { "Content-Type": "text/plain" },
        body: "city: " + doc.city + "\ncountry_id: " + doc.country_id + "\n"
      };
    };

pliku *map.js*:

    :::js views/stat/map.js
    function map(doc) {
      // log(toJSON(doc.city) + ": " + toJSON(doc.country_id));
      if (doc.country_id) {
        emit(doc.country_id, null);
      }
    }

pliku *reduce.js*:

    :::js views/stat/reduce.js
    _count

Po wpisaniu kodu funkcji, zapiszemy je w bazie *miasta*:

    :::bash
    erica push http://localhost:5984/miasta

Teraz możemy wykonać funkcję show, np. w taki sposób:

    :::bash
    curl -q localhost:5984/miasta/_design/miasta/_show/info/3c829a6e4ee216ded0ae1d7e2600c3d3
    curl -v localhost:5984/miasta/_design/miasta/_show/info/3c829a6e4ee216ded0ae1d7e2600c3d3

gdzie `3c829a6e4ee216ded0ae1d7e2600c3d3` to *id* istniejącego w bazie dokumentu.

Widoki MapReduce uruchamiamy tak:

    :::bash
    curl localhost:5984/miasta/_design/miasta/_view/stat
    curl localhost:5984/miasta/_design/miasta/_view/stat?group_level=1
    curl localhost:5984/miasta/_design/miasta/_view/stat?key=197

Musimy chwilę poczekać, aż widok *stat* zostanie wyliczony (kilkanaście sekund):

    :::js
    {"rows":[
      {"key" : null, "value" : 39336}
    ]}

Następne polecenia z *curl* zwracają wyniki praktycznie natychmiast.

Jeśli uruchomimy webowy UI:

    :::bash
    erica web

to będziemy mogli edytować pliki show, views, lists i dodawać załączniki.

Zazwyczaj po edycji zapisujemy zmiany w CouchDB:

    :::bash
    erica push http://localhost:5984/miasta


## Załączniki – Miles Davis

Oto przykład z załącznikami:

    :::bash
    curl -X PUT localhost:5984/miles_davis

    erica create-app appid=miles_davis
    cd miles_davis
    cp ...so_what.ogg _attachments/
    touch _attachments/index.html

Zawartość pliku *index.html*:

    :::html _attachments/index.html
    <!doctype html public "♥♥♥">
    <html lang=pl>
      <head>
        <meta charset=utf-8>
        <title>Miles Davis</title>
        <style>
          body { margin: 2em; background: #E2DF9A; }
        </style>
      </head>
      <body>
        <h3>So what?</h3>
        <audio src="so_what.ogg" controls>
          <a href="so_what.ogg">Download song</a>
        </audio>
      </body>
    </html>

Erica:

    :::bash
    erica push miles_davis
    ==> miles_davis (push)
    ==> Successfully pushed. You can browse it at:
        http://127.0.0.1:5984/miles_davis/_design/miles_davis/index.html

**Uwaga:** Do konwersji z formatu MP3 na OGG użyłem programu
*soundconverter*.
