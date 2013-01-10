#### {% title "MapReduce w przykładach" %}

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

* [MapReduce](http://docs.mongodb.org/manual/applications/map-reduce/)
* [Troubleshooting MapReduce](http://docs.mongodb.org/manual/applications/map-reduce/#map-reduce-troubleshooting)


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

(cytat z książki *K. Chodorow* i *M. Dirolf*, „MongoDB: The Definitive Guide”)

{%= image_tag "/images/mongo-mapreduce.png", :alt => "[MongoDB MapReduce]" %}


### Prosty przykład

Zapiszemy dwa przykładowe dokumenty w kolekcji *books*:

    :::js wc.js
    db.books.insert({ _id: 1, filename: "hamlet.txt",  content: "to be or not to be" });
    db.books.insert({ _id: 2, filename: "phrases.txt", content: "to wit" });

Funkcje *m* (map) i *r* (reduce) zdefiniowane poniżej, wysyłamy do kolekcji *books*:

    :::js wc.js
    db.books.mapReduce(m, r, {out: "wc"});

Po wykonaniu obliczeń wyniki zapisujemy w kolekcji *wc*.

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

W wersji V8 użytej w MongoDB zaimplementowano funkcję *reduce*.
Oto prosty przykład:

    :::js
    [1, 2, 3, 4].reduce(function(previousValue, currentValue, index, array) {
      return previousValue + currentValue;
    });

Powyższy kod wylicza 10.

A wykonanie tego kodu:

    :::js
    [1, 2, 3, 4].reduce(function(previousValue, currentValue, index, array) {
      return previousValue + currentValue;
    }, 10);

daje 20.


### Tworzymy kolekcję *big*

Użyjemy MapReduce do wyliczenia najmniejszej i największej liczby
w kolekcji czterech liczb losowych z przedziału [0, 1):

    :::js big-insert-data.js
    for (var i = 0; i < 4; i++) db.big.insert( {x: Math.random()} );
    db.big.count();
    db.big.find().limit(8);

Później liczbę 4 zastąpimy liczbami 10^6 i 10^7. Dopiero dla kolekcji
takich rozmiarów nazwa *big* jest adekwatna.


### MapReduce

Definiujemy funkcję map – *m* i funkcję reduce – *r*:

    :::javascript big.js
    m = function() {
       emit("answer", { min: this.x, max: this.x });
    };
    r =  function(key, values) {
      var value = values.reduce(function(prev, cur) {
        if (cur.min < prev.min) prev.min = cur.min;
        if (cur.max > prev.max) prev.max = cur.max;
        return prev;
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
            "value": {
              "min": 0.029445646097883582,
              "max": 0.8922047016676515
            }
          }
        ],
        ...
      }

Obliczenia dla kolekcji big składającej się z 10^6 liczb losowych
trwają około 25 s (na moim komputerze).
A tak wygląda wykorzystanie procesora w trakcie obliczeń:

{%= image_tag "/images/mapreduce-wykorzystanie-procesora.png", :alt => "[Big MapReduce, 10^6 liczb losowych]" %}


## Word Count

Zaczynamy od zapisania w bazie *test* w kolekcji *chesterton*
(976) akapitów z książki G.K. Chestertona, „The Man Who Knew Too Much”.

    :::bash
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

Kod poniższego MapReduce różni się od *wc.js* tylko tym, że w wyrażeniu
regularnym użytym w metodzie *match* dodano litery z Latin-1,
polskie diakrytyki (i nieco innych liter):

    :::javascript chesterton.js
    m = function() {
      this.paragraph.toLowerCase().match(/[A-Za-z\u00C0-\u017F]+/g).forEach(function(word) {
        emit(word, 1);
      });
    };
    r = function(key, values) {
      return Array.sum(values);
    };
    res = db.chesterton.mapReduce(m, r, {out: "wc"});
    printjson(res);

Uruchamiamy powyższe MapReduce:

    mongo chesterton.js --shell

Po wykonaniu kodu (kilka sekund), *printjson* wypisuje
na konsoli coś takiego:

    :::javascript
    {
      "result" : "wc",
      "timeMillis" : 1139,
      "counts" : {
        "input" : 976,
        "emit" : 60573,
         "reduce" : 3264,
         "output" : 6323
      },
      "ok" : 1,
    }

Na koniec sprawdzamy co się wyliczyło:

    :::javascript
    db.wc.find().sort({value: -1})
      { "_id" : "the", "value" : 3840 }
      { "_id" : "a", "value" : 1941 }
      { "_id" : "and", "value" : 1873 }
      { "_id" : "of", "value" : 1833 }
      { "_id" : "to", "value" : 1295 }
      { "_id" : "he", "value" : 1174 }
      { "_id" : "in", "value" : 1099 }
      { "_id" : "it", "value" : 970 }


### Word Segmentaion

Funkcja map powyżej jest prymitywną implementacją algorytmu „word segmentation”,
czyli podziału tekstu na słowa. Powinniśmy ją zastąpić jakimś „prawdziwym”
tokenizerem.

Poniżej skorzystam z dwóch modułów dla NodeJS,
[MongoDB Native NodeJS Driver](https://github.com/christkv/node-mongodb-native/)
oraz [Natural](https://github.com/NaturalNode/natural).
Ten ostatni moduł implementuje kilka „tokenizerów”:

Zaczniemy od instalacji modułów:

    :::bash
    npm install -g natural
    npm install -g mongodb --mongodb:native

Zapiszemy w bazie *gutenberg* w kolekcji *chesterton* akapity z książki
G. K. Chestertona, *The Man Who Knew Too Much*:

    :::bash
    ./gutenberg2mongo.rb the-man-who-knew-too-much.txt \
        http://www.gutenberg.org/cache/epub/1720/pg1720.txt -c chesterton

Następnie do każdego dokumentu dodamy pole *words*:

    :::javascript add-words-to-chest.js
    {
      "_id" : ObjectId("4de5e745e138230694000054"),
      "paragraph" : "And he carried off the two rifles without casting a glance at the stranger...",
      "words" : ["and", "he", "carried", "off", "the", "two", …],
      "count" : 83,
      "title" : "the man who knew too much"
    }

Napiszemy skrypt dla *node*, który to zrobi. W skrypcie skorzystamy
z drivera *mongodb* ([Node.JS MongoDB Driver Manual](http://mongodb.github.com/node-mongodb-native/contents.html)):

    :::js add-words-to-chesterton.js
    var natural = require('natural')
    , tokenizer = new natural.WordTokenizer()
    , assert = require('assert')
    , mongoClient = require('mongodb').MongoClient;

    mongoClient.connect("mongodb://localhost:27017/gutenberg", {native_parser: true}, function(err, db) {
      assert.equal(null, err);

      var collection = db.collection('chesterton');
      var cursor = collection.find({}, {snapshot: true});
      cursor.each(function(err, doc) {
        assert.equal(null, err);

        if (doc == null) {
          db.close();
        } else {
          var words = tokenizer.tokenize(doc.paragraph);
          doc.words = words;
          collection.save(doc, {w: 1}, function(err, result) {
            assert.equal(null, err);

          });
          // console.dir(doc);
        };
      });
    });

*Uwaga o funkcji **save** użytej powyżej:*
„Simple full document replacement function.
Not recommended for efficiency, **use atomic operators
and update** instead for more efficient operations.”

Zmienimy funkcję map, tak by korzystała z listy słów *words*:

    :::javascript natural-chesterton.js
    var conn = new Mongo();
    db = conn.getDB("gutenberg");
    m = function() {
      this.words.forEach(function(word) {
        emit(word.toLowerCase(), 1);
      });
    };
    r = function(key, values) {
      return Array.sum(values);
    };
    res = db.chesterton.mapReduce(m, r, {out: "wc"});
    printjson(res);

Więcej o pisaniu skryptów na konsolę *mongo* –
[Write Scripts for the mongo Shell](http://docs.mongodb.org/manual/tutorial/write-scripts-for-the-mongo-shell/).

Teraz możemy uruchomić obliczenia MapReduce:

    :::bash terminal
    mongo gutenberg natural-chesterton.js --shell
      {
          "result" : "wc",
          "timeMillis" : 448,
          "counts" : {
              "input" : 976,
              "emit" : 60579,
              "reduce" : 3264,
              "output" : 6336
          },
          "ok" : 1,
      }

Sprawdzamy wyniki na konsoli *mongo*:

    :::js konsola
    db.wc.count()  //=> 6336
    db.wc.find().sort({ value: -1 })

**Zadanie:** Usunąć z tekstu książki wszystkie
[stop words](http://en.wikipedia.org/wiki/Stop_words)
(zawiera linki do angielskich i polskich „stop words”).
*Pytanie:* Ile jest akapitów składających się wyłącznie
z „stop words”?


## „Pivot” dokumentów kolekcji *Rock*

Zaczynamy od instalacji modułu *couchapp* dla *node*:

    :::bash
    npm install -g couchapp

Aby przenieść bazę *rock* z CouchDB do MongoDB użyjemy
widoku i funkcji listowej.

W bazie CouchDB zapiszemy widok i funkcję listową korzystając
ze skryptu {%= link_to "rock.js", "/doc/scripts/rock.js" %}
({%= link_to "kod", "/db/mongodb/rock.js" %}).
Instrukcja użycia skryptu jest w komentarzu na końcu pliku.

Funkcja listowa generuje, po jednym w wierszu,
dokumenty przekonwertowane na format JSON.
Następnie odpytamy funkcję listową za pomocą programu *curl*.
Otrzymane JSON-y zapisujemy w kolekcji *rock* korzystając
z programu *mongoimport*.

Termin *pivot* można przetłumaczyć jako „obracać”.
Przedstawioną poniżej zmianę formatu dokumentu, można
określić jako obrót.

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
dokumenty „obrócone”:

    :::javascript
    {
      _id: ObjectId(),
      tag: "classicrock",
      names: [ "Led Zeppelin", ... ]
    }

### MapReduce

Argument *value* może być skalarem lub obiektem.
Użyjemy obiektu z tablicą wewnątrz.
(Takie ograniczenie było w MongoDB 1.9.0.)

Tablicę wstawiamy do obiektu *value*:

    :::javascript pivot.js
    m = function() {
      var value = { names: [ this.name ] };
      this.tags.forEach(function(tag) {
        emit(tag, value);
      });
    };
    r = function(key, values) {
      var list = values.reduce(function(a, b) {
        return a.concat(b.names);
      }, []);
      return { names: list };
    };
    f = function(key, value) {
      return value.names;       // a to po co?
    };

    res = db.rock.mapReduce(m, r, { finalize: f, out: "pivot" });


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
    db.pivot.find().pretty()
    db.pivot.find().pretty()


## SPAM

Na Sigmę przychodzi dużo poczty. Treść emaila jest poprzedzona
nagłówkiem. Tak wygląda typowy nagłówek:

    From astronomerspp9506@qip.ru  Tue Mar 30 12:23:07 2010
    Return-Path: <astronomerspp9506@qip.ru>
    X-Spam-Flag: YES
    X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on delta.inf.ug.edu.pl
    X-Spam-Level: **************
    X-Spam-Status: Yes, score=8.9 required=3.5 tests=BAYES_99,HELO_LOCALHOST,
            HTML_MESSAGE,RAZOR2_CF_RANGE_51_100
            autolearn=spam version=3.2.5
    X-Spam-Report:
            *  3.5 BAYES_99 BODY: Bayesian spam probability is 99 to 100%
            *      [score: 1.0000]
            *  3.9 HELO_LOCALHOST HELO_LOCALHOST
            *  0.0 HTML_MESSAGE BODY: HTML included in message
            *  1.5 RAZOR2_CF_RANGE_E4_51_100 Razor2 gives engine 4 confidence level
            *      above 50%
    X-Original-To: root@manta.univ.gda.pl
    Delivered-To: adm@inf.ug.edu.pl
    From: =?koi8-r?B?8sHE1dbOwdEg68HU0Q==?=
            <astronomerspp9506@qip.ru>
    To: <demonek@manta.univ.gda.pl>
    Subject: =?koi8-r?B?7/P1/eXz9Pfs8eXtIPDl8uXl+uQ=?=
    Date: Tue, 30 Mar 2010 17:23:03 +0700
    MIME-Version: 1.0

Wiadomość ta została oznaczona jako spam
na podstawie ocen z nagłowka X-Spam-Report.
Powyżej zostały użyte tylko cztery oceny
wystawione na podstawie czterech testów:
*BAYES_99*, *HELO_LOCALHOST*, *HTML_MESSAGE*,
*RAZOR2_CF_RANGE_E4_51_100*.
Testów jest więcej. Jakie i ile opisane jest tutaj:

    perldoc Mail::SpamAssassin::Conf

Kompletna lista testów SpamAssassin’a v3.3.x jest na wiki
[Tests Performed: v3.3.x](http://spamassassin.apache.org/tests_3_3_x.html).

Na serwerze Tao w kolekcji *spam* zapisałem
ok. 50,000 takich nagłówków.
Oto typowy dokument z tej kolekcji:

    {
        "_id" : ObjectId("4de74979c4c18a0859000001"),
        "Date" : ISODate("2010-03-30T11:58:46Z"),
        "Subject" : "СДАМ ОФИС В АРЕНДУ. СОБСТВЕННИК.",
        "X-Spam-Flag" : "YES",
        "X-Spam-Level" : "**********",
        "X-Spam-Status" : "Yes, score=7.0 required=3.5",
        "X-Spam-Tests" : [
                "BAYES_99",
                "HELO_DYNAMIC_SPLIT_IP"
        ],
        "X-Spam-Report" : {
                "BAYES_99" : 3.5,
                "HELO_DYNAMIC_SPLIT_IP" : 3.5
        },
        "From-Text" : "\"\\\"Лада \"",
        "From" : "insolventst7@arsoft.ru"
    }

Za pomocą prostego skryptu możemy wylistować nazwy
wszystkich użytych testów i ile razy były użyte:

    :::javascript spam-tests.js
    var cursor = db.spam.find();
    var test = {};

    while (cursor.hasNext()) {
      var doc = cursor.next();
      doc['X-Spam-Tests'].forEach(function(name) {
        if (test[name] === undefined) {
          test[name] = 1;
        } else {
          test[name] += 1;
        };
      });
    };

Teraz możemy podejrzeć ile razy został użyty
każdy z testów. W tym celu zapiszemy
hasz *test* w bazie:

    :::javascript spam-tests.js
    db.spam.tests.drop();
    for (c in test) {
      db.spam.tests.insert({ name: c,  count: test[c] });
    };

Teraz pobierzemy listę dokumentów posortowaną malejąco
po *count*:

    mongo mapreduce spam-tests.js --shell

i na konsoli wykonujemy:

    db.spam.tests.find(null, {_id: 0}).sort({count: -1});
      { "name" : "BAYES_99", "count" : 48390 }
      { "name" : "RCVD_IN_PBL", "count" : 36425 }
      { "name" : "HTML_MESSAGE", "count" : 32267 }
      { "name" : "RDNS_NONE", "count" : 31992 }
      { "name" : "RCVD_IN_XBL", "count" : 31869 }
      { "name" : "RAZOR2_CHECK", "count" : 29544 }
      { "name" : "RAZOR2_CF_RANGE_51_100", "count" : 28784 }
      { "name" : "RCVD_IN_BL_SPAMCOP_NET", "count" : 23815 }
      { "name" : "RAZOR2_CF_RANGE_E8_51_100", "count" : 23502 }
      { "name" : "URIBL_BLACK", "count" : 21581 }
      ... top 10 ...

Wszystkich testów jest 410. Tak to można wyliczyć:

    var a = [];
    for (c in test) a.push(c);
    a.length;

Zakończymy wstępne rozpoznanie spamu policzeniem sumy punktów
przyznanych w każdym teście:

    :::javascript spam-tests.js
    for (name in test) {
      test[name] = 0;
    };

    var cursor = db.spam.find();
    while (cursor.hasNext()) {
      var doc = cursor.next();
      var report = doc['X-Spam-Report'];
      for (name in report) {
        test[name] += report[name];
      });
    };

    db.spam.report.drop();
    for (name in test) {
      db.spam.report.insert({ name: name,  total: test[name] });
    };

Oto wyniki:

    db.spam.report.find(null, {_id: 0}).sort({total: -1});
      { "name" : "BAYES_99", "total" : 169365 }
      { "name" : "RCVD_IN_XBL", "total" : 95607 }
      { "name" : "RCVD_IN_BL_SPAMCOP_NET", "total" : 47630 }
      { "name" : "URIBL_BLACK", "total" : 43162 }
      { "name" : "RAZOR2_CF_RANGE_E8_51_100", "total" : 35253 }
      { "name" : "RCVD_IN_PBL", "total" : 32782.5 }
      { "name" : "URIBL_WS_SURBL", "total" : 25630.5 }
      { "name" : "MIME_HTML_ONLY", "total" : 25533 }
      { "name" : "URIBL_JP_SURBL", "total" : 25216.5 }
      { "name" : "URIBL_SBL", "total" : 22689 }
      { "name" : "URIBL_AB_SURBL", "total" : 21483.3 }
      { "name" : "RAZOR2_CF_RANGE_E4_51_100", "total" : 15412.5 }
      { "name" : "RAZOR2_CHECK", "total" : 14772 }
      { "name" : "RAZOR2_CF_RANGE_51_100", "total" : 14392 }
      ... top 14 ...


### Spamerzy

Pierwsze podejście: skąd jest wysyłane najwięcej emaili z takim
samym tematem?

Tematy — Top 13:

    :::javascript
    db.spam.subjects.find().sort({value: -1})
      { "_id" : "Undelivered Mail Returned to Sender", "value" : 703 }
      { "_id" : "hello", "value" : 684 }
      { "_id" : "hi!", "value" : 336 }
      { "_id" : "International Real Estate Consulting Company needs local representation", "value" : 189 }
      { "_id" : "International Real Estate Consulting", "value" : 178 }
      { "_id" : "Re:", "value" : 161 }
      { "_id" : "Fw:", "value" : 159 }
      { "_id" : "Fwd:", "value" : 156 }
      { "_id" : "From International Real Estate Consulting", "value" : 153 }
      { "_id" : "from international company", "value" : 152 }
      { "_id" : "setting for your mailbox root.univ.gda.pl are changed", "value" : 110 }
      { "_id" : "hi", "value" : 89 }
      { "_id" : "Your wife photos attached", "value" : 88 }
      ... top 13 ...

Kto to rozsyła – Spamerzy ?

    :::javascript spamers.js
    var cursor =  db.spam.subjects.find().sort({value: -1}).limit(13);
    // -> scope
    var subject = {};
    cursor.forEach(function(doc) {
      subject[doc._id] = doc.value;
    });

    m = function() {
      var s = this['Subject'];
      if (subject[s]) {
        emit(this['From'], 1);
      };
    };
    r = function(key, values) {
      var value = 0;
      values.forEach(function(count) {
        value += count;
      });
      return value;
    };

    res = db.spam.mapReduce(m, r, {out: "spammers", scope: {subject: subject}});
    printjson(res);

*Uwaga:* skrypt korzysta ze zmiennej *subject*.
Po umieszczeniu zmiennej w **scope** jest ona dostępna
w funkcjach map, reduce i finalize.

Wykonujemy skrypt:

    mongo mapreduce spamers.js --shell

i sprawdzamy wyniki:

    :::javascript
    db.spammers.find().sort({value: -1})
      { "_id" : "MAILER-DAEMON@inf.ug.edu.pl (Mail Delivery System)", "value" : 702 }
      { "_id" : "nina.univ.gda.pl", "value" : 570 }
      { "_id" : "mailer-daemon@math.univ.gda.pl", "value" : 238 }
      { "_id" : "mailer-daemon@manta.univ.gda.pl", "value" : 228 }
      { "_id" : "adm@manta.univ.gda.pl", "value" : 221 }
      { "_id" : "nina@math.univ.gda.pl", "value" : 215 }
      { "_id" : "root@math.univ.gda.pl", "value" : 79 }
      { "_id" : "support@manta.univ.gda.pl", "value" : 4 }
      { "_id" : "viteev@mail.ru", "value" : 3 }

Wnioski nasuwają się same. Jakie?

<!--

Na dłuższą metę ręczne sprawdzanie wyników na konsoli jest uciążliwe.
W skryptach poprawność wyników będziemy sprawdzać
za pomocą wbudowanej funkcji *assert*. W tym celu zmienimy
dwie ostatnie linijki skryptu *wc.js*:

    :::javascript
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

Użyteczna funkcja:

    printjson(res);

-->
