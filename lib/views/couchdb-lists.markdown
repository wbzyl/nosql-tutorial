#### {% title("Funkcje Lists") %}

„Just as show functions convert documents to arbitrary output formats,
CouchDB list functions allow you to render the output of view queries
in any format.”

Dla przykładu, rozważmy widok *all* i funkcje list *body*:


TODO: użyć node.couchapp.js:

    :::json
    {
      "views": {
        "all": {
          "map": "function(doc) { emit(null, doc); }"
        }
      },

Funkcja list:

    "lists": {
      "body": "function(head, req) {
         log(head); // info o widoku
         log(req); // już było, ale wkleić poniżej i omówić
         var row;
         send( jakiś nagłówek );
         while (row=getRow()) {
           send(row.value.body + '\\n');

     }

Opis z bloga C. McMahona, [On _design undocumented](http://caolanmcmahon.com/posts/on__designs_undocumented):

* **start** – sets the response headers to send from a list
  function. These are sent on the first call to *getRow()*. Therefore
  you cannot call start after *getRow()*, even if you only send data
  after getting all rows.
* **send** – sets a chunk of response data to be sent on the next call
  to *getRow()*, or at the end of the list functions execution.
* **getRow** – returns the next row from the view or null if there are
  no more rows. On the first call to get row, the headers set by
  *start()* are sent, on subsequent calls the data chunks set by *send()*
  are sent.

Poniższe wywołanie zwraca treść cytatów (coś lepszego, dorzucić opcje zapytania):

    /db/_design/foo/_list/list-name/view-name
    curl -X GET http://localhost:5984/ls/_design/lists/_list/body/all?tag=wiedza

TODO: dodać szablon mustache.


## Zliczanie słów & generator przemówień

Omówić przykład z katalogu *couch/word-count*.


## Sinatra & Couchrest

* [A basic CouchDB/Sinatra wiki](http://github.com/benatkin/weaky)


## Więcej przykładów

Pobieramy [źródła CouchDB](http://couchdb.apache.org/community/code.html)
i w katalogu *share/www/script/test* znajdziemy dużo prostych przykładów:

* *show_documents.js*
* *list_views.js*

Zobacz też:

* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)
* [render.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/render.js?view=markup)
  (zawiera opis funkcji *getRow()*)
