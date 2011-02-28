#### {% title "Futon: Map ⇒ Reduce → Rereduce" %}

<blockquote>
 <p>
  Wszystko da się zrozumieć poza miłością i sztuką.
 </p>
 <p class="author">[stara mądrość]</p>
</blockquote>


Futon, to graficzny interfejs do CouchDB. Futon jest dostępny z takiego uri:

    http://127.0.0.1:4000/_utils/

albo takiego:

    http://localhost:5984/_utils/

Zanim przyjrzymy się Futonowi, utworzymy nową bazę o nazwie *photos*.

    curl -X PUT http://localhost:4000/photos

W bazie umieścimy dokumenty z info o fotografiach
(przykład z fotografiami pochodzi ze strony
[Interactive CouchDB](http://labs.mudynamics.com/wp-content/uploads/2009/04/icouch.html)):

    :::json photos.json
    {
      "docs": [
        {"_id":"1","name":"fish.jpg","created_at":[2010,9,1],
         "user":"bob","type":"jpeg","camera":"nikon",
         "info":{"width":100,"height":200,"size":12345},
         "tags":["tuna","shark"]},
        {"_id":"2","name":"trees.jpg","created_at":[2010,6,6],
         "user":"john","type":"jpeg","camera":"canon",
         "info":{"width":30,"height":250,"size":32091},
         "tags":["oak"]},
        {"_id":"3","name":"snow.png","created_at":[2010,9,1],
         "user":"john","type":"png","camera":"canon",
         "info":{"width":64,"height":64,"size":1253},
         "tags":["tahoe","powder"]},
        {"_id":"4","name":"hawaii.png","created_at":[2010,12,31],
         "user":"john","type":"png","camera":"nikon",
         "info":{"width":128,"height":64,"size":92834},
         "tags":["maui","tuna"]},
        {"_id":"5","name":"hawaii.gif","created_at":[2011,1,1],
         "user":"bob","type":"gif","camera":"canon",
         "info":{"width":320,"height":128,"size":49287},
         "tags":["maui"]},
        {"_id":"6","name":"island.gif","created_at":[2011,1,1],
         "user":"zztop","type":"gif","camera":"nikon",
         "info":{"width":640,"height":480,"size":50398},
         "tags":["maui"]}
      ]
    }

Dokumenty zapiszemy hurtem w bazie:

    curl -X POST http://localhost:4000/photos/_bulk_docs -d @photos.json

Albo, umieścimy dokumenty w bazie korzystając z takiego skryptu:

    :::ruby pictures.rb
    require 'yajl'
    require 'couchrest'

    json = File.new('pictures.json', 'r')
    parser = Yajl::Parser.new
    list = parser.parse(json)

    db = CouchRest.database!("http://127.0.0.1:4000/photos")

    db.bulk_save(list)
    db.documents


Poniżej będziemy do adresów uri korzystać z różnych opcji zapytań.
Kompletną listę znajdziemy na Wiki,
[CouchDB Querying Options](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options).


## Widoki tymczasowe

Z listy rozwijanej **View** (prawy górny róg) wybieramy **Temporary view**.

Domyślny widok tymczasowy składa się z *Map Function*:

    :::javascript
    function(doc) {
      emit(null, doc);
    }

oraz pustej *Reduce Function*.

    :::javascript
    function(keys, values, rereduce) {
    }

**Terminologia:** pierwszy argument funkcji *emit* to
**key**, a drugi to **value**.

Argument *rereduce* przyjmuje wartość *false* lub *true*.
Argumenty *keys* i *values* są tablicami. Jakimi?
Wystarczy, że dopiszemy logowanie do funkcji reduce:

    :::javascript
    function(keys, values, rereduce) {
      log('KEYS: ' + keys);
      log('VALUES: ' + values);
    }

A widok tymczasowy podmienimy na:

    :::javascript
    function(doc) {
      emit(doc.user, doc.camera);
    }

i wartości argumentów zostaną zapisane w logach:

    :::javascript
    zztop,6,john,4,john,3,john,2,bob,5,bob,1
    nikon,nikon,canon,canon,canon,nikon

Zatem, tablica *keys* składa się z:

    [key1, id1], [key2, id2], ...

gdzie *id1*, to *_id* dokumentu zawierającego klucz *key1*, itd.

Tablica *values*, zawiera odpowiadające kluczom *doc.user* nazwy
aparatów *doc.camera*.

Widok nie zawiera dokumentów **i dlatego jest mniejszy i szybciej się generuje**.
Dokumenty możemy zawsze pobrać, ponieważ znamy ich *_id*.

JTZ? Zapiszmy powyższy widok jako *photos/by_user*.

Widok bez dokumentów:

    curl -X GET http://localhost:4000/photos/_design/photos/_view/by_user?reduce=false
    {"total_rows":6,"offset":0,"rows":[
      {"id":"1","key":"bob","value":"nikon"},
    ...

i widok z dokumentami:

    curl -X GET 'http://localhost:4000/photos/_design/photos/_view/by_user?include_docs=true&reduce=false'
    {"total_rows":6,"offset":0,"rows":[
      {"id":"1","key":"bob","value":"nikon",
        "doc":{"_id":"1","_rev":"1-67f5...",
               "name":"fish.jpg",
               "created_at":[2010,9,1],
               "user":"bob",
               "type":"jpeg",
               "camera":"nikon",
               "info":{"width":100,"height":200,"size":12345},
               "tags":["tuna","shark"]}},
    ...

ale, ustawienie *reduce* na *true*, zwraca:

    curl -X GET 'http://localhost:4000/photos/_design/photos/_view/by_user?include_docs=true&reduce=true'
    {
      "error": "query_parse_error",
      "reason": "Query parameter `include_docs` is invalid for reduce views."
    }

W zasadzie należało tego oczekiwać. Dlaczego?

**Ważna uwaga:**

Poza tym, takie *emit*:

    emit(doc.user, doc.camera);

też nie ma większego sensu. Dlaczego?

Cytat: „We can use the **map function** to generate complex key value pairs
(**sorted by key**) and then reduce the values corresponding to each
unique key into either a simple or complex value.


**Luźne uwagi:**

1. url wstawiliśmy w cudzysłowy, ponieważ zawiera znak `&` –
   interpretowany przez powłokę
2. korzystamy z *curl* ponieważ w Futonie nie można
   dopisywać dowolnych opcji do zapytań


Kilka prostych przykładów.

### Sorting pictures by user

Funkcja map:

    :::javascript
    function(doc) {
      emit(doc.user, null);
    }

### Sorting pictures by date

Funkcja map:

    :::javascript
    function(doc) {
      emit(doc.created_at, 1);
    }

Funkcja reduce:

    :::javascript
    function(keys, values, rereduce) {
      return sum(values);
    }

Czym są argumenty funkcji reduce?

    :::javascript
    function(keys, values, rereduce) {
      log('KEYS: ' + keys);
      log('VALUES: ' + values);
      log('REREDUCE: ' + rereduce);
      return sum(values);
    }

Wybieramy *Grouping*: exact, level 1, level 2, level 3, level 4.
Wyjaśnić co oznacza grouping.


### Total size of all images

Funkcja map:

    :::javascript
    function(doc) {
      emit("size", doc.info.size);
    }

Funkcja reduce:

    :::javascript
    _stats

(`_stats` – wbudowana funkcja; napisana w Erlangu – dlatego jest szybka).

Teraz uruchamiamy widok z funkcją *map* i *reduce*.

**BUG:** Aby w tabelce z *Key/Value* pojawiło się okienko do zaznaczenia
funkcji *Reduce* musiałem kliknąć w *Save As* itd.

Czym są argumenty funkcji *reduce*?

### Counting pictures by user

Funkcja map:

    :::javascript
    function(doc) {
      emit(doc.user);
    }

Funkcja reduce: j.w.

**Uwaga:** Futon zawsze dopisuje do zapytania: **group=true**
(można to zobaczyć w logach).



## Widoki permanentne

Zapiszmy poniższy widok jako *by_size*

    :::javascript
    function(doc) {
      emit(doc.info.size);
    }

Futon zapisze ten widok w „Design Documents” jako ...?

Wykonajmy ten widok.


## TODO: Biblioteka *jquery.couch.js*

Futon korzysta z biblioteki *jquery.couch.js* (oraz paru
innych). Biblioteka ta udostępnia funkcje ułatwiające korzystanie
z baz danych CouchDB.

Skorzystamy z kilku jej funkcji pisząc widoki/zapytania do bazy
*sprawdziany*. Kod będziemy wykonywać na konsoli rozszerzenia
*Firebug* (w Firefoxie, albo na konsoli Javascript w Google Chrome;
w zakładce z Futonem).

Przed wykonaniem widoku/zapytania łączymy się z bazą:

    :::jquery_javascript
    var db = $.couch.db('photos')

Następnie wykonujemy widok, przekazując do niego jeden parametr:

    :::jquery_javascript
    db.view('default/by_tag', {
      key: 'agatka',
      success: function (data) {
        console.log(data.rows);
      }
    })

I jeszcze jeden widok/zapytanie do wykonania:

    :::jquery_javascript
    db.view("app/by_size", {
      key: 'jacek',
      success: function(data) {
        console.log(data.rows.map(function (o) { return o.value; }));
      }
    })


## Linki

CouchDB stuff:

* [Interactive CouchDB](http://labs.mudynamics.com/wp-content/uploads/2009/04/icouch.html)
* [Introduction to CouchDB Views](http://wiki.apache.org/couchdb/Introduction_to_CouchDB_views)

Nieco Mongo docs:

* [Translate SQL to MongoDB MapReduce](http://nosql.mypopescu.com/post/392418792/translate-sql-to-mongodb-mapreduce)
* [NoSQL Data Modeling](http://nosql.mypopescu.com/post/451094148/nosql-data-modeling)
* [MongoDB Tutorial: MapReduce](http://nosql.mypopescu.com/post/394779847/mongodb-tutorial-mapreduce)
