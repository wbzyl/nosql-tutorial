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

W katalogu *show* tworzymy plik *aye.js* o zawartości:

    :::js
    function(doc, req) {
      return {
        headers: { "Content-Type": "text/plain" },
        body: "Aye aye: " + req.query["q"] + "!\n"
      };
    };

Po wpisaniu kodu funkcji, zapiszemy ją w bazie:

    :::bash
    erica push http://localhost:5984/miasta

Funkcja show zostanie zapisana w *_design/miasta* w bazie *miasta*.

Możemy wykonać funkcję show, np. w taki sposób:

    :::bash
    curl -q localhost:5984/miasta/_design/miasta/_show/aye/x?q=Captain
    curl -v localhost:5984/miasta/_design/miasta/_show/aye/x?q=Captain

Jeśli uruchomimy webowy UI:

    :::bash
    erica web

to będziemy mogli edytować pliki show, views, lists i dodawać attachments.

Zazwyczaj po edycji zapisujemy zmiany w CouchDB:

    :::bash
    erica push http://localhost:5984/miasta
