#### {% title "MapReduce Cookbook" %}

Większość przykładów pochodzi z:

* K. Banker. [A Cookbook for MongoDB](http://cookbook.mongodb.org/index.html) –
  kilka przykładów z MapReduce

Google o MongoDB MapReduce:

* [Yet another MongoDB Map Reduce tutorial](http://www.mongovue.com/2010/11/03/yet-another-mongodb-map-reduce-tutorial/) –
  fajne ilustracje
* [Malware, MongoDB and Map/Reduce : A New Analyst Approach](http://blog.9bplus.com/malware-mongodb-and-mapreduce-a-new-analyst-a)


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


## Dwuprzebiegowe MapReduce

[Counting Unique Items with Map-Reduce](http://cookbook.mongodb.org/patterns/unique_items_map_reduce/)?
