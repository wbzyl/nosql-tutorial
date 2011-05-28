#### {% title "MapReduce" %}

<blockquote>
 {%= image_tag "/images/speed.jpg", :alt => "[Speed]" %}
</blockquote>

Na początek kilka ilustracji. Oto jak
Ketrina Yim, Sally Ahn, Dan Garcia. „Computer Science Illustrated”
rozrysowały ideę mapreduce:

* [An Example: Distributed Word Count](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf)
* [Parallelism and Functional Programming](http://csillustrated.berkeley.edu/PDFs/mapreduce.pdf)
* [The wordcount in Code](http://csillustrated.berkeley.edu/PDFs/mapreduce-code.pdf)

Zobacz też Matthew Johnson,
[Infusing Parallelism into Introductory ComputerScience Curriculum using MapReduce](http://www.eecs.berkeley.edu/Pubs/TechRpts/2008/EECS-2008-34.pdf).


Podstawowa dokumentacja:

* [MapReduce](http://www.mongodb.org/display/DOCS/MapReduce)
* [Troubleshooting MapReduce](http://www.mongodb.org/display/DOCS/Troubleshooting+MapReduce)
* [A Look At MongoDB 1.8's MapReduce Changes](http://blog.evilmonkeylabs.com/2011/01/27/MongoDB-1_8-MapReduce/)
* Źródła MongoDB: [mr1](https://github.com/mongodb/mongo/blob/master/jstests/mr1.js),
  [mr2](https://github.com/mongodb/mongo/blob/master/jstests/mr2.js)

Przykłady z internetu:

* K. Banker. [A Cookbook for MongoDB](http://cookbook.mongodb.org/index.html) –
  kilka przykładów z MapReduce
* [Yet another MongoDB Map Reduce tutorial](http://www.mongovue.com/2010/11/03/yet-another-mongodb-map-reduce-tutorial/) –
  fajne ilustracje
* [Malware, MongoDB and Map/Reduce : A New Analyst Approach](http://blog.9bplus.com/malware-mongodb-and-mapreduce-a-new-analyst-a)

## Zaczynamy

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


## Korzystamy ze „zmiennych globalnych”

Na dłuższą metę sprawdzanie wyników na konsoli jest męczące.
W skrypcie poniżej użyjemy wbudowanej w powłokę *mongo* funkcji
*assert* do sprawdzania wyników.

W kodzie poniżej, przyjrzymy się blizej kilku JSON-om
wypisując ich zawartość na konsolę (za pomocą funkcji *printjson*).
Skorzystamy też z metody *convertToSingleObject* zamieniającej
JSON zwracany przez *mapReduce* na JSON zawierający
wynik obliczeń mapreduce.

Z wartości zmiennej *xx* zdefiniowanej poniżej możemy korzystać
w_kodzie JavaScript w funkcjach użytych w *mapReduce*.
Zmienna *xx* zdefiniowana przez *scope* jest w zasięgu tych funkcji.
Zmienne umieszczone w „scope” są **tylko do odczytu**.

    :::javascript scope.js
    t = db.scope;
    t.drop();

    t.save( { tags : [ "a" , "b" ] } );
    t.save( { tags : [ "b" , "c" ] } );
    t.save( { tags : [ "c" , "a" ] } );
    t.save( { tags : [ "b" , "c" ] } );

    m = function() {
      this.tags.forEach(function(tag) {
        emit(tag , xx); // zmiennej xx można też użyć w funkcji r poniżej
      });
    };

    r = function(key, values) {
      var total = 0;
      values.forEach(function(count) {
        total += count;
      });
      return total;
    };

    res = t.mapReduce( m, r, {scope: {xx: 2}, out: "scope.out"} );
    z = res.convertToSingleObject()

    printjson(res);
    printjson(z);

    assert.eq( 4 , z.a, "liczbie wystąpień 'a' × 2" );
    assert.eq( 6 , z.b, "liczbie wystąpień 'b' × 2" );
    assert.eq( 6 , z.c, "liczbie wystąpień 'c' × 2" );

    res.drop();
    t.drop();


## „Pivot data”

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

Nowe dokumenty zapisujemy w kolekcji *rock.names*.


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
    var cursor = db.pivot.find({})
    while (cursor.hasNext()) {
     var doc = cursor.next();
     var ddoc = {};
     ddoc.tag = doc._id;
     ddoc.names = doc.value;
     db.rock.tags.insert(ddoc);
    };
    db.pivot.drop();


## Dwuprzebiegowe MapReduce

[Counting Unique Items with Map-Reduce](http://cookbook.mongodb.org/patterns/unique_items_map_reduce/).
