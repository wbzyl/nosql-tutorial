#### {% title "MapReduce Cookbook" %}

Przykłady z repozytorium *Mongo* oraz ze strony:

* K. Banker. [A Cookbook for MongoDB](http://cookbook.mongodb.org/index.html) –
  zawiera kilka przykładów z MapReduce

Google o MongoDB MapReduce:

* [Yet another MongoDB Map Reduce tutorial](http://www.mongovue.com/2010/11/03/yet-another-mongodb-map-reduce-tutorial/) –
  fajne ilustracje
* [Malware, MongoDB and Map/Reduce : A New Analyst Approach](http://blog.9bplus.com/malware-mongodb-and-mapreduce-a-new-analyst-a)


## Korzystamy ze „zmiennych globalnych”

Zmienna *xx* zdefiniowana poniżej w *scope* jest w zasięgu funkcji
map, reduce i finalize.
Zmienne umieszczone w *scope* są **tylko do odczytu**.

    :::javascript scope.js
    t = db.letters;
    t.drop();

    t.save( { tags : [ "a" , "b" ] } ); t.save( { tags : [ "b" , "c" ] } );
    t.save( { tags : [ "c" , "a" ] } ); t.save( { tags : [ "b" , "c" ] } );

    m = function() {
      this.tags.forEach(function(tag) {
        emit(tag , xx);
      });
    };
    r = function(key, values) {
      var total = 0;
      values.forEach(function(count) {
        total += count;
      });
      return total;
    };

    res = t.mapReduce( m, r, {scope: {xx: 2}, out: "letters.out"} );
    z = res.convertToSingleObject()

    printjson(res);
    printjson(z);

    assert.eq( 4 , z.a, "liczbie wystąpień 'a' × 2" );
    assert.eq( 6 , z.b, "liczbie wystąpień 'b' × 2" );
    assert.eq( 6 , z.c, "liczbie wystąpień 'c' × 2" );

    res.drop();  // to samo co db.scope.out.drop() ?
    t.drop();

Skrypt wykonujemy na konsoli *mongo*:

    mongo scope.js


## Debugging MapReduce

Jeśli funkcja map nie działa, to możemy ją wykonać poza MapReduce
przedfiniowując funkcję *emit* i korzystając z metody *apply*. Łatwiej
jest przetestować funkcję reduce.

    :::javascript debugging.js
    t = db.map; t.drop();
    t.insert({_id: 1, tags: ['ą', 'ć', 'ć', 'ł']});
    t.insert({_id: 2, tags: ['ł', 'ń', 'ą']});

    m = function() {
      this.tags.forEach(function(tag) {
        emit(tag, {count: 1});
      });
    };

    function emit(key, value) {
      print("emit( " + key + ", " + tojson(value) + " )");
    };

    print('MAP: test one doc')
    x = t.findOne();
    m.apply(x);  // call our map function, client side, with 'x' as 'this'

    print('MAP: test multiple docs:')
    t.find().forEach(function(doc) {
      m.apply(doc);
    });

    r = function(key, values) {
      var total = 0;
      values.forEach(function(value) {
        total += value.count;
      });
      return {count: total};
    };

    print("REDUCE: r('a', [ {count: 2}, {count: 4}, {count: 2} ])")
    printjson(r('a', [ {count: 2}, {count: 4}, {count: 2} ]));

    print("REDUCE: r('a', [ {count: 2}, r('a', [{count: 4}, {count: 2}]) ])")
    printjson(r('a', [ {count: 2}, r('a', [{count: 4}, {count: 2}]) ]));

    res = t.mapReduce(m, r, {out: "map.lc"});
    printjson(res);


## Unique visits per hour on Sigma

Unique visits per hour – „two-pass MapReduce solution”.

Full info z logów:

    :::javascript
    {
      "_id" : { "$oid" : "4e42314c7fb325c5f9090e72" },
      "time" : { "$date" : 1312960845000 },
      "hostname" : "inf.ug.edu.pl",
      "client" : "213.77.77.4",
      "request" : "GET /index.php?url=err/404.php HTTP/1.1",
      "status" : "200",
      "responsesize" : "8380",
      "useragent" : "Opera/9.64 (Windows NT 6.0; U; pl) Presto/2.1.1"
    }

Tylko te pola będą potrzebne do poniższego przykładu:

    :::javascript
    {
      "_id" : { "$oid" : "4e42314c7fb325c5f9090e72" },
      "time" : { "$date" : 1312960845000 },
      "client" : "213.77.77.4",
    }

Pierwszy przebieg:

    :::javascript
    map = function() {
      emit({hour: this.time.getHours(), client: this.client}, {count: 1});
    };
    reduce = function(key, values) {
      var counter = 0;
      values.forEach(function(value) {
        counter += value.count;
      });
      return {count: counter};
    };
    db.apache.mapReduce(map, reduce, {out: "pass1r"});

Wynik:

    :::javascript
    db.pass1r.findOne();
        {
            "_id" : {
                    "hour" : 0,
                    "client" : "108.89.250.109"
            },
            "value" : {
                    "count" : 3
            }
        }
    db.pass1r.find().sort({value: -1})
      { "_id" : { "hour" : 19, "client" : "158.111.18.101" }, "value" : { "count" : 3215 } }
      { "_id" : { "hour" : 7, "client" : "157.111.77.180" }, "value" : { "count" : 1667 } }
      { "_id" : { "hour" : 11, "client" : "156.111.11.142" }, "value" : { "count" : 1616 } }

Drugi przebieg:

    :::javascript
    map = function() {
      emit(this['_id']['hour'], {count: 1});
    };
    // funkcja reduce bez zmian
    db.pass1r.mapReduce(map, reduce, {out: "pass2r"});

Wyniki:

    :::javascript
    db.pass2r.find();
        { "_id" :  0, "value" : { "count" :  899 } }
        { "_id" :  1, "value" : { "count" :  718 } }
        { "_id" :  2, "value" : { "count" :  664 } }
        { "_id" :  3, "value" : { "count" :  579 } }
        { "_id" :  4, "value" : { "count" :  629 } }
        { "_id" :  5, "value" : { "count" :  544 } }
        { "_id" :  6, "value" : { "count" :  685 } }
        { "_id" :  7, "value" : { "count" :  732 } }
        { "_id" :  8, "value" : { "count" : 1147 } }
        { "_id" :  9, "value" : { "count" : 1431 } }
        { "_id" : 10, "value" : { "count" : 1650 } }
        { "_id" : 11, "value" : { "count" : 1751 } }
        { "_id" : 12, "value" : { "count" : 1657 } }
        { "_id" : 13, "value" : { "count" : 1820 } }
        { "_id" : 14, "value" : { "count" : 1691 } }
        { "_id" : 15, "value" : { "count" : 1776 } }
        { "_id" : 16, "value" : { "count" : 1528 } }
        { "_id" : 17, "value" : { "count" : 1466 } }
        { "_id" : 18, "value" : { "count" : 1537 } }
        { "_id" : 19, "value" : { "count" : 1593 } }
        { "_id" : 20, "value" : { "count" : 1679 } }
        { "_id" : 21, "value" : { "count" : 1702 } }
        { "_id" : 22, "value" : { "count" : 1547 } }
        { "_id" : 23, "value" : { "count" : 1247 } }
