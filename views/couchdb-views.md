#### {% title "Widok ≡ Map+Reduce" %}

Definicja z Wikipedii: „MapReduce jest opatentowaną przez Google
platformą do przetwarzania równoległego dużych zbiorów danych
w klastrach komputerów.”
CouchDB ma swoją wersję platformy MapReduce
(a MongoDB swoją). Przyjrzyjmy się jak zaimplementowano
MapReduce w CouchDB.

## Luźne uwagi o SQL i MapReduce

CouchDB jest dokumentową, a nie relacyjną bazą danych. W relacyjnych
bazach zapisujemy „rekordy”, w bazach dokumentowych – „obiekty”.
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
*Bonus:* brak schematu oznacza, że niepotrzebne będą migracje,
co jest istotne w wypadku dużych baz, dla których migracje
są kosztowne, albo niemożliwe.

{%= image_tag "/images/couch-mapreduce.png", :alt => "[CouchDB MapReduce]" %}
(źródło *@jrecursive*)

W CouchDB zamiast zapytań mamy widoki:
„Views are the primary tool used for querying and reporting on CouchDB
documents.” Widoki kodujemy zazwyczaj w Javascript albo Erlangu
(ale możemy je też programowac w Ruby, Pythonie).

Widoki zapisujemy w tak zwanych *design documents*. Design documents
są zwykłymi dokumentami. Tym co je wyróżnia jest identyfikator
zaczynający się od **_design/**, na przykład *_design/default*.
Widoki zapisujemy w polu *views* dokumentów projektowych.


## Baza *ls*

Widoki przećwiczymy na przykładzie bazy *ls*
zawierającej kilka aforyzmów Stanisława J. Leca oraz Hugo Steinhausa
(te same co w rozdziale z *Funkcje Show*).
Dla przypomnienia, format przykładowego dokumentu:

    :::json
    {
      "_id": "1",
      "created_at": [2010, 0, 31],
      "quotation": "Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.",
      "tags": ["wiedza", "nauka", "wszechświat"]
    }

Bazę (16 dokumentów + 1 dokument _design) replikujemy z mojego serwera
[couch](http://couch.inf.ug.edu.pl/_utils/database.html?ls).
Zakładam, że zreplikowaną bazę nazwano *ls*:

    :::
    (remote) http://couch.inf.ug.edu.pl/ls -> (local) ls


## Widok ≈ Map + Reduce (opcjonalne)

W CouchDB są dwa rodzaje widoków:

* tymczasowe (*temporary views*)
* permanentne (*permanent views*)

Tymczasowe widoki będziemy pisać i odpytywać w Futonie, a do widoków
permanentnych wykorzystamy *node.couchapp.js*.

Widok w CouchDB składa się z dwóch, kolejno wykonywanych, funkcji:

* `map(doc)` – funkcja wykonywana jest na każdym dokumencie
  rezultatem każdego wywołania funkcji powinno być
  „do nothing” albo „*emit(key,value)*”
* `reduce(keys,values,rereduce)` – wywołanie tej funkcji
  poprzedza tzw. „shuffle step”:
  *keys* i *values* są sortowane i grupowane; po wykonaniu
  „shuffle step” argument *rereduce* ustawiany jest na *false*,
  *keys* na *null* i funkcja jest wykonywana tyle razy aż *values*
  zostaną zredukowane do pojedynczego *value*

Zobacz też przykłady zapytań z *group* i *group_level* poniżej.

Zaczynamy od utworzenia szablonu aplikacji za pomocą programu
[erica](https://github.com/benoitc/erica):

    :::bash
    erica create-app appid=ls lang=javascript
      ==> Couch (create-app)
      Writing ls/_id
      Writing ls/language
      Writing ls/.couchapprc
      Writing ls/views/by_type/map.js

W katalogu *ls/views* zapiszemy dwa widoki: *by_date*.

*map.js*:

    :::js by_date/map.js
      function(doc) {
        emit(doc.created_at, doc.quotation.length);
      },
      reduce: "_sum"
    }

*reduce.js*:

    :::js by_date/reduce.js
    _sum

i usuwamy wygenrowany vidok *by_type/map.js*.

Powyżej użyłem funkcji reduce napisanych w języku Erlang
i dostępnych w widokach pisanych w Javascript.
W wersji 1.1.x CouchDb są trzy takie funkcje:

* `_count` – zwraca liczbę „mapped values”
* `_sum` – zwraca sumę wartości „mapped values”
* `_stats` – zwraca statystyki „mapped values” (sum, count, min, max, …)

TODO: przykładowa implementacja *_sum* w Javascripcie.

Widok zapiszemy w bazie wykonujac polecenie:

    :::bash
    couchapp push ls_views.js http://localhost:5984/ls

Tyle przygotowań. Teraz zabierzemy się za odpytywanie widoków.

    :::bash
    curl http://localhost:5984/ls/_design/app/_view/by_date
    {"rows":[
      {"key": null, "value": 351}
    ]}

    curl http://localhost:5984/ls/_design/app/_view/by_tag
    {"rows":[
      {"key": null, "value": 19}
    ]}

Co oznaczają te odpowiedzi? Jak konstruujemy te uri?
Jak zmienią się odpowiedzi, gdy wymienimy funkcję reduce na *_sum*?


Jeszcze jeden widok *by_tag*:

    map: function(doc) {
      for (var k in doc.tags)
        emit(doc.tags[k], null);
    },
    reduce: "_count"



## Map&#x200a;►Reduce + opcje w zapytaniach

Odpytując widoki możemy doprecyzować co nas interesuje,
dopisując do zapytania *querying options*.
Poniżej, dla wygody, umieściłem ściągę z opcji
z [HTTP view API](http://wiki.apache.org/couchdb/HTTP_view_API).

Dla żądań GET:

* `key`=*keyvalue*
* `startkey`=*keyvalue*
* `endkey`=*keyvalue*
* `limit`=*max row to return*
* `stale`=ok
* `descending`=true
* `skip`=*number of rows to skip*
* `group`=true
* `group_level`=*integer*
* `reduce`=false
* `include_docs`=true
* `inclusive_end`=true
* `startkey_docid`=*docid*
* `endkey_docid`=*docid*

Dla żądań POST oraz do wbudowanego widoku *_all_docs*:

* {"keys": ["key1", "key2", ...]} – tylko wyszczególnione wiersze widoku

Uwaga: parametry zapytań muszą być odpowiednio cytowane i kodowane.
Jest to uciążliwe. Program *curl* od wersji 7.20 pozwala nam nieco obejść
tę uciążliwość. Należy skorzystać z dwóch opcji `-G` oraz `--data-urlencode`.

Dla przykładu, zapytanie:

    :::bash
    curl http://localhost:5984/ls/_design/app/_view/by_tag -G \
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

Jeśli to zapytanie wpiszemy w przeglądarce, to nie musimy stosować
takich trików z cytowaniem. Wpisujemy po prostu:

    http://localhost:5984/ls/_design/app/_view/by_tag?reduce=false&startkey="w"&endkey="w\ufff0"

(Na przykład przeglądarka Chrome sama koduje zapytanie.)

Poniżej podaję „wersję przeglądarkową” zapytań oraz zwracane odpowiedzi:

**key** — dokumenty powiązane z podanym kluczem:

    http://localhost:5984/ls/_design/app/_view/by_date?key=[2010,0,1]&reduce=false
    {"total_rows":8,"offset":1,"rows":[
      {"id":"1","key":[2010,0,1],"value":70},
      {"id":"4","key":[2010,0,1],"value":37}
    ]}

**startkey** — dokumenty od klucza:

    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2011,2]&reduce=false
    {"total_rows":16,"offset":13,"rows":[
      {"id":"11","key":[2011,2,10],"value":55},
      {"id":"12","key":[2011,2,10],"value":89},
      {"id":"13","key":[2011,2,10],"value":41}
    ]}
    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2011,2]&reduce=true
    {"rows":[
      {"key":null,"value":185}
    ]}

**endkey** — dokumenty do klucza (wyłącznie):

    http://localhost:5984/ls/_design/app/_view/by_date?endkey=[2010,0,31]&reduce=false
    {"total_rows":8,"offset":0,"rows":[
      {"id":"3","key":[2009,6,15],"value":30},
      {"id":"1","key":[2010,0,1],"value":70},
      {"id":"4","key":[2010,0,1],"value":37},
      {"id":"8","key":[2010,0,31],"value":34}
    ]}

**limit** — co najwyżej tyle dokumentów zaczynając od podanego klucza:

    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2010,0,31]&limit=2&reduce=false
    {"total_rows":16,"offset":3,"rows":[
      {"id":"8","key":[2010,0,31],"value":34},
      {"id":"9","key":[2010,0,31],"value":60}
    ]}

ale *limit* z *reduce* się nie lubią:

    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2010,0,31]&limit=2&reduce=true
    {"rows":[
      {"key":null,"value":651}
    ]}
    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2010,0,31]
    {"rows":[
      {"key":null,"value":651}
    ]}

**skip** – pomiń podaną liczbę dokumentów zaczynając od podanego klucza:

    http://localhost:5984/ls/_design/app/_view/by_date?startkey=[2010,1,20]&skip=2&reduce=false
    {"total_rows":8,"offset":6,"rows":[
      {"id":"7","key":[2010,1,28],"value":67},
      {"id":"5","key":[2010,11,31],"value":31}
    ]}

**include_docs** – dołącz dokumenty do odpowiedzi
(jeśli widok zawiera funkcję reduce, to do zapytania należy dopisać *reduce=false*):

    http://localhost:5984/ls/_design/app/_view/by_date?endkey=[2010]&include_docs=true&reduce=false
    {"total_rows":8,"offset":0,"rows":[
       {"id":"3","key":[2009,6,15],"value":30,
         "doc":{
           "_id":"3",
           "_rev":"5-c460...",
           "created_at":[2009,6,15],
           "quotation":"Za du\u017co or\u0142\u00f3w, za ma\u0142o drobiu.",
           "tags":["orze\u0142","dr\u00f3b"]}}
    ]}

**inclusive_end** – jak wyżej, ale włącznie.

Uwaga: opcji **group**, **group_level** oraz **reduce** mają sens tylko
dla widoków z funkcją *reduce*.

**group** — grupowanie, działa analogiczne do *GROUP BY* z SQL:

    http://localhost:5984/ls/_design/app/_view/by_date?group=true
    {"rows":[
      {"key":[2009,6,15],"value":30},
      {"key":[2010,0,1],"value":107},
      {"key":[2010,0,31],"value":94},
      {"key":[2010,1,20],"value":55},
      {"key":[2010,1,28],"value":94},
      {"key":[2010,3,1],"value":103},
      {"key":[2010,3,4],"value":32},
      {"key":[2010,11,31],"value":31},
      {"key":[2011,1,12],"value":57},
      {"key":[2011,2,10],"value":185}
    ]}

**group_level** – dwa przykłady powinny wyjaśnić o co chodzi:

    http://localhost:5984/ls/_design/app/_view/by_date?group_level=1
    {"rows":[
      {"key":[2009],"value":30},
      {"key":[2010],"value":516},
      {"key":[2011],"value":242}
    ]}
    http://localhost:5984/ls/_design/app/_view/by_date?group_level=2
    {"rows":[
      {"key":[2009,6],"value":30},
      {"key":[2010,0],"value":201},
      {"key":[2010,1],"value":149},
      {"key":[2010,3],"value":135},
      {"key":[2010,11],"value":31},
      {"key":[2011,1],"value":57},
      {"key":[2011,2],"value":185}
    ]}


## Kanoniczny przykład

Na Sigmie jest baza *gutenberg* zawierająca ok. 22&#x200a;000
akapitów z kilkunastu książek pobranych
z [Files Repository](http://www.gutenberg.org/files/)
projektu Gutenberg.

Do pobierania tekstu, podziału go na akpity i zapisaniu
ich w bazie użyto skryptu
{%= link_to "gutenberg2couchdb.rb", "/mapreduce/couch/gutenberg2couchdb.rb" %}
({%= link_to "źródło", "/doc/couchdb/db/gutenberg2couchdb.rb" %}).

A teraz obiecany kanoniczny przykład użycia MapReduce:

    :::javascript wc.js
    var couchapp = require('couchapp');
    ddoc = {
        _id: '_design/app'
      , views: {}
    }
    module.exports = ddoc;

    ddoc.views.wc = {
      map: function(doc) {
        var words = doc.text.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g);
        words.forEach(function(word) {
          emit([word, doc.title], 1);
        });
      },
      reduce: "_sum"
    }

**Uwaga:** zakres `\u00C0-\u01fF` obejmuje następujące litery
z [Unicode 6.0 Character Code Charts](http://www.unicode.org/charts/):

* [Latin-1 Suplement](http://www.unicode.org/charts/PDF/U0080.pdf)
* [Latin Extended-A](http://www.unicode.org/charts/PDF/U0100.pdf)
  (tutaj są polskie diakrytyki).

Zapisujemy widoki w bazie:

    :::bash
    couchapp push wc.js http://Admin:Pass@localhost:5984/gutenberg

Odpytujemy widok *wc* w Futonie.
Eksperymentujemy z różnymi ustawieniami **Grouping** oraz **Reduce**.

Jeśli w kodzie widoku zmienimy wiersz z *emit* na:

    :::javascript
    emit([word, doc.title], 1);

to co to zmienia?

*Uwaga:* Przy pierwszym zapytaniu CouchDB generuje widok.
Na szybkim komputerze trwa to co najmniej minutę.


# View Collation

*Collation* to kolejność zestawiania, albo schemat uporządkowania.

Widoki są zestawiane/sortowane po zawartości pola *key*.

W [Collaction Specification](http://wiki.apache.org/couchdb/View_collation#Collation_Specification).
opisano jak działa sortowanie zaimplementowanie w CouchDB.

Poniższy przykład, który to próbuje wyjaśnić, pochodzi z [CouchDB
Wiki](http://wiki.apache.org/couchdb/View_collation).

W Futonie tworzymy bazę *coll*, w której zapiszemy dokumenty:

    { "x": " " }
    { "x": "!" }
    ...
    { "x": "~" }

Skorzystamy z modułu *couch-client* dla NodeJS i ze skryptu:

    :::javascript collation.js
    var cc = require('couch-client');
    var coll = cc("http://localhost:5984/coll");

    for (var i=32; i<=126; i++) {
      coll.save({"x": String.fromCharCode(i)}, function(err, doc) {
        if (err) throw err;
        console.log("saved %s", JSON.stringify(doc));
      });
    };

Teraz wystarczy wykonać na konsoli:

    :::bash
    node collation.js

i dokumenty znajdą się w bazie.

Na początek, kilka prostych zapytań. Zapytania wpisujemy w przeglądarce:

    http://localhost:5984/coll/_all_docs?startkey="64"&limit=4
    http://localhost:5984/coll/_all_docs?startkey="64"&limit=2&descending=true
    http://localhost:5984/coll/_all_docs?startkey="64"&endkey="68"

Jeśli odpytujemy widok (tymczasowy na konsoli; konieczne są uprawnienia Admina):

    :::bash
    curl -X POST http://Admin:Pass@localhost:5984/coll/_temp_view \
      -H "Content-Type: application/json" -d '
    {
      "map": "function(doc) { emit(doc.x); }"
    }'

to zwracana lista dokumentów jest posortowana po kluczu (tutaj, po *doc.x*).
Porządek dokumentów określony jest przez
[unicode collation algorithm](http://www.unicode.org/reports/tr10/).
Dlatego mówimy *view collation*, a nie *view sorting*.


## Obiecane rzeczy

Widok **by_tag** zawiera funkcję reduce *_count*.

Poniżej równoważny kod Javascript:

    :::javascript
    function(keys, values, rereduce) {
      if (rereduce) {
        return sum(values);
      } else {
        return values.length;
      }
    }

Kod Javascript równoważny funkcji *_sum*:

    :::javascript
    function(keys, values, rereduce) {
      sum(values);
    }

W dokumentacji [HTTP view](http://wiki.apache.org/couchdb/HTTP_view_API) opisano:

* debugowanie widoków
* view cleanup
* view compaction


<blockquote>
 <p>
  Wszystko da się zrozumieć poza miłością i sztuką.
 </p>
 <p class="author">[stara mądrość]</p>
</blockquote>

## Zrozumieć funkcje Reduce

Najłatwiej zrozumieć o co chodzi parze Map & Reduce przyglądając
się temu co jest zapisywane w logach CouchDB.

### Bazy na Twitterze

Następujący widok:

    :::javascript total.js
    var couchapp = require('couchapp');

    ddoc = {
        _id: '_design/test'
      , views: {}
    }
    module.exports = ddoc;

    ddoc.views.total = {
      map: function(doc) {
        emit(doc.user.screen_name, 1);
      },
      reduce: function(keys, values, rereduce) {
        log('----');
        log('REREDUCE: ' + rereduce);
        log('KEYS: ' + JSON.stringify(keys));
        log('VALUES: ' + JSON.stringify(values));
        return sum(values);
      }
    }

zapiszmy w bazie *statuses* (podzbiór bazy *nosql*):

    :::bash
    couchapp push total.js http://localhost:5984/nosql

Teraz go odpytajmy w ten sposób

    :::bash
    curl 'http://localhost:5984/nosql/_design/test/_view/total?group=true'

Po wciśnięciu *Enter*, natychmiat przechodzimy na konsolę, gdzie
uruchomiliśmy *couchdb*, aby podejrzeć co się wylicza.
Tutaj może być pomocne wciskanie na zmianę Ctrl+S i Ctrl+Q.

Zwróćmy uwagę, że *couchdb*, z własnej inicjatywy, dopisał do tablicy
*keys* *id* przetwarzanego dokumentu:

    [key1, id1], [key2, id2], ...

Innymi słowy, *id1*, to *_id* dokumentu zawierającego klucz *key1*,
*id2*, to *_id* dokumentu – *key1*, itd.
Jeśli dopiszemy do zapytania *rereduce=false*, to możemy użyć
listy *keys* do utworzenia linku do dokumentu.

Następnie, już na spokojnie, odpytujemy widok *rating_avg* w Futonie.


### Movies

W bazie *movies* zapiszemy następujący widok:

    :::javascript movies.js
    var couchapp = require('couchapp');

    ddoc = {
        _id: '_design/test'
      , views: {}
    }
    module.exports = ddoc;

    ddoc.views.rating_avg = {
      map: function(doc) {
        emit(doc.rating, {"count": 1, "rating_total": doc.rating});
      },
      reduce: function(keys, values, rereduce) {
        log('REREDUCE: ' + rereduce);
        log('KEYS: ' + keys);
        // log('VALUES: ' + values); => [object Object],[object Object],...
        var count = 0;
        values.forEach(function(element) { count += element.count; });
        var rating = 0;
        values.forEach(function(element) { rating += element.rating_total; });
        return {"count": count, "rating_total": rating};
      }
    }

Tak go zapiszemy w bazie:

    :::bash
    couchapp push movies.js http://localhost:5984/movies

a tak go odpytamy:

    :::bash
    curl http://localhost:5984/movies/_design/test/_view/rating_avg

Po wciśnięciu enter, natychmiat przechodzimy na konsolę, gdzie
uruchomiliśmy *couchdb*, aby podejrzeć co się wylicza.

Następnie, już na spokojnie, odpytujemy widok *rating_avg* w Futonie.


# Złączenia – czyli co wynika z *Collation Specification*

Przykłady poniżej pochodzą z artykułu
Christophera Lenza, [CouchDB „Joins”](http://www.cmlenz.net/archives/2007/10/couchdb-joins),
gdzie autor omawia trzy sposoby modelowania powiązań
między postami a komentarzami:
„How you’d go about modeling a simple blogging system with «post» and
«comments» entities, where any blog post might have many comments.”

Dodatkowo warto zajrzeć do [CouchDB JOINs
Redux](http://blog.couchone.com/post/446015664/whats-new-in-apache-couchdb-0-11-part-two-views).

## Sposób 1: komentarze inline

Utworzymy bazę *blog-1* zawierającą następujące dokumenty:

    :::json blog-1.json
    {
      "docs": [
        {
          "author": "jacek",
          "title": "Refactoring User Name",
          "content": "Learn how to clean up your code through refactoring.",
          "comments": [
            {"author": "agatka", "content": "thanks!"},
            {"author": "bolek",  "content": "Very very nice idea! Thanks for this post."}
          ]
        },
        {
          "author": "jacek",
          "title": "Restricting Access",
          "content": "You will learn how to lock down the site.",
          "comments": [
            {"author": "lolek", "content": "If God would exists it will be you... thanks for the screencast."},
            {"author": "bolek",  "content": "Fixed...sorry for the spam."}
          ]
        }
      ]
    }

Dokumenty zapiszemy korzystając z programu *curl*:

    :::bash
    curl -X POST -H "Content-Type: application/json" -d @blog-1.json http://localhost:5984/blog-1/_bulk_docs

<!--

Do bazy dodamy widok zwracający wszystkie komentarze, posortowane po polu *author*:

    :::javascript
    function(doc) {
      for (var i in doc.comments) {
        emit(doc.comments[i].author, doc.comments[i].content);
      }
    }

-->

Jakie problemy stwarza takie podejście?

Odpowiedź: Aby dodać komentarz do posta, należy:

1. pobrać dokument post z bazy
2. dodać nowy komentarz do struktury JSON
3. umieścić uaktualniony dokument w bazie

„Now if you have multiple client processes adding comments at roughly
the same time, some of them will get a 409 Conflict error on step 3
(that's optimistic concurrency in action).”


## Sposób 2: komentarze w osobnych dokumentach

Utworzymy bazę *blog-2* w której zapiszemy osobno posty i komentarze:

    :::json blog-2-posts.json
    {
      "docs": [
        {
          "_id": "01",
          "type": "post",
          "author": "jacek",
          "title": "Refactoring User Name",
          "content": "Learn how to clean up your code through refactoring."
        },
        {
          "_id": "02",
          "type": "post",
          "author": "jacek",
          "title": "Restricting Access",
          "content": "You will learn how to lock down the site."
        }
      ]
    }

oraz komentarzy:

    :::json blog-2-comments.json
    {
      "docs": [
        {
          "_id": "11",
          "type": "comment",
          "post": "01",
          "author": "agatka",
          "content": "thanks!"
        },
        {
          "_id": "12",
          "type": "comment",
          "post": "01",
          "author": "bolek",
          "content": "Very very nice idea! Thanks for this post."
        },
        {
          "_id": "13",
          "type": "comment",
          "post": "02",
          "author": "lolek",
          "content": "If God would exists it will be you... thanks for the screencast."
        },
        {
          "_id": "14",
          "type": "comment",
          "post": "02",
          "author": "bolek",
          "content": "Fixed...sorry for the spam."
        }
      ]
    }

Dokumenty zapisujemy w bazie:

    :::bash
    curl -X POST -H "Content-Type: application/json" -d @blog-2-posts.json http://localhost:5984/blog-2/_bulk_docs
    curl -X POST -H "Content-Type: application/json" -d @blog-2-comments.json http://localhost:5984/blog-2/_bulk_docs

Do bazy dodamy widok **/_design/app/by_post**.

Odpytanie widoku daje komentarze zgrupowane po zawartości pola *post*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.post, {author: doc.author, content: doc.content});
      }
    }

Ale jeśli zamierzamy pobrać wszystkie komentarze do posta "02",
to możemy to zrobic tak:

    http://localhost:5984/blog-2/_design/app/_view/by_post?key="02"
    {"total_rows":4,"offset":2,"rows":[
      {"id":"13","key":"02","value":{"author":"lolek","content":"If God would exists..."}},
      {"id":"14","key":"02","value":{"author":"bolek","content":"Fixed...sorry..."}}
    ]}

Jeśli teraz pobierzemy post "02", to mamy komplet.
Dwa żądania HTTP i mamy post i wszystkie do niego komentarze.

<!--

Przeglądanie wszystkich komentarzy posortowanych po polu *author*
umożliwi nam widok *_design/app/by_author*:

    :::javascript
    function(doc) {
      if (doc.type == "comment") {
        emit(doc.author, {post: doc.post, content: doc.content});
      }
    }

Po zapisaniu widoku pod nazwą *by_author* i odpytaniu dostajemy:

    http://localhost:5984/blog-2/_design/app/_view/by_author
    {"total_rows":4,"offset":0,"rows":[
      {"id":"11","key":"agatka","value":{"post":"01","content":"thanks..."}},
      {"id":"12","key":"bolek","value":{"post":"01","content":"Very very nice..."}},
      {"id":"14","key":"bolek","value":{"post":"02","content":"Fixed...sorry..."}},
      {"id":"13","key":"lolek","value":{"post":"02","content":"If God would exists..."}}
    ]}

Przechowywanie osobno postów i komentarzy do nich też ma wady:

„Imagine you want to display a blog post with all the associated
comments on the same web page. With our first approach, we needed
just a single request to the CouchDB server, namely a GET request to
the document. With this second approach, we need two requests: a GET
request to the post document, and a GET request to the view that
returns all comments for the post.”

-->

### Using the power of view collation

„What we'd probably want then would be a way to join the blog post and
the various comments together to be able to retrieve them with
**a single HTTP request**.”

Rozważmy taki widok
(TODO: key *doc* zamienić na *null* i skorzystać z *include_docs=true*;
jest OK bo nie ma funkcji reduce):

    :::javascript
    function(doc) {
      if (doc.type == "post") {
        emit([doc._id, 0], doc);
      } else if (doc.type == "comment") {
        emit([doc.post, 1], doc);
      }
    }

Jak on działa? Aby to zobaczyć, zapiszmy widok jako *_design/app/povc*.

Teraz odpytajmy ten widok, tak:

    http://localhost:5984/blog-2/_design/app/_view/povc?key=["02",0]
    {"total_rows":6,"offset":3,"rows":[
      {"id":"02","key":["02",0],
       "value":{"_id":"02","_rev":"1-6844...",
          "type":"post",
          "author":"jacek",
          "title":"Restricting Access",
          "content":"You will learn how to lock down the site."}}
    ]}

albo tak:

    http://localhost:5984/blog-2/_design/app/_view/povc?key=["02",1]
    {"total_rows":6,"offset":4,"rows":[
      {"id":"13","key":["02",1],
       "value":{"_id":"13","_rev":"1-15dc...",
       "type":"comment",
       "post":"02",
       "author":"lolek",
       "content":"If God would exists...."}},
      {"id":"14","key":["02",1],
       "value":{"_id":"14","_rev":"1-676a...",
       "type":"comment",
       "post":"02",
       "author":"bolek",
       "content":"Fixed...sorry..."}}
    ]}

albo tak:

    http://localhost:5984/blog-2/_design/app/_view/povc?startkey=["02"]&endkey=["03"]
    {"total_rows":6,"offset":3,"rows":[
      {"id":"02","key":["02",0],
       "value":{"_id":"02","_rev":"1-6844...",
       "type":"post",
       "author":"jacek",
       "title":"Restricting Access",
       "content":"You will learn how to lock down the site."}},
      {"id":"13","key":["02",1],
       "value":{"_id":"13","_rev":"1-15dc...",
       "type":"comment",
       "post":"02",
       "author":"lolek",
       "content":"If God would exists..."}},
      {"id":"14","key":["02",1],
       "value":{"_id":"14","_rev":"1-676a...",
       "type":"comment",
       "post":"02",
       "author":"bolek",
       "content":"Fixed...sorry..."}}
    ]}

Bingo! To jest to! Zapytanie zwraca nam post (tutaj z *id* równym "02")
i wszystkie komentarze do niego w **jednym żądaniu HTTP**.


# *Rock* – programujemy po stronie klienta

Do tej pory kodziliśmy po stronie serwera (ang. *server side programming*).
Poniżej będzie przykład kodzenia po stronie klienta (ang. *client side programming*),
gdzie skorzystamy z biblioteki *jquery.couch.js* (wykorzystanej też w Futonie).

Zaczniemy od utworzenia tymczasowego widoku, który po przetestowaniu,
zapiszemy w design document *test* pod nazwą *connection*:

Funkcja map do wklejenia w *temporary view*:

    :::javascript
    function(doc) {
      for (var who in doc.similar)
        emit(doc.id, doc.similar[who]);
    }

Po zapisaniu widoku w bazie, odpytujemy go w przeglądarce:

    http://localhost:5984/rock/_design/test/_view/connection

Poniższy kod wpiszemy i wykonywamy w Firefoxie
na konsoli rozszerzenia *Firebug*, czyli wykonamy go **po stronie klienta**.
(Jeśli korzystamy z Google Chrome to kod wykonujemy na konsoli
wbudowanej w tę przeglądarkę.)

W przeglądarce, w zakładce z Futonem otwieramy okno z konsolą,
gdzie wpisujemy:

    :::javascript
    var db = $.couch.db('rock')

Następnie wpsiujemy i wykonujemy na konsoli:

    :::javascript
    db.view('test/connection', {
      success: function(data) {
        console.log( data.rows.map(function(o){ return o.value; }) );
    }})

I jeszcze raz na konsoli, tym razem zapytanie z jednym parametrem:

    :::javascript
    db.view("test/connection", {
      key: 'jimmypage',
      success: function(data) {
        console.log( data.rows.map(function (o) { return o.value; }) );
    }})

Zobacz też Caolan McMahon,
[Writing for node and the browser](http://caolanmcmahon.com/posts/writing_for_node_and_the_browser#/posts/writing_for_node_and_the_browser)


## Linki

CouchDB stuff:

* [Interactive CouchDB](http://labs.mudynamics.com/wp-content/uploads/2009/04/icouch.html)
* [Introduction to CouchDB Views](http://wiki.apache.org/couchdb/Introduction_to_CouchDB_views)

Nieco Mongo docs:

* [Translate SQL to MongoDB MapReduce](http://nosql.mypopescu.com/post/392418792/translate-sql-to-mongodb-mapreduce)
* [NoSQL Data Modeling](http://nosql.mypopescu.com/post/451094148/nosql-data-modeling)
* [MongoDB Tutorial: MapReduce](http://nosql.mypopescu.com/post/394779847/mongodb-tutorial-mapreduce)
