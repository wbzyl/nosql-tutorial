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

(*K. Chodorow* i *M. Dirolf*, „MongoDB: The Definitive Guide”)

{%= image_tag "/images/mongo-mapreduce.png", :alt => "[MongoDB MapReduce]" %}

Szczegóły:
„When you run a MapReduce on a cluster, each shard performs its own map
and reduce. *mongos* chooses a “leader” shard and sends all the reduced data
from the other shards to that one for a final reduce.
Once the data is reduced to its final form, it will be output
in whatever method you’ve specified.”

(*K. Chodorow*, „Scaling MongoDB”, s. 38)


### Prosty przykład

Zapiszemy dwa przykładowe dokumenty w kolekcji *books*:

    :::js wc.js
    db.books.insert({ _id: 1, filename: "hamlet.txt",  content: "to be or not to be" });
    db.books.insert({ _id: 2, filename: "phrases.txt", content: "to wit" });

Funkcje *m* (map) i *r* (reduce) zdefiniowane poniżej, wysyłamy do kolekcji *books*:

    :::js wc.js
    coll = db.books;
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

### MapReduce

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
      return Array.sum(values);
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
