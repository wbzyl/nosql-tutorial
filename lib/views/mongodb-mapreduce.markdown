#### {% title "MapReduce w przykładach" %}

<blockquote>
 {%= image_tag "/images/speed.jpg", :alt => "[Speed]" %}
</blockquote>

Przykłady za Matthew Johnson,
[Infusing Parallelism into Introductory ComputerScience Curriculum using MapReduce](http://www.eecs.berkeley.edu/Pubs/TechRpts/2008/EECS-2008-34.pdf)):

* Word Count
* Pivot Data
* Spam

Przykład „Word Count” rozrysowany przez Ketrinę Yim, Sally Ahn, Dan Garcia,
[Computer Science Illustrated](http://csillustrated.berkeley.edu/):

* [An Example: Distributed Word Count](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf)
* [The wordcount in Code](http://csillustrated.berkeley.edu/PDFs/mapreduce-code.pdf)
* [Parallelism and Functional Programming](http://csillustrated.berkeley.edu/PDFs/mapreduce.pdf)

Podstawowa dokumentacja:

* [MapReduce](http://www.mongodb.org/display/DOCS/MapReduce)
* [Troubleshooting MapReduce](http://www.mongodb.org/display/DOCS/Troubleshooting+MapReduce)


## Jak działa MapReduce?

Pierwsze koty za płoty:

    :::javascript wc.js
    db.books.insert({ _id: 1, filename: "hamlet.txt",  content: "to be or not to be" });
    db.books.insert({ _id: 2, filename: "phrases.txt", content: "to wit" });

    m = function() {
      this.content.match(/[a-z]+/g).forEach(function(word) {
        emit(word, 1);
      });
    };
    r = function(key, values) {
      var value = 0;
      values.forEach(function(count) {
        value += count;
      });
      return value;
    };

    db.books.mapReduce(m, r, {out: "wc"});
    print("☯ To display results run: db.wc.find()");  // dlaczego tak?

Program *wc.js* uruchamiamy na konsoli *mongo*:

    mongo wc.js --shell

gdzie sprawdzamy co wyliczyło mapreduce:

    :::javascript
    db.wc.find()
      { "_id" : "be", "value" : 2 }
      { "_id" : "not", "value" : 1 }
      { "_id" : "or", "value" : 1 }
      { "_id" : "to", "value" : 3 }
      { "_id" : "wit", "value" : 1 }

    db.wc.find().sort({value: -1})
      { "_id" : "to", "value" : 3 }
      { "_id" : "be", "value" : 2 }
      { "_id" : "not", "value" : 1 }
      { "_id" : "or", "value" : 1 }
      { "_id" : "wit", "value" : 1 }

Na dłuższą metę ręczne sprawdzanie wyników na konsoli jest uciążliwe.
W skryptach poprawność wyników będziemy sprawdzać
za pomocą wbudowanej funkcji *assert*. W tym celu zmienimy
dwie ostatnie linijki skryptu *wc.js*:

    res = db.books.mapReduce(m, r, {out: "wc"});
    z = res.convertToSingleObject();
    //  z == { "be" : 2, "not" : 1, "or" : 1, "to" : 3, "wit" : 1 }
    assert.eq( 2 , z.be, "liczba wystąpień 'be'" );
    assert.eq( 1 , z.not, "liczba wystąpień 'not'" );
    assert.eq( 1 , z.or, "liczba wystąpień 'or'" );
    assert.eq( 3 , z.to, "liczba wystąpień 'to'" );
    assert.eq( 2 , z.wit, "liczba wystąpień 'wit'" );

Na koniec sprzątamy po skrypcie:

    :::javascript
    db.books.drop();
    db.wc.drop();

Zobacz też implementację metody
[convertToSingleObject](http://api.mongodb.org/js/1.9.0/symbols/src/shell_collection.js.html).


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
