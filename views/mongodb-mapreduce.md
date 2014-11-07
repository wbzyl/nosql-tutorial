#### {% title "Platforma obliczeniowa MapReduce" %}

<blockquote>
 <h3>There’s no speed limit</h3>
 <p>{%= image_tag "/images/speed.jpg", :alt => "[Speed]" %}
 <p class="author">— D. Sivers,
   <a href="http://sivers.org/kimo">The lessons that changed my life</a></p>
</blockquote>

Przykłady za Matthew Johnson,
[Infusing Parallelism into Introductory ComputerScience Curriculum using MapReduce](http://www.eecs.berkeley.edu/Pubs/TechRpts/2008/EECS-2008-34.pdf):
Word Count, Pivot Data, Spam.

Podstawowa dokumentacja:

* [MapReduce](http://docs.mongodb.org/master/core/map-reduce/)
* [Aggregation Mechanics](http://docs.mongodb.org/master/core/aggregation-mechanics/)
* [Aggregation Examples](http://docs.mongodb.org/master/applications/aggregation/):
  - [Map-Reduce Examples](http://docs.mongodb.org/master/tutorial/map-reduce-examples/)
  - [Troubleshoot the Map Function](http://docs.mongodb.org/master/tutorial/troubleshoot-map-function/)
  - [Troubleshoot the Reduce Function](http://docs.mongodb.org/master/tutorial/troubleshoot-reduce-function/)

Różne rzeczy:

* [τ – DataTau](http://www.datatau.com/)
* Ilya Katsov,
  [MapReduce Patterns, Algorithms, and Use Cases](https://highlyscalable.wordpress.com/2012/02/01/mapreduce-patterns/)


## Dlaczego MapReduce?

W klasycznym modelu obliczeniowym, dane pobieramy na komputer na którym
wykonywane są obliczenia:

{%= image_tag "/images/petabyte.png", :alt => "[petabyte]" %}

Jeśli danych tych jest dużo, to czas pobierania będzie długi.
Przykładowo, ściągnięcie 1 TB danych łączem 8 Mbps, czyli 1MB/s, zajmuje:
<pre>1 TB / 1 MB/s = 10^6 MB / 1 MB/s = 10^6 s
10^6 s ≅ 277 godzin ≅ <b>11.5 dnia</b>
</pre>

A dla 1 PB danych czas będzie 1 000 razy dłuższy,
co czyni około **31 lat**.

Kod użyty w obliczeniach zajmuje zazwyczaj dużo mniej miejsca.
Jeśli wyniki obliczeń też nie zajmują dużo miejsca, to szybciej
będzie przesłać kod na komputery z danymi, tam go wykonać,
a następnie ściągnąć wyniki.

{%= image_tag "/images/mapreduce-cloud.png", :alt => "[MapReduce]" %}

<blockquote>
  <p>When processing a large dataset, it's often much more efficient
    to take the computation to the data than it is to bring the data
    to the computation. In practice, your MapReduce job code is likely
    less than 10 kilobytes, it is more efficient to send the code
    to the gigs of data being processed, than to stream gigabytes
    of data to your 10k of code.</p>
 <p class="author">
   <a href="http://docs.basho.com/riak/latest/references/appendices/MapReduce-Implementation/">riak/docs</a></p>
</blockquote>

I taka jest zasada obliczeń MapReduce – kod jest przesyłany do
komputera (lub komputerów) z danymi, na którym przeprowadzane są obliczenia.
Dane nie są przemieszczane (obliczenia są wykonywane na wielu komputerach)!

Przy okazji:

* 1 ns = 10^-9 s
* 10^9 cykli na sekundę to 1 GHz
* na przebycie 1 m światło potrzebuje ok. 3.33 ns

A te liczby warto znać:

{%= image_tag "/images/nesk.png", :alt => "[Numbers Everyone Should Know]" %}


<blockquote>
 <p>{%= image_tag "/images/being-john-malkovich.jpg", :alt => "[Being John Malkovich]" %}
 <p>Here's the thing:
   If you ever got me, you wouldn't have a clue what to do with me.
 <p class="author">[Being John Malkovich]
</blockquote>

## Jak działa MapReduce w MongoDB?

Jak działa MapReduce:
„MapReduce has a couple of steps. It starts with the map step, which
maps an operation onto every document in a collection. That operation
could be either “do nothing” or “emit these keys with X values.” There
is then an intermediary stage called the shuffle step: keys are
grouped and lists of emitted values are created for each key. The
reduce takes this list of values and reduces it to a single
element. This element is returned to the shuffle step until each key
has a list containing a single value: the result.”

(*K. Chodorow* i *M. Dirolf*, „MongoDB: The Definitive Guide”)

{%= image_tag "/images/mongo-mapreduce.png", :alt => "[MongoDB MapReduce]" %}

Szczegóły:
„When you run a MapReduce on a cluster, each shard performs its own map
and reduce. *mongos* chooses a “leader” shard and sends all the reduced data
from the other shards to that one for a final reduce.
Once the data is reduced to its final form, it will be output
in whatever method you’ve specified.”

(*K. Chodorow*, „Scaling MongoDB”, s. 38)


### Prosty przykład: *word count*

Zliczymy liczbę wystąpień każdego słowa w tych dwóch napisach

    to be or not to be
    to wit

Zapiszemy dwa przykładowe dokumenty w kolekcji *phrases*:

    :::js wc.js
    db.phrases.insert({ _id: 1, filename: "hamlet.txt",  content: "to be or not to be" });
    db.phrases.insert({ _id: 2, filename: "phrases.txt", content: "to wit" });

Funkcje *m* (map) i *r* (reduce) zdefiniowane poniżej, wysyłamy do kolekcji *phrases*:

    :::js wc.js
    coll = db.phrases;
    coll.mapReduce(m, r, {out: "wc"});

Po wykonaniu obliczeń wyniki zostaną we wskazanej kolekcji; tutaj *wc*.
Możemy też wyniki zapamiętać w zmiennej:

    :::js
    var res = coll.mapReduce(m, r, {out: {inline: 1}});

Funkcja map:

    :::javascript wc.js
    m = function() {
      this.content.match(/[a-z]+/g).forEach(function(word) {
        emit(word, 1);
      });
    };

Po wykonaniu map:

{%= image_tag "/images/after-map.png", :alt => "[MongoDB Map]" %}

Przed wykonaniem funkcji reduce wykonywany jest krok „shuffle”:

<pre><i>key</i>:  <i>values</i>
 be: [ 1, 1 ]
not: [ 1 ]
 or: [ 1 ]
 to: [ 1, 1, 1 ]
wit: [ 1 ]
</pre>

<blockquote>
<h3>MongoDB Resources</h3>
<p>{%= image_tag "/images/logo-mongodb.png", :alt => "[MongoDB Resources]" %}</p>
<p>W <a href="http://api.mongodb.org/js/current/index.html">JavaScript Docs</a>
  zdefiniowano <i>Array.sum</i> i kilka innych użytecznych funkcji.</p>
</blockquote>

Funkcja reduce:

    :::javascript wc.js
    r = function(key, values) {
      return Array.sum(values);
    };

Po wykonaniu, być może kilkukrotnie, funkcji reduce, otrzymujemy:

{%= image_tag "/images/after-reduce.png", :alt => "[MongoDB Reduce]" %}

Jeśli nie korzystamy z *finalize*, to to co widać na rysunku
powyżej jest wynikiem obliczeń MapReduce.

Program *wc.js* uruchamiamy na konsoli *mongo*:

    mongo wc.js --shell

gdzie sprawdzamy co wyliczyły funkcje map i reduce
zdefiniowane powyżej:

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


## Specyfikacja funkcji map i reduce

Wszystkie wymagania dla funkcji map i reduce
są opisane tutaj:

* [db.collection.mapReduce()](http://docs.mongodb.org/master/reference/method/db.collection.mapReduce/)

Prototyp funkcji map:

    :::js
    m = function() {
       // this – odwołanie do bieżącego dokumentu
       ...
       emit(key, value);
    }

Prototyp funkcji reduce:

    :::js
    r = function(key, values) {
       ...
       return result;
    }

1\. Elementy tablicy *values* to emitowane *value*
i funkcja reduce może być wywoływana wielokrotnie, dlatego muszą być
spełnione warunki:

    :::js
    r(key, [ v1, r(key, [v2, v3]) ] == r(key, [ v1, v2, v3 ])  // zgodność typów
    r(key, [ r(key, values) ]) == r(key, values)               // idempotentność

2\. Funkcja reduce musi wyliczać ten sam wynik niezależnie od kolejności
częściowych obliczeń:

    :::js
    r(key, [ v1, v2 ]) == r(key, [ v2, v1 ])                   // przemienność


## Specyfikacja funkcji finalize

Prototyp funkcji finalize:

    :::js
    function(key, value) {
       ...
       return object;
    }


<blockquote>
 <h3>ECMA 5 &amp; V8</h3>
 <p>{%= image_tag "/images/v8.png", :alt => "[V8]" %}
 <p>When developing in the browser there are many <b>wonderful built in
   JavaScript functions</b> that we can’t use because certain browsers don’t
   implement them.<br>
   Z tych <b>wspaniałych funkcji</b>, najbardziej użyteczną dla nas
   będzie funkcja <a href="https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/Reduce">Array#reduce</a>.</p>
 <p class="author"><a href="https://github.com/joyent/node/wiki/ECMA-5-Mozilla-Features-Implemented-in-V8">Features Implemented in V8</a>.</p>
</blockquote>

## Duże MapReduce

Od wersji 2.3.1+ MongoDB używa silnika JavaScript o nazwie „V8”.
Wcześniejsze wersje korzystały z silnika „SpiderMonkey”.

Silnik Javascript V8 implementuje funkcję *reduce*.
Oto prosty przykład użycia tej funkcji:

    :::js
    [1, 2, 3, 4].reduce(function(acc, currentValue, index, array) {
      return acc + currentValue;
    });

Powyższy kod wylicza 10.

A wykonanie tego kodu:

    :::js
    [1, 2, 3, 4].reduce(function(acc, currentValue, index, array) {
      return acc + currentValue;
    }, 10);

daje 20.


### Tworzymy kolekcję *big*

Użyjemy MapReduce do wyliczenia najmniejszej i największej liczby
w kolekcji czterech liczb losowych z przedziału [0, 1):

    :::js big-insert-data.js
    for (var i = 0; i < 4; i++) db.big.insert( {x: Math.random()} );
    db.big.count();
    db.big.find().limit(8);

Później liczbę 4 zastąpimy liczbami 10^6 i 1.5\*10^6.
Dopiero dla kolekcji takich rozmiarów nazwa
*big* może być adekwatna.


### MapReduce

Definiujemy funkcję map – *m* i funkcję reduce – *r*:

    :::javascript big.js
    m = function() {
       emit("answer", { min: this.x, max: this.x });
    };
    r =  function(key, values) {
      var value = values.reduce(function(acc, cur) {
        if (cur.min < acc.min) acc.min = cur.min;
        if (cur.max > acc.max) acc.max = cur.max;
        return acc;
      }, {min: 1, max: 0});
      return value;
    };

i uruchamiamy MapReduce:

    :::js
    res = db.big.mapReduce(m, r, { out: {inline: 1} });
    {
      "results": [
        {
          "_id": "answer",
          "value": { "min": 0.000000197906, "max": 0.999999092658 }
        }
      ],
      "timeMillis": 53347,
      "counts": {
        "input": 1500000, "emit": 1500000, "reduce": 15000, "output": 1
      },
      "ok": 1,
    }

Obliczenia dla kolekcji big składającej się z 1.5*10^6 liczb losowych
trwały 54,3 s.

A tak wyglądało wykorzystanie procesora w trakcie obliczeń.

Dla wersji MongoDB < v2.4 (10^6 liczb losowych):

{%= image_tag "/images/mapreduce-wykorzystanie-procesora.png", :alt => "[Big MapReduce, 10^6 liczb losowych, MongoDB < 2.4]" %}

Dla wersji MongoDB v2.4.1 (1.5 * 10^6 liczb losowych):

{%= image_tag "/images/mapreduce-v8-monitor-systemu.png", :alt => "[Big MapReduce, 10^6 liczb losowych, MongoDB 2.4.1]" %}


(Zrzuty ekranu programu „monitor systemu”.)


<blockquote>
<p>{%= image_tag "/images/Man-Who-Knew-Too-Much.jpg", :alt => "[Gilbert Keith Chesterton, The Man Who Knew Too Much]" %}</p>
</blockquote>

## Word Count

Kolekcja *books* zawiera wszystkie akapity tych książek:

1. Fyodor Dostoyevsky, *The Idiot*.
2. Gilbert Keith Chesterton, *The Man Who Knew Too Much*.
3. Leo Tolstoy, *War and Peace*.
4. Arthur Conan Doyle, *The Sign of the Four*.

Jak utworzone kolekcję opisano tutaj
[4 Books from Project Gutenberg](https://github.com/nosql/map-reduce/blob/master/docs/wbzyl.md).
Kolekcja zawiera 18786 dokumentów.
Oto przykładowy dokument:

    :::js
    {
      "n": 8,                                // akapit #8
      "title": "The Man Who Knew Too Much",  // z tej książki
      "author": "Chesterton, Gilbert K",     // tego autora
      "p": "\"A scientific interest, I suppose?\" observed March."
    }


Kod tego MapReduce różni się od kodu *wc.js* tylko tym, że w wyrażeniu
regularnym użytym w metodzie *match* dodano litery z Latin-1,
polskie diakrytyki (i nieco innych liter):

    :::javascript 4books.js
    m = function() {
      res = this.p.toLowerCase().match(/[\w\u00C0-\u017F]+/g);
      if (res) {
        res.forEach(function(word) {
          emit(word, 1);
        });
      }
    };
    r = function(key, values) {
      return Array.sum(values);
    };
    res = db.books.mapReduce(m, r, {out: "wc"});
    printjson(res);

Uruchamiamy powyższe MapReduce:

    mongo 4books.js --shell

Po wykonaniu kodu (kilkanaście sekund), *printjson* wypisze
na konsoli coś takiego:

    :::js
    {
      "result" : "wc",
      "timeMillis" : 13206,
      "counts" : {
        "input" : 18786,
        "emit" : 925055,
        "reduce" : 103894,
        "output" : 22433
      },
      "ok" : 1,
    }

Na koniec sprawdzamy co się wyliczyło:

    :::js
    db.wc.find().sort({value: -1}).limit(8)
      { "_id": "the", "value": 51325 }
      { "_id": "and", "value": 32694 }
      { "_id": "to", "value": 25825 }
      { "_id": "of", "value": 23464 }
      { "_id": "a", "value": 18561 }
      { "_id": "he", "value": 16287 }
      { "_id": "in", "value": 14365 }
      { "_id": "that", "value": 13688 }


## „Pivot” dokumentów kolekcji *rock*

Wszystkie dokumenty z kolekcji *rock* można pobrać z maszyny
wirtualnej:

    :::bash
    mongoexport -u student -p sesja2013 -c rock -h 153.19.1.202 > rock.json

Termin **pivot** można przetłumaczyć jako „obracać”.

Przedstawioną poniżej zmianę kształtu dokumentów,
można określić jako obrót.

Przykładowy dokument z kolekcji *rock* (bez pól *_id*, *similar* i *tracks*):

    :::js
    db.rock.findOne({name: 'Led Zeppelin'}, {_id: 0, similar: 0, tracks: 0})
      {
        "name" : "Led Zeppelin",
        "tags" : [
          "classicrock", "rock", "hardrock",
          "70s", "progressiverock", "blues",
          "ledzeppelin", "british", "bluesrock", "heavymetal"
        ]
      }

Z oryginalnych dokumentów chcemy utworzyć kolekcję *genres* zawierającą
dokumenty „obrócone”:

    :::js
    {
      tag: "classicrock",
      names: [ "Led Zeppelin", "Cream", "Jeff Beck", "Ten Years After", ... ]
    }

Argument *value* może być skalarem lub obiektem.
Użyjemy obiektu z tablicą wewnątrz.

Dlaczego „ukrywamy” tablicę w obiekcie.
Ponieważ próba zwrócenia tablicy w argumencie *values* funkcji reduce
kończy się takim błędem (MongoDB v2.4.1):

    :::js
    Sun Apr 14 19:42:00.377 JavaScript execution failed: map reduce failed:{
      "errmsg": "exception: reduce -> multiple not supported yet",
      "code": 10075,
      "ok": 0
    }

Tablicę wstawiamy ją do obiektu *value*.
Poniższa funkcja map *m* będzie generować taką listę `klucz:wartość`:

    "classicrock:{"names": ["Led Zeppelin"]}
    "rock":      {"names": ["Led Zeppelin"]}
    ...
    "heavymetal":{"names": ["Led Zeppelin"]}

Kod funkcji map:

    :::js pivot.js
    m = function() {
      var value = { names: [ this.name ] };
      this.tags.forEach(function(tag) {
        emit(tag, value);
      });
    };

Funkcja reduce jest wywoływana z takimi tablicami *values*:

    :::js
    [{"names":["Led Zeppelin","Cream"]}, ..., {"names":["Eric Clapton","Jeff Beck","Sweet"]}]

Dlatego w funkcji reduce, aby zachować „typ” argumentu *value* musimy
„spłaszczyć” tablice tablic napisów do tablicy napisów (*flatten*).
Funkcję taką łatwo napisać korzystając
z [funkcji *reduce* Javascript](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/Reduce#Example.3A_Flatten_an_array_of_arrays):

    :::js
    [[1,2], [2,4,5], [6]].reduce(function(acc, x) {
      return acc.concat(x);
    })
    //=> [1,2,3,4,5,6]

Kod funkcji reduce:

    :::js pivot.js
    r = function(key, values) {
      var a = values.reduce(function(acc, x) {
        return acc.concat(x.names);
      }, []);
      return { names: a };
    };
    f = function(key, value) {
      return value.names;       // a to po co?
    };

    res = db.rock.mapReduce(m, r, { finalize: f, out: "pivot" });


### Sprawdzamy wyniki

Po wykonaniu na konsoli *mongo* powyższego MapReduce,
w kolekcji *pivot* znajdziemy dokumenty w formacie:

    :::js
    db.pivot.findOne();
      {
        "_id" : "00s",
        "value" : [ "Queen", "Izzy Stradlin" ]
      }

a miały mieć format:

    :::javascript
    {
      _id: ObjectId(),
      tag: "00s",
      names: [ "Queen", "Izzy Stradlin" ]
    }

Nazwy pól zmienimy w pętli. Dokument z nowymi nazwami pól
zapiszemy w nowej kolekcji o nazwie *genre*:

    :::javascript
    db.pivot.find().forEach(function(doc) {
      var ddoc = {};
      ddoc.tag = doc._id;
      ddoc.names = doc.value;
      db.genres.insert(ddoc);
    });

No a teraz możemy przyjrzeć się wynikom:

    :::js
    db.genres.find().pretty()
