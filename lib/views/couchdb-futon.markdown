#### {% title "Futon: Map ⇒ Reduce → Rereduce" %}

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


### Total size of all images

Funkcja map:

    :::javascript
    function(doc) {
      emit("size", doc.info.size);
    }

Funkcja reduce:

    :::javascript
    _stats

(`_stats` – funkcja napisana w Erlangu – dlatego jest szybka).

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
