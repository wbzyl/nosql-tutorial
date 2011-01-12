#### {% title("Show", false) %}

# Show – potęga znaczników HTML

Jeśli jeszcze tego nie zrobiliśmy, to tworzymy bazę *lec*
i dodajemy do niej dokumenty z pliku *lec.json*:

    curl -X PUT  http://127.0.0.1:5984/lec
    curl -X POST http://127.0.0.1:5984/lec/_bulk_docs -d @lec.json

(plik {%= link_to "lec.json", "/doc/couchdb/lec.json" %})

Funkcję **body** zapisujemy w pliku o nazwie *body.json*:

    :::json
    {
      "shows" : {
        "body" : "function(doc, req) { return '<p>' + doc.body + '</p>\\n'; }" }
    }

Zapisujemy funkcję *body* jako *shows* w bazie *lec*:

     curl -X PUT http://localhost:5984/lec/_design/shows \
       -H "Content-Type: application/json" -d @body.json
     => {"ok":true,"id":"_design/shows","rev":"1-84c5"}

Tak, z wiersza poleceń, wywołujemy funkcję *body*:

    curl http://localhost:5984/lec/_design/shows/_show/body/1

albo, po prostu, wchodzimy na stronę:

    http://localhost:5984/lec/_design/shows/_show/body/1

**Uwaga:** `1` na końcu URI odnosi się do aforyzmu z id równym jeden.

### Za & przeciw

Pisanie funkcji *shows* za bardzo przypomina programowanie CGI.
Przydałyby się jakieś szablony. Niestety takich szablonów
nie ma in nie będzie. Dlaczego?

Poza tym idea *shows* jest OK?

**Uwaga**. Od wersji 1.0 możemy korzystać z szablonów.
Przykład:

    :::javascript
    function(doc, req) {
      var Mustache = require('vendor/couchapp/lib/mustache');
      var data = {
        title: "Joe",
        calc: function() {
          return 2 + 2;
        }
      };
      var template = "{{title}} spends {{calc}}";
      return Mustache.to_html( template, data );
    }

Sprawdzić!


### Przekazywanie parametrów do *shows*

Zobacz [Query Parameters](http://books.couchdb.org/relax/design-documents/shows)
oraz [main.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/)
(plik *main.js* powstaje ze sklejenia wszystkich plików w tym katalogu;
najciekawsze rzeczy są w pliku *render.js*, *views.js*).

Opis obiektów JSON *Request* oraz *Response* znajdziemy na CouchDB Wiki
[External Processes](http://wiki.apache.org/couchdb/ExternalProcesses).

Dla przykładu, do takiej funkcji *shows*:

    :::javascript
    {
      "shows" : {
        "aye" : "function(doc, req) {
           return '<h2>Aye aye: ' + req.query['q'] + '</h2><p>' + doc.body + '</p>';
        }"
      }
    }

przekazujemy parametr **q** w żądaniu tak:

    http://localhost:5984/lec/_design/shows/_show/aye/1?q=Captain
    => Aye aye, Captain
       Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.


## Więcej przykładów

Pobieramy [źródła CouchDB](http://couchdb.apache.org/community/code.html)
i w katalogu *share/www/script/test* znajdziemy dużo przykładów:

* show_documents.js
* list_views.js
* …???

Zobacz też:

* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)
