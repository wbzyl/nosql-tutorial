#### {% title "Views ≡ Map + Reduce" %}

CouchDB jest dokumentową, a nie relacyjną bazą danych. W relacyjnych
bazach zapisujemy „rekordy”, a w bazach dokumentowych – „obiekty”.
Obiekty mogą zawierać inne obiekty i tablice. Obiekty bardziej niż
rekordy nadają się do modelowania złożonych hierarchicznych związków.

CouchDB jest bezschematową bazą danych. W takich bazach
zapytania SQL, na przykład takie:

    :::sql
    SELECT name, email, fax FROM contacts

nie mają sensu, ponieważ takie zapytanie zakłada, że wszystkie dokumenty
*contacts* muszą zawierać pola *name*, *email* i *fax*.
Dokumenty zapisywane w CouchDB nie muszą być zbudowane według
jednego schematu.

Brak schematu oznacza, że niepotrzebne będą migracje.
Jest to istotne w wypadku dużych baz, dla których migracje
są kosztowne, albo niemożliwe.

{%= image_tag "/images/couch-mapreduce.png", :alt => "[CouchDB MapReduce]" %}
(źródło *@jrecursive*)

W dokumentowych bazach danych zamiast zapytań mamy widoki:
„Views are the primary tool used for querying and reporting on CouchDB
documents.”

Widoki zapisujemy w tak zwanych *design documents*. Design documents
są zwykłymi dokumentami. Tym co je wyróżnia jest identyfikator
zaczynający się od **_design**, na przykład *_design/app*.
Widoki są zapisywane w polu *views* dokumentów projektowych.

Widoki przećwiczymy na przykładzie dokumentowej bazy danych
zawierającej aforyzmy Stanisława J. Leca oraz Hugo Steinhausa
(te same co w rozdziale z *Funkcje Show*).
Dla przypomnienia, format przykładowego dokumentu:

    :::json
    {
      "_id": "1",
      "created_at": [2010, 0, 31],
      "quotation": "Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.",
      "tags": ["wiedza", "nauka", "wszechświat"]
    }

tak tworzymy bazę:

    curl -X PUT http://Admin:Pass@127.0.0.1:5984/lec

a tak zapisujemy hurtem wszystkie cytaty:

    curl -X POST -d @ls.json http://127.0.0.1:5984/ls/_bulk_docs

{%= link_to "Tutaj", "/doc/json/ls.json" %} można pobrać plik *ls.json* użyty powyżej.


## Widoki w CouchDB API

Dla przypomnienia, w CouchDB są dwa rodzaje widoków:

* tymczasowe (*temporary views*)
* permanentne (*permanent views*)

Zaczniemy od zapisania w bazie dwóch widoków: *by_date* i *by_tag*.
W tym celu skorzystam z modułu node *node.couchapp.js*:

    :::javascript ls_views.js
    var couchapp = require('couchapp');
    ddoc = {
        _id: '_design/app'
      , views: {}
      , lists: {}
      , shows: {}
    }
    module.exports = ddoc;

    ddoc.views.by_date = {
      map: function(doc) {
        emit(doc.created_at, doc.quotation.length);
      },
      reduce: "_sum"
    }
    ddoc.views.by_tag = {
      map: function(doc) {
        for (var k in doc.tags)
          emit(doc.tags[k], null);
      },
      reduce: "_count"
    }

Widok zapisujemy w bazie wykonujac polecenie:

    couchapp push ls_views.js http://Admin:Pass@localhost:4000/ls

Tyle przygotowań. Teraz odpytajmy oba widoki z linii poleceń:

    curl http://127.0.0.1:4000/ls/_design/app/_view/by_date
    curl http://127.0.0.1:4000/ls/_design/app/_view/by_tag

W odpowiedzi na pierwsze zapytanie dostajemy listę posortowaną po
trójelementowej tablicy z datą:

    :::json
    {"rows":[
    {"key":null,"value":351}
    ]}

Drugie zapytanie zwraca:

    :::json
    {"rows":[
      {"key": null, "value": 19}
    ]}


## *Querying Options* w widokach

Odpytując widoki możemy doprecyzować jakie dokumenty nas interesują,
dopisując do zapytania *querying options*.
Poniżej, dla wygody, umieściłem ściągę
z [HTTP view API](http://wiki.apache.org/couchdb/HTTP_view_API).

Żądania GET:

* key=*keyvalue*
* startkey=*keyvalue*
* endkey=*keyvalue*
* limit=*max row to return*
* stale=ok
* descending=true
* skip=*number of rows to skip*
* group=true
* group\_level=*integer*
* reduce=false
* include_docs=true
* inclusive_end=true
* startkey_docid=*docid*
* endkey_docid=*docid*

Żądania POST oraz do wbudowanego widoku *_all_docs*:

* {"keys": ["key1", "key2", ...]} – tylko wyszczególnione wiersze widoku

Uwaga: parametry zapytań muszą być odpowiednio cytowane i kodowane.
Jest to uciążliwe. Program *curl* od wersji 7.20 pozwala nam obejść
tę uciążliwość. Należy skorzystać z dwóch opcji `-G` oraz `--data-urlencode`.

Dla przykładu, zapytanie:

    curl http://localhost:4000/ls/_design/app/_view/by_tag -G \
      --data-urlencode startkey='"w"' --data-urlencode endkey='"w\ufff0"' \
      -d reduce=false

zwraca:

    :::json
    {"total_rows":19,"offset":14,"rows":[
      {"id":"1","key":"wiedza","value":null},
      {"id":"5","key":"wn\u0119trze","value":null},
      {"id":"1","key":"wszech\u015bwiat","value":null},
      {"id":"2","key":"wszyscy","value":null}
    ]}

Jeśli to zapytanie wpiszemy w przegladarce, to nie musimy stosować
takich trików z cytowaniem. Wpisujemy po prostu:

    http://localhost:4000/ls/_design/app/_view/by_tag?reduce=false&startkey="w"&endkey="w\ufff0"

(Przeglądarka Chrome sama koduje zapytanie.)

Poniżej podaję „wersję przeglądarkową” zapytań oraz zwracane odpowiedzi:

**key** — dokumenty powiązane z podanym kluczem:

    http://localhost:4000/ls/_design/app/_view/by_date?key=[2010,0,1]&reduce=false
    {"total_rows":8,"offset":1,"rows":[
      {"id":"1","key":[2010,0,1],"value":70},
      {"id":"4","key":[2010,0,1],"value":37}
    ]}

**startkey** — dokumenty od klucza:

    http://localhost:4000/ls/_design/app/_view/by_date?startkey=[2010,0,31]&reduce=false
    {"total_rows":8,"offset":3,"rows":[
      {"id":"8","key":[2010,0,31],"value":34},
      {"id":"2","key":[2010,1,20],"value":55},
      {"id":"6","key":[2010,1,28],"value":27},
      {"id":"7","key":[2010,1,28],"value":67},
      {"id":"5","key":[2010,11,31],"value":31}
    ]}

**endkey** — dokumenty do klucza (wyłącznie):

    http://localhost:4000/ls/_design/app/_view/by_date?endkey=[2010,0,31]&reduce=false
    {"total_rows":8,"offset":0,"rows":[
      {"id":"3","key":[2009,6,15],"value":30},
      {"id":"1","key":[2010,0,1],"value":70},
      {"id":"4","key":[2010,0,1],"value":37},
      {"id":"8","key":[2010,0,31],"value":34}
    ]}

**limit** — co najwyżej tyle dokumentów zaczynając od podanego klucza:

    http://localhost:4000/ls/_design/app/_view/by_date?startkey=[2010,0,31]&limit=2&reduce=false
    {"total_rows":8,"offset":3,"rows":[
      {"id":"8","key":[2010,0,31],"value":34},
      {"id":"2","key":[2010,1,20],"value":55}
    ]}

**skip** – pomiń podaną liczbę dokumentów zaczynając od podanego klucza.

    http://localhost:4000/ls/_design/app/_view/by_date?startkey=[2010,1,20]&skip=2&reduce=false
    {"total_rows":8,"offset":6,"rows":[
      {"id":"7","key":[2010,1,28],"value":67},
      {"id":"5","key":[2010,11,31],"value":31}
    ]}

**include_docs** – dołącz dokumenty do odpowiedzi
(jeśli widok zawiera funkcję reduce, to do zapytania należy dopisać *reduce=false*):

    http://localhost:4000/ls/_design/app/_view/by_date?endkey=[2010]&include_docs=true&reduce=false
    {"total_rows":8,"offset":0,"rows":[
       {"id":"3","key":[2009,6,15],"value":30,
         "doc":{
           "_id":"3",
           "_rev":"5-c460...",
           "created_at":[2009,6,15],
           "quotation":"Za du\u017co or\u0142\u00f3w, za ma\u0142o drobiu.",
           "tags":["orze\u0142","dr\u00f3b"]}}
    ]}

**inclusive_end** – zakres, włącznie.


TODO: Uwaga: opcje **group**, **group_level** oraz **reduce** można użyć tylko
z widokami z funkcją *reduce*.

**Przykład widoku z funkcją map i reduce**

**group** –

    curl http://localhost:4000/ls/_design/app/_view/count?group=true
    {"rows":[
      {"key": [2009,6,15],  "value": 1},
      {"key": [2010,0,1],   "value": 2},
      {"key": [2010,0,31],  "value": 1},
      {"key": [2010,1,20],  "value": 1},
      {"key": [2010,1,28],  "value": 2},
      {"key": [2010,11,31], "value": 1}
    ]}



# View Collation

*Collation* to inaczej kolejność zestawiania, albo schemat uporządkowania.

Poniższy przykład pochodzi z [CouchDB Wiki](http://wiki.apache.org/couchdb/View_collation).

W Futonie tworzymy bazę *coll*:

    :::javascript collation.js
    var cc = require('couch-client');
    var coll = cc("http://localhost:4000/coll");

    for (var i=32; i<=126; i++) {
      coll.save({"x": String.fromCharCode(i)}, function(err, doc) {
        if (err) throw err;
        console.log("saved %s", JSON.stringify(doc));
      });
    };

Na początek, kilka prostych zapytań. Wpisujemy na konsoli:

    curl -X GET http://localhost:4000/coll/_all_docs?startkey=\"64\"\&limit=4
    curl -X GET http://localhost:4000/coll/_all_docs?startkey=\"64\"\&limit=2\&descending=true
    curl -X GET http://localhost:4000/coll/_all_docs?startkey=\"64\"\&endkey=\"68\"

*Uwaga:* W przeglądarce powyższe adresy wpisujemy bez „cytowania“:

    http://localhost:4000/collator/_all_docs?startkey="64"&limit=4
    http://localhost:4000/collator/_all_docs?startkey="64"&limit=2&descending=true
    http://localhost:4000/collator/_all_docs?startkey="64"&endkey="68"

Jeśli odpytujemy widok (tymczasowy; konieczne są uprawnienia Admina):

    curl -X POST http://Admin:Pass@localhost:4000/coll/_temp_view \
      -H "Content-Type: application/json" -d '
    {
      "map": "function(doc) { emit(doc.x); }"
    }'

to zwracana lista dokumentów jest posortowana po kluczu (tutaj, po *doc.x*).
Porządek dokumentów określony jest przez
[unicode collation algorithm](http://www.unicode.org/reports/tr10/).
Dlatego mówimy *view collation*, a nie *view sorting*.


## Co wynika z *Collation Specification*?

W [CouchDB Collaction Specification](http://wiki.apache.org/couchdb/View_collation#Collation_Specification)
opisano jak CouchDB sortuje dokumenty.

TODO: Dodamy, korzystając z node.couchapp.js kilka widoków
i przyjrzymy się bliżej sortowaniu.

**Przykład 1.** Korzystamy z *collation sequence*

    curl http://localhost:4000/ls/_design/app/_view/by_date?startkey='\[2010\]'\&endkey='\[2010,1\]'
    {"total_rows":8,"offset":1,"rows":[
      {"id":"1","key":[2010,0,1],"value":{"summary":"Szerzenie niewiedzy ..."}},
      {"id":"4","key":[2010,0,1],"value":{"summary":"Zdanie to najwi\u0119ksza..."}},
      {"id":"8","key":[2010,0,31],"value":{"summary":"Jedn\u0105 z cech g\u0142upstw..."}}
    ]}

**Przykład 2.** Do widoku **by_date** dodajemy taką oto funkcję reduce:

    :::javascript
    function(keys, values, rereduce) {
      if (rereduce) {
        return sum(values);
      } else {
        return values.length;
      }
    }

Zapisujemy ten widok w **_design/example** pod nazwą **ucount**
(**u** – uniwersalny) i wykonujemy go:

    curl http://localhost:4000/ls/_design/app/_view/ucount?group=true


**Przykład 3.** Korzystamy z *POST*:

    curl -X POST -d '{"keys":["1","8"]}' \
      http://localhost:4000/ls/_all_docs
    curl -X POST -d '{"keys":["1","8"]}' \
      http://localhost:4000/ls/_all_docs?include_docs=true

Albo korzystając z widoku **by_date**:

    curl -X POST -d '{"keys":[[2010,0,1],[2010,0,31]]}' \
      http://localhost:4000/ls/_design/app/_view/by_date
    curl -X POST -d '{"keys":[[2010,0,1],[2010,0,31]]}' \
      http://localhost:4000/ls/_design/app/_view/by_date?include_docs=true

Na czym polegają różnice w otrzymanych wynikach?


### Różne rzeczy

W dokumentacji [HTTP view](http://wiki.apache.org/couchdb/HTTP_view_API):

* Debugowanie widoków
* View Cleanup
* View Compaction



# „Złączenia” w bazach CouchDB

*Przykład:* How you'd go about modeling a simple blogging system with „post” and
„comment” entities, where any blog post might have many comments.

Przykład ten pochodzi z artykułu:
Christopher Lenz. [CouchDB „Joins”](http://www.cmlenz.net/archives/2007/10/couchdb-joins).
W artykule autor omawia trzy sposoby modelowania powiązań
między postami a komentarzami.

TODO: przykład do [CouchDB JOINs Redux](http://blog.couchone.com/post/446015664/whats-new-in-apache-couchdb-0-11-part-two-views).


## Sposób 1: komentarze inline

Utworzymy bazę zawierającą kilka takich dokumentów:

    :::json
    {
      "author": "jacek",
      "title": "Rails 2",
      "content": "Bla bla…",
      "comments": [
        {"author": "agatka", "content": "…"},
        {"author": "bolek",  "content": "…"}
      ]
    }

Dane do umieścimy w bazie za pomocą skryptu
{%= link_to 'blog-inline.rb', '/doc/couchdb/blog-inline.rb' %}.

Widok zwracający wszystkie komentarze, posortowane po polu *author*:

    :::javascript
    function(doc) {
      for (var i in doc.comments) {
        emit(doc.comments[i].author, doc.comments[i].content);
      }
    }

Jakie problemy może dawać takie podejście?
Aby dodać komentarz do posta, należy wykonać:

1. pobrać dokument post z bloga-inline
2. dodać nowy komentarz do struktury JSON
3. umieścić uaktualniony dokument w bazie

W jakim wypadku może to być problematyczne podejście?

To też może być problemem:
„Now if you have multiple client processes adding comments at roughly
the same time, some of them will get a 409 Conflict error on step 3
(that's optimistic concurrency in action).”


## Sposób 2: komentarze w osobnych dokumentach

Utworzymy bazę zawierającą kilka postów postaci:

    :::json
    {
      "_id": "01",
      "type": "post",
      "author": "jacek",
      "title": "Rails 3",
      "content": "Bla bla bla …"
    }

oraz komentarzy postaci:

    :::json
    {
      "_id": "11",
      "type": "comment",
      "post": "01",
      "author": "agatka",
      "content": "…"
    }
    {
      "_id": "12",
      "type": "comment",
      "post": "01",
      "author": "bolek",
      "content": "…"
    }

Dane do umieścimy w bazie za pomocą skryptu
{%= link_to 'blog-separate.rb', '/doc/couchdb/blog-separate.rb' %}.

Poniższy widok, wypisuje komentarze zgrupowane po polu *post*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.post, {author: doc.author, content: doc.content});
      }
    }

Widok ten po zapisaniu jako design document o nazwie **blog**
i o view name – **by_post** wywołujemy z wiersza poleceń:

    curl http://localhost:4000/blog-separate/_design/blog/_view/by_post

Albo tak, jeśli zamierzamy pobrać wszystkie komentarze do posta "02":

    curl http://localhost:4000/blog-separate/_design/blog/_view/by_post?key=\"02\"
    {"total_rows":7,"offset":2,"rows":[
    {"id":"13","key":"02","value":{"author":"lolek","content":"\u2026"}},
    {"id":"14","key":"02","value":{"author":"bolek","content":"\u2026"}}
    ]}

Albo tak:

    curl http://localhost:4000/blog-separate/_design/blog/_view/by_post?key='"02"'

Ech, to cytowanie w powłoce…

Przeglądanie wszystkich komentarzy posrtowanych po
polu *author*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.author, {post: doc.post, content: doc.content});
      }
    }

Po zapisaniu widoku pod nazwą *by_author*, wykonujemy go z wiersza poleceń:

    curl http://localhost:4000/blog-separate/_design/blog/_view/by_author

Przechowywanie osobno postów i komentarzy do nich też ma wady:

„Imagine you want to display a blog post with all the associated
comments on the same web page. With our first approach, we needed
just a single request to the CouchDB server, namely a GET request to
the document. With this second approach, we need two requests: a GET
request to the post document, and a GET request to the view that
returns all comments for the post.”


## Optymizacja: using the power of view collation

What we'd probably want then would be a way to join the blog post and
the various comments together to be able to retrieve them with
**a single HTTP request**.

    :::javascript
    function(doc) {
      if (doc.type == "post") {
        emit([doc._id, 0], doc);
      } else if (doc.type == "comment") {
        emit([doc.post, 1], doc);
      }
    }

Jak to działa? Po zapisaniu widoku jako *\_design/blog/\_view/povc*
wywołujemy go tak:

    curl http://localhost:4000/blog-separate/_design/blog/_view/povc?key='\["02",0\]'
    curl http://localhost:4000/blog-separate/_design/blog/_view/povc?key='\["02",1\]'

albo tak:

    curl http://localhost:4000/blog-separate/_design/blog/_view/povc?startkey='\["02"\]'\&endkey='\["03"\]'

Ostatnie wywołanie zwraca nam post o *id* równym "02"
i wszystkie jego komentarze w jednym żądaniu HTTP.
