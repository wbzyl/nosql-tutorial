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

Zaczynamy od zapisania w bazie *test* w kolekcji *chesterton*
(976) akapitów z książki G.K. Chestertona, „The Man Who Knew Too Much”.

    ./gutenberg2mongo.rb the-man-who-knew-too-much.txt \
       http://www.gutenberg.org/cache/epub/1720/pg1720.txt -v -d test -c chesterton

Przykładowy dokument z kolekcji *chesterton*:

    :::javascript
    {
      "_id" : ObjectId("4de5e745e138230694000054"),
      "paragraph" : "And he carried off the two rifles without casting a glance at the stranger...",
      "count" : 83,
      "title" : "the man who knew too much"
    }

Poniższe MapReduce różni się *wc.js* tylko tym, że w wyrażeniu
regularnym użytym w metodzie *match* dodano litery z Latin-1,
polskie diakrytyki (i nieco innych liter):

    :::javascript chesterton.js
    m = function() {
      this.paragraph.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g).forEach(function(word) {
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
    res = db.chesterton.mapReduce(m, r, {finalize: f, out: "wc"});
    printjson(res);

Uruchamiamy powyższe MapReduce. Po wykonaniu kodu (kilka sekund)
sprawdzamy co się wyliczyło:

    db.wc.find().sort({value: -1})
      { "_id" : "the", "value" : 3840 }
      { "_id" : "a", "value" : 1941 }
      { "_id" : "and", "value" : 1873 }
      { "_id" : "of", "value" : 1833 }
      { "_id" : "to", "value" : 1295 }
      { "_id" : "he", "value" : 1174 }
      { "_id" : "in", "value" : 1099 }
      { "_id" : "it", "value" : 970 }


## „Pivot Data” na przykładzie kolekcji *Rock*

Zaczynamy od przeniesienia bazy *rock* z CouchDB do MongoDB.
W tym celu, w bazie CouchDB zapiszemy widok i funkcję listową
({%= link_to "kod", "/db/mongodb/rock.js" %}
i {%= link_to "źródło", "/doc/scripts/rock.js" %}) generującą –
po jednym w wierszu – dokumenty przekonwertowane na format JSON.
Następnie odpytamy funkcję listową zapomocą programu *curl*.
Otrzymane JSON-y zapiszemy w kolekcji *rock* korzystając
z programu *mongoimport*.

Przykładowy dokument z kolekcji *rock*:

    :::javascript
    db.rock.findOne({name: 'Led Zeppelin'})
    {
       "_id" : "ledzeppelin",
       "name" : "Led Zeppelin",
       "tags" : [
           "classicrock", "rock", "hardrock",
           "70s", "progressiverock", "blues",
           "ledzeppelin", "british", "bluesrock", "heavymetal"
       ]
    }

Z dokumentów chcemy utworzyć kolekcję *genres* zawierającą
dokumenty w takim formacie:

    :::javascript
    {
      _id: ObjectId(),
      tag: "classicrock",
      names: [ "Led Zeppelin", ... ]
    }

### MapReduce

W kodzie poniżej argument *value* nie może być tablicą.
Dlaczego? Odpowiedź: Takie ograniczenie jest w wersji 1.9 MongoDB.
Może to się zmienić w kolejnej wersji MongoDB.

To ograniczenie, utrudnia nieco kodowanie.
Aby je obejść wstawiamy tablicę do obiektu *value*:

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
      return value.names;  // a to po co? kto wie?
    };

    db.rock.mapReduce(m, r, { finalize: f, out: "pivot" });


### Sprawdzamy wyniki

Po wykonaniu na konsoli *mongo* powyższego MapReduce,
w kolekcji *pivot* znajdziemy dokumenty w formacie:

    :::javascript
    printjson(db.pivot.findOne());
      {
         "_id" : "00s",
         "value" : [
              "Queen + Paul Rodgers",
              "Izzy Stradlin",
              "Gilby Clarke"
         ]
      }

a miały mieć format:

    :::javascript
    {
      _id: ObjectId(),
      tag: "00s",
      names: [ "Queen + Paul Rodgers", "Izzy Stradlin" ]
    }

Nazwy pól zmienimy w pętli. Dokument z nowymi nazwami pól
zapiszemy w kolekcji *genre*:

    :::javascript
    var cursor = db.pivot.find();
    while (cursor.hasNext()) {
     var doc = cursor.next();
     var ddoc = {};
     ddoc.tag = doc._id;
     ddoc.names = doc.value;
     db.genre.insert(ddoc);
    };

Albo, to samo, tylko zamiast pary metod *hasNext* i *next* skorzystamy
z metody *forEach*:

    :::javascript
    db.pivot.find().forEach(function(doc) {
      var ddoc = {};
      ddoc.tag = doc._id;
      ddoc.names = doc.value;
      db.genre.insert(ddoc);
    });

i usuwamy niepotrzebną już kolekcję *pivot*.

    :::javascript
    db.pivot.drop();


## SPAM

O co chodzi w tym przykładzie?
