#### {% title("Lists", false) %}

# Lists – potęga znaczników HTML

Funkcja *getRow()* jest opisana w
[render.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/render.js?view=markup).

**Przykład:** Widok *all* zostanie użyty z list function *body* poniżej:

    :::json
    {
      "views": {
        "all": {
          "map": "function(doc) { emit(null, doc); }"
        }
      },
      "lists": {
        "body": "function(head, req) {
           var row;
           while (row=getRow()) {
             send(row.value.body + '\\n');
           }
        }"
      }
    }

Powyższy obiekt JSON wklejamy do pliku *list.json* i zapisujemy go w bazie *lec*:

    curl -X PUT "http://localhost:5984/lec/_design/lists" \
       -H "Content-Type: application/json" -d @list.json

Teraz poniższe wywołanie zwaraca treść cytatów:

<pre>curl -X GET http://localhost:5984/lec/_design/lists/_list<b>/body/all</b>
    => Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.
       Wszyscy chcą naszego dobra. Nie dajcie go sobie zabrać.
       ...
</pre>


## Więcej przykładów

Pobieramy [źródła CouchDB](http://couchdb.apache.org/community/code.html)
i w katalogu *share/www/script/test* znajdziemy dużo przykładów:

* show_documents.js
* list_views.js
* …???

Zobacz też:

* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)
