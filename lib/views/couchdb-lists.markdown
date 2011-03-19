#### {% title "Funkcje listowe" %}

Do czego będziemy używać tych funkcji:
„Just as show functions convert documents to arbitrary output formats,
CouchDB list functions allow you to render
**the output of *view queries* in any format.**”

Prosty przykład znajdziemy tutaj.

* [Formatting with Show and List](http://wiki.apache.org/couchdb/Formatting_with_Show_and_List)

Tak wygląda ta prosta funkcja listowa:

    :::javascript
    function(head, req) {
      var row;
      start({
        "headers": {
          "Content-Type": "text/html"
         }
      });
      while(row = getRow()) {
        send(row.value);
      }
    }


Funkcje listowe konwertują widoki, dlatego aby wypróbować tę funkcję
potrzebujemy jeszcze jakiejś bazy z widokiem, na przykład bazy *ls*
z widokiem:

    :::javascript
    function(doc) {
      emit(null, doc);
    }


Poniższe wywołanie zwraca treść cytatów (coś lepszego, dorzucić opcje zapytania):

    /db/_design/foo/_list/list-name/view-name
    curl -X GET http://localhost:5984/ls/_design/lists/_list/body/all?tag=wiedza

Dorzucić:

* [On _designs undocumented](http://caolanmcmahon.com/posts/commonjs_modules_in_couchdb#/posts/on__designs_undocumented/uid%3D738)
* [CommonJS modules in CouchDB](http://caolanmcmahon.com/posts/commonjs_modules_in_couchdb#/posts/commonjs_modules_in_couchdb)
* [View Snippets](http://wiki.apache.org/couchdb/View_Snippets)
* [CouchDB: Using List Functions to sort Map/Reduce-Results by Value](http://geekiriki.blogspot.com/2010/08/couchdb-using-list-functions-to-sort.html)

Dodać coś o programowaniu list po stronie klienta.

Dla przykładu, rozważmy widok *all* i funkcje list *body*:

Zależność między: list a view – jeden do wielu; ale w przykładach ponizej będziemy
pisać funkcję list pod konkretny widok. Dlatego zaczynamy od widoku.

TODO: użyć node.couchapp.js (co będzie jak dodamy funkcję reduce):

Funkcja list:

    "lists": {
      "body": "function(head, req) {
         log(head); // info o widoku
         log(req);  // już było, ale wkleić poniżej i omówić
         var row;   // czym jest row?
         send( jakiś nagłówek );
         while (row=getRow()) {
           send(row.value.body + '\\n');

     }


Przykład wykonania: jak / curl / przeglądarka.


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

Przydadzą się też dwie funkcje: *JSON.stringify* i *JSON.parse*.


Coś prostego [Beauty of Code](http://beauty-of-code.de/2010/07/complex-joins-in-couchdb/),
[Collating (not reducing) with CouchDB List Functions](http://japhr.blogspot.com/2010/02/collating-not-reducing-with-couchdb.html)
– a gdzie przykład z reducing?


TODO: dodać szablon mustache.



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
