#### {% title "MapReduce w przykładach" %}

<blockquote>
 {%= image_tag "/images/speed.jpg", :alt => "[Speed]" %}
</blockquote>

Kanoniczne przykłady (Matthew Johnson.
[Infusing Parallelism into Introductory ComputerScience Curriculum using MapReduce](http://www.eecs.berkeley.edu/Pubs/TechRpts/2008/EECS-2008-34.pdf)):

* Word Count
* Pivot Data
* Spam

Na początek kilka ilustracji. Oto jak
Ketrina Yim, Sally Ahn, Dan Garcia. „Computer Science Illustrated”
rozrysowały ideę mapreduce:

* [An Example: Distributed Word Count](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf)
* [The wordcount in Code](http://csillustrated.berkeley.edu/PDFs/mapreduce-code.pdf)
* [Parallelism and Functional Programming](http://csillustrated.berkeley.edu/PDFs/mapreduce.pdf)

Podstawowa dokumentacja:

* [MapReduce](http://www.mongodb.org/display/DOCS/MapReduce)
* [Troubleshooting MapReduce](http://www.mongodb.org/display/DOCS/Troubleshooting+MapReduce)


## Jak działa MapReduce?

TODO: drugi łatwiejszy wariant z assert.

Pierwsze koty za płoty:

    :::javascript
    db.mr.drop();

    db.mr.insert({_id: 1, tags: ['ą', 'ć', 'ę']});
    db.mr.insert({_id: 2, tags: ['']});
    db.mr.insert({_id: 3, tags: []});
    db.mr.insert({_id: 4, tags: ['ć', 'ę', 'ł']});
    db.mr.insert({_id: 5, tags: ['ą', 'a']});

    m = function() {
      this.tags.forEach(function(tag) {
        emit(tag, {count: 1});
      });
    };

    r = function(key, values) {
      var total = 0;
      values.forEach(function(value) {
        total += value.count;
      });
      return {count: total};
    };

    res = db.mr.mapReduce(m, r, {out: "mr.tc"});

    printjson(res);
    print("==>> To display results run: db.mr.tc.find()");


### Counting tags

Czyli to samo co powyżej, ale prościej i dla bazy zwierającej
kilkanaście cytatów H. Steinhausa i S. J. Leca. Zaczynamy od
skopiowania bazy *ls* z CouchDB do *MongoDB*.
Skorzystamy ze skryptu
{%= link_to "couchrest2mongo.rb", "/doc/scripts/couchrest2mongo.rb" %}:

    couchrest2mongo.rb --help
    couchrest2mongo.rb -d ls -m mapreduce -c ls

Czyli tworzymy na MongoDB bazę *mapreduce*, gdzie kopiujemy zawartość bazy
*ls* z CouchDB do kolekcji *ls*. Następnie sprawdzamy na konsoli
*mongo* co się skopiowało:

    :::javascript
    use mapreduce
      switched to db mapreduce
    show collections
      ls
    db.ls.findOne()

Funkcję map, funkcję reduce oraz wywołanie *mapReduce*
wpiszemy w pliku *ls_count_tags.js*:

    :::javascript ls_count_tags.js
    m = function() {
      if (!this.tags) return;
      this.tags.forEach(function(tag) {
        emit(tag, 1);
      });
    };
    r = function(key, values) {
      var total = 0;
      values.forEach(function(count) {
        total += count;
      });
      return total;
    };
    // results = db.ls.mapReduce(m, r, {out : "ls.tags"});
    results = db.runCommand({
      mapreduce: "ls",
      map: m,
      reduce: r,
      out: "ls.tags"
    });
    printjson(results);

Powyższy program uruchamiamy w terminalu:

    mongo --shell mapreduce ls_count_tags.js

Następnie na konsoli *mongo* wpisujemy:

    show collections
    db.ls.tags.find({_id: 'nauka'})


## Word Count

**TODO**


## Pivot Data

TODO: wrzucić kolekcję na Tao: mapreduce/rock.

W kolekcji *rock.names* zapisane są dokumenty w formacie:

    :::json
    {
      name: "King Crimson",
      tag: [ "progressiverock", "rock", "psychedelic" ]
    }

Z tej kolekcji chcemy utworzyć kolekcję *rock.tags* zawierającą
dokumenty w formacie:

    :::json
    {
      tag: "psychedelic",
      name: [ "King Crimson", "Pink Floyd", "Cream", ... ]
    }


### Przygotowujemy kolekcję *rock.names*

Kopiujemy bazę *rock* z CouchDB do MonggDB
(link {%= link_to "couchrest2mongo.rb", "/doc/scripts/couchrest2mongo.rb" %}):

    ./couchrest2mongo.rb -d rock -m mapreduce -c rock

Ponieważ kolekcja *rock* zawiera zbędne dla nas w tej chwili pola,
usuniemy je. W tym celu na konsoli *mongo* wykonujemy poniższy kod:

    :::javascript
    var cursor = db.rock.find({}, {name: 1, tags: 1, _id: 0})
    while (cursor.hasNext()) {
     var doc = cursor.next();
     db.rock.names.insert(doc);
    };

Uwaga: nowe dokumenty zapisujemy w kolekcji *rock.names*.


### Kolej na MapReduce

W kodzie poniżej argument *value* nie może być tablicą.
Dlaczego? Takie jest ograniczenie w wersji 1.9 MongoDB.
Dlatego w kodzie wstawiliśmy tablicę do obiektu.

    :::javascript pivot.js
    m = function() {
      var value = { names: [ this.name ] };
      this.tags.forEach(function(tag) {
        emit(tag, value);
      });
    };
    r = function(key, values) {
      var list = { names: [] };
      values.forEach(function(x) {
        list.names = x.names.concat(list.names);
      });
      return list;
    };
    f = function(key, value) {
      return value.names;
    };

    db.pivot.drop();
    db.rock.names.mapReduce(m, r, { finalize: f, out: "pivot" });
    printjson(db.pivot.findOne());

Po wykonaniu powyższego kodu w kolekcji *pivot* zostały
zapisane rekordy w formacie:

    :::json
    { "_id" : "00s",  "value" : [ "Queen + Paul Rodgers", "Izzy Stradlin", "Gilby Clarke"  ] }

a miały mieć format:

    :::json
    { "tag" : "00s",  "names" : [ "Queen + Paul Rodgers", "Izzy Stradlin", "Gilby Clarke"  ] }

Nazwy pól zamienimy przepisując zmienione dokumenty do kolekcji *rock.tags*:

    :::javascript
    var cursor = db.pivot.find();
    while (cursor.hasNext()) {
     var doc = cursor.next();
     var ddoc = {};
     ddoc.tag = doc._id;
     ddoc.names = doc.value;
     db.rock.tags.insert(ddoc);
    };

albo zamiast pary metod *hasNext* i *next* skorzystamy z metody *forEach*:

    :::javascript
    db.pivot.find().forEach(function(doc) {
      var ddoc = {};
      ddoc.tag = doc._id;
      ddoc.names = doc.value;
      db.rock.tags.insert(ddoc);
    });
    db.pivot.drop();

Przy okazji usuwamy już niepotrzebną kolekcję *pivot*.


## SPAM

O co chodzi w tym przykładzie?
