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
