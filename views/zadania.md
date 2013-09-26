#### {% title "Laboratorium" %}

<blockquote>
 {%= image_tag "/images/tao.jpg", :alt => "[Tao]" %}
 <p>
   After three days without programming, life becomes meaningless.
 </p>
 <p class="author"><a href="http://www.canonical.org/~kragen/tao-of-programming.html">The Tao of Programming 2.1</a></p>
</blockquote>

Aby zaliczyć laboratorium należy przeczytać
[The Science of Scientific Writing](http://www.americanscientist.org/issues/id.877,y.0,no.,content.true,page.1,css.print/issue.aspx)
i wykonać zadania 1 i 2:

### Zadanie 1

Na [Kaggle](https://www.kaggle.com/) znajdziemy dużo interesujących danych.
W sierpniu 2013 Facebook ogłosił konkurs
[Identify keywords and tags from millions of text questions](https://www.kaggle.com/c/facebook-recruiting-iii-keyword-extraction).
Skorzystamy z danych udostępnionych na ten konkurs przez
[Stack Exchange](http://stackexchange.com/):

* [Train.zip](https://www.kaggle.com/c/facebook-recruiting-iii-keyword-extraction/download/Train.zip) – 2.19 GB

Archiwum *Train.zip* zawiera plik *Train.csv* (6.8 GB).
Każdy rekord zawiera cztery pola `"Id","Title","Body","Tags"`:

* `Id` – Unique identifier for each question
* `Title` – The question's title
* `Body` – The body of the question
* `Tags` – The tags associated with the question (all lowercase, should not contain tabs '\t' or ampersands '&')

Przykładowy rekord:

    :::csv
    "2","How can I prevent firefox from closing when I press ctrl-w","<p>In my favorite editor […]</p>

    <p>Rene</p>
    ","firefox"

Zadanie polega na zaimportowaniu danych z pliku *Train.csv* do baz
MongoDB i PostgreSQL. Po zaimportowaniu należy zliczyć liczbę
zimportowanych rekordów. Dodatkowo należy zliczyć liczbę różnych
tagów.


### Zadanie 2

* Wyszukać w sieci ciekawe dane.
* Jeśli to konieczne, oczyścić dane za pomocą jednego z narzędzi:
  [Google Refine](http://code.google.com/p/google-refine/)
  ([Intro 1](http://www.youtube.com/watch?v=B70J_H_zAWM),
  [Intro 2](http://www.youtube.com/watch?v=cO8NVCs_Ba0),
  [Intro 3](https://www.youtube.com/watch?v=5tsyz3ibYzk))
  lub
  [Data Wrangler](http://vis.stanford.edu/wrangler/).
* Zapisać dane w jednej z baz: MongoDB, CouchDB lub Elasticsearch.
  (Oczywiście, należy uzyć skryptu, który to za nas zrobi.)
* Obmyśleć, zaprogramować i wykonać prostą aggregację na danych
  zapisanych w bazie.
  Dodać opis tego co zostało zrobione do tego repozytorium
  [Aggregations-2](https://github.com/nosql/aggregations-2).
  Jeśli dane były czyszczone, to dodać opis jak i co oraz dlaczego
  dane były czyszczone.


<blockquote>
 {%= image_tag "/images/hemingway_and_marlins.jpg", :alt => "[Ernest Hemingway and marlins]" %}
 <p>
  Wszystko, co musisz zrobić, to napisać jedno prawdziwe zdanie.
  Napisz najprawdziwsze zdanie, jakie znasz.
 </p>
 <p class="author">— Ernest Hemingway</p>
</blockquote>

# Egzamin

Na ocenę dst z egzaminu należy wykonać zadanie 3 poniżej.

### Zadanie 3

* Przygotować funkcje map oraz reduce w MongoDB lub CouchDB.
  Dla danych zapisanych w Elasticsearch przygotować
  [faceted search](http://www.elasticsearch.org/guide/reference/api/search/facets/))
* Dodać opis tego co zostało zrobione do tego repozytorium:
  [MapReduce-2](https://github.com/nosql/mapreduce-2).

Do eksperymentów można użyć tych danych wzorcowych:

* [PUMA: Purdue MapReduce Benchmarks Suite](http://web.ics.purdue.edu/~fahmad/benchmarks.htm)
* [PUMA Benchmarks and dataset downloads](http://web.ics.purdue.edu/~fahmad/benchmarks/datasets.htm)

Na wyższą ocenę należy przygotować w zespole 4–5 osobowym aplikację
wykorzystujacą jedną z baz danych NoSQL albo
przygotować prezentację
jednego z tematów podanych na stronie głównej tego wykładu.



# Przykładowe zadania z MapReduce

1\. Znaleźć najczęściej występujące słowa w [Wikipedia data PL](http://dumps.wikimedia.org/plwiki/20130101/)
(ok. 1 GB).

2\. Matrix-Vector Multiplication by Map-Reduce. Przeczytać rozdziały
[2.3.1, 2.3.10–11](http://infolab.stanford.edu/~ullman/mmds/ch2a.pdf) i zaimplementować
jeden z opisanych tam sposobów mnożenia macierzy w MongoDB.

3\. Zaprojektować i zaimplementować algorytm map-reduce który dla bardzo dużego zbioru
liczb całkowitych wyliczy:
(a) największą liczbę występujaca w tym zbiorze,
(b) średnią z liczb z tego zbioru,
(c) liczby które występują najczęściej w tym zbiorze,
(d) liczbę różnych liczb z tego zbioru.

Zadania 2–3 pochodzą z rozdziału 2
[Large-Scale File Systems and Map-Reduce](http://infolab.stanford.edu/~ullman/mmds/ch2a.pdf)
książki A. Rajaramana i J. Ullmana, [Mining of Massive Datasets](http://infolab.stanford.edu/~ullman/mmds.html).


{%= image_tag "/images/es-mongo-couch.png", :alt => "[ES - Mongo - Couch]" %}

# Zadania różne


## Data Science

Bill Howe, [Introduction to Data Science](https://class.coursera.org/datasci-001/class/index).

* [assignments](https://class.coursera.org/datasci-001/assignment/index)
* [repozytorium z assignments](https://github.com/uwescience/datasci_course_materials):
  assignment3 zawiera zadania na MapReduce


## UFO

Pobieramy dane w formacie TSV o pojawieniach się UFO w USA,
dane o katastrofach, oraz danych tekstowych ze stacji meteo na lotnisku w Rębiechowie
i danych w formacie [GPX](http://www.topografix.com/GPX/1/0/gpx.xsd)
z wycieczki w okolicach Zakopanego, dane w formacie JSON zawierający uri zdjęć
ze współrzędnymi GEO:

    git clone git://sigma.ug.edu.pl/~wbzyl/infochimps.git

Dane pochodzą z serwisu [Infochimps](http://www.infochimps.com/).
Dane o UFO zostały „cleaned up”. Dane są zapisane w formacie TSV.

Dane o UFO zawierają następujące pola:

    DateOccurred, DateReported, Location, ShortDescription,
    Duration, LongDescription, USCity, USState, YearMonth

Dane z katastrofami zawierają następujące pola:

<table>
<colgroup>
  <col width="150px">
  <col width="450px">
</colgroup>
<tbody>
<tr><th>Start      <td>The date which the disaster began
<tr><th>End        <td>The date which the disaster ended
<tr><th>Country    <td>Country(ies) in which the disaster has occurred
<tr><th>Location   <td>A sub-location classification if available
<tr><th>Type       <td>The type of disaster according to pre-defined classification
                   (Geophysical, Meteorological, Hydrological, Climatological, Biological)
<tr><th>Sub_Type   <td>Further classification of the type of disaster
<tr><th>Name       <td>The name of the disaster if available
<tr><th>Killed     <td>Persons confirmed as dead and persons missing and presumed dead
                   (official figures when available)
<tr><th>Affected   <td>Total of people injured, homeless, and affected. Where
                   affected means people requiring immediate assistance during a period
                   of emergency;it can also include displaced or evacuated people
<tr><th>Cost       <td>Several institutions have developed methodologies to quantify
                   these losses in their specific domain. However, there is no standard
                   procedure to determine a global figure for economic impact. Estimated
                   damage are given.
<tr><th>Id         <td>A unique identifier for the disaster
</tbody>
</table>

Na Infochimps znajdziemy inne interesujące dane, na przykład:

* [The First Billion Digits of Pi](http://www.infochimps.com/datasets/the-first-billion-digits-of-pi)
* [Word List - 350,000+ Simple English Words (Excel readable)](http://www.infochimps.com/datasets/word-list-350000-simple-english-words-excel-readable)


## Flickr

W repozytorium z notatkami wykładów znajdzimey skrypt importujący dane
*flickr_search.json* do bazy CouchDB.

Najpierw tworzymy w Futonie bazę *tatry*, a następnie wykonujemy:

    :::bash terminal
    node import.js

Skrypt ten jest zmienioną wersją skryptu D. Thompsona:

    :::js import.js
    var cradle = require("cradle")
    , util = require("util")
    , fs = require("fs");

    var connection = new(cradle.Connection)("localhost", 5984);
    var db = connection.database('tatry');

    data = fs.readFileSync("flickr_search.json", "utf-8");
    flickr = JSON.parse(data);

    for(p in flickr.photos.photo) {
      photo = flickr.photos.photo[p];
      photo.geometry = {"type": "Point", "coordinates": [photo.longitude, photo.latitude]};
      photo.image_url_medium =
        "http://farm"+photo.farm+".static.flickr.com/"+photo.server+"/"+photo.id+"_"+photo.secret+"_m.jpg";

      db.save(photo.id, photo, function(er, ok) {
        if (er) {
          util.puts("Error: " + er);
          return;
        }
      });
    }


## Poliqarp & MongoDB

Ze strony [Zasoby](http://korpus.pl/index.php?page=download)
Korpusu Języka Polskiego IPI PAN pobieramy wersję źródłową (XML)
„Słownika frekwencyjnego” [frek.xces.tar.bz2](http://korpus.pl/download/frek.xces.tar.bz2).
Po pobraniu archiwum rozpakowujemy je:

    :::bash
    tar jxf frek.xces.tar.bz2

Następnie pobieramy skrypt {%= link_to "walk-frekwencyjny.js", "/doc/mongodb/walk-frekwencyjny.js" %}
({%= link_to "kod", "/db/mongodb/walk-frekwencyjny.js" %})
i zapisujemy go w katalogu ze słownikiem frekwencyjnym. Instalujemy
moduły użyte w skrypcie i uruchamiamy sam skrypt:

    :::bash
    npm install eyes xml2js findit
    npm install mongodb --mongodb:native
    node walk-frekwencyjny.js

Skrypt wczytuje zawartość każdego pliku XML słownika,
przerabia ją na tablicę JSON-ów i zapisuje je w bazie *poliqarp*
w kolekcji *toks*.
Po zapisaniu wszystkich JSON–ów (ok. 5-10 min), kończymy działanie skryptu
wciskając *CTRL+C*.

Jeśli nie było problemów, to wchodzimy na konsolę *mongo*:

    :::bash
    mongo poliqarp

gdzie sprawdzamy liczbę dokumentów zapisanych w kolekcji
i wypisujemy przykładowy dokument:

    :::js
    db.toks.count()  //=> 661839
    db.toks.findOne()
    {
      "orth" : "Ziemskimi",
      "lex" : [
         {
           "base" : "ziemski",
           "ctag" : "adj:pl:inst:n:pos"
         }
      ],
      "_id" : ObjectId("4faeb1778de17f7162000001")
    }

Znaczenia skrótów użytych w polu *ctag* są opisane na stronie
[Zestaw znaczników morfosyntaktycznych](http://korpus.pl/pl/cheatsheet/node2.html).

1\. Zamienić na małe litery wszystkie słowa "orth" (skrypt *poliqarp-downcase.rb*)

2\. Dodać indeks po polu *orth*:

    :::js
    db.toks.ensureIndex({orth: 1})

3\. Sprawdzić co daje taki indeks:

    :::js
    db.toks.find({orth: "ziemskimi"}).explain()
    {
      "cursor" : "BtreeCursor orth_1",
      "isMultiKey" : false,
      "n" : 3,
      "nscannedObjects" : 3,
      "nscanned" : 3,
      "scanAndOrder" : false,
      "indexOnly" : false,
      "nYields" : 0,
      "nChunkSkips" : 0,
      "millis" : 0,
      "indexBounds" : {
         "orth" : [
             [ "ziemskimi", "ziemskimi" ]
         ]
      },
      "server" : "localhost.localdomain:27017"
    }

Bez indeksu *explain* wypisuje:

    :::json
    "nscannedObjects" : 661839,
    "nscanned" : 661839,
    "nYields" : 2,
    "millis" : 339,

4\. Ten indeks, też się przyda:

    :::js
    db.toks.ensureIndex({"lex.base": 1})
    db.toks.find({"lex.base": "ziemski"}).explain()

**Zadanie 0.** Zaggregować co się da (Aggregation Framework *v2.2+*, MapReduce).

**Zadanie 1.** Usunąć z bazy *toks* duplikaty. Przykładowo, zastąpić
wszystkie 9 dokumentów:

    :::js
    db.toks.find({orth: "kot"}, {_id: 0})
    { "orth" : "kot", "lex" : [ { "base" : "kot", "ctag" : "subst:sg:nom:m2" } ] }
    ...
    { "orth" : "kot", "lex" : [ { "base" : "kot", "ctag" : "subst:sg:nom:m2" } ] }

jednym dokumentem.

Bezpiecznie jest zacząć od skopiowania bazy na konsoli *mongo*:

    :::js
    db.toks.copyTo("base")

i wykonywać eksperymenty na kopii bazy. Teraz, jeśli nawet coś pójdzie nie tak…

**Zadanie 2.** Wykonać „pivot” na dokumentach. Oznacza to, że należy zamienić
wszystkie dokumenty według schematu:

    :::json
    { "_id": "ziemski",
      "value" : [
         { "orth": "ziemskiej", "ctag": "adj:sg:loc:f:pos" },
         ...
         { "orth": "ziemskimi", "ctag": "adj:pl:inst:n:pos" }
      ]
    }

*Uwaga:* "lex" jest tablicą! *Wskazówka:* zadanie na MapReduce.


Wyszukiwarki:

* [Poliqarp](http://korpus.pl/poliqarp/poliqarp.php); konkordancje
* [PELCRA](http://nkjp.uni.lodz.pl/); konkordancje + kolokator


<blockquote>
 <p>
  A well-written program is its own heaven; a poorly-written program is its own hell.
 </p>
 <p class="author">[The Tao of Programming 4.1]</p>
</blockquote>

## Dane z projektu „Open Street Maps”

Dane są do pobrania ze strony [Overpass API](http://www.overpass-api.de/).
Do oczyszczenia i transformacji pobranych danych użyłem programu
[jq](http://stedolan.github.io/jq/).

Przykładowe dane dla prostokąta `[ll, ur] = [[49,14], [55,24]]`,
obejmującego całą Polskę, zostały pobrane za pomocą programu *wget*:

    :::bash
    wget 'http://overpass-api.de/api/interpreter?data=[out:json];node(49,14,55,24)[amenity];out;' -O poland.json

Następnie pobrano dane z tablicy `elements`, które poddano transformacji:

    :::bash
    cat poland.json | \
    jq -c '.elements[] | {_id: .id, tags, location: {type: "Point", coordinates: [.lon, .lat]}}' \
      > osm-data_poland-amenities.json

Oto przykładowy JSON z oczyszczonej kolekcji:

    :::json
    {
      "_id": 21315878
      "location": {
        "type": "Point",
        "coordinates": [ 15.8698636, 49.2201447 ]
      },
      "tags": {
        "amenity": "pub",
        "name": "Sýpky"
      }
    }

Pole `tag`, oprócz pola `amenity` może zawierać inne pola.
Przykładowo `name`, `religion`, `description`, `cargo`.
Na początek należałoby zagregować wszystkie te pola.


## Różności…

0\. Jak zgłaszać *pull request* przedstawiono w artykule
[How to GitHub: Fork, Branch, Track, Squash and Pull Request](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).

1\. Wizualizacja przykładowych danych.
Klasyczny przykład opisałem w „Generator przemówień i inne zastosowania…”.

2\. [Anagram Finder](http://www.anagramfinder.net/).
Dokumentacja [Anagram Finder: A Do-It-Yourself Little Big Data Project](http://www.databonanza.com/2011/09/anagram-finder-do-it-yourself-little.html). Napisać coś takiego w CouchDB? MongoDB?

3\. **SQL & JSON**. [Yahoo! Query Language](http://developer.yahoo.com/yql/).
Zobacz przykłady Zillow, Yelp, Pidgets Geo IP – wybrać format JSON.

[streaming twitter into mongodb](http://eliothorowitz.com/post/459890033/streaming-twitter-into-mongodb):

    curl http://stream.twitter.com/1/statuses/sample.json -u<user>:<password> | mongoimport -c twitter_live

Zamiast twittera użyć YQL. Przygotować przykład.
Link do dokumentacji – [YQL Guide](http://developer.yahoo.com/yql/guide/index.html).


<blockquote>
 {%= image_tag "/images/davy_lecture.jpg", :alt => "[Humphry Davy lecture]" %}
 <p>
  Gromadzenie danych wymaga więcej trudu niż dowodzenie ich słuszności;
  ale jedna dobra wizualizacja
  ma większą wartość niż pomysłowość nawet takiego mózgu, jaki miał Newton.
 </p>
 <p class="author">– Humphry Davy (1778–1829)</p>
</blockquote>

## Wizualizacje

1\. Przygotować przykład korzystający
z [IndexedDB in Firefox 4](http://hacks.mozilla.org/2011/01/indexeddb-in-firefox-4/).
Więcej dokumentacji – [Mozilla Developer Network](https://developer.mozilla.org/en-US/).

Przykład aplikacji offline korzystającej z HTML5 localStorage, np. Offline Apps
[Part 1](http://railscasts.com/episodes/247) & [Part 2](http://railscasts.com/episodes/248).

2\. [BigQuery](http://code.google.com/intl/pl/apis/bigquery/) –
is a web service that enables you to do interactive analysis of
massively large datasets.
Both RESTful and JSON-RPC methods are available. Queries are expressed
in a SQL dialect.

3\. [Building a Twitter Filter With Sinatra, Redis, and
TweetStream](http://www.digitalhobbit.com/2009/11/08/building-a-twitter-filter-with-sinatra-redis-and-tweetstream/).

Linki:

* Twitter [Streaming API Documentation](http://apiwiki.twitter.com/Streaming-API-Documentation)
* [tweetstream](http://github.com/intridea/tweetstream) – a RubyGem to access the Twitter Streaming API

4\. [NoSQL Twitter Applications](http://nosql.mypopescu.com/post/319859407/nosql-twitter-applications).

5\. [Usecase: NoSQL-based Blogs](http://nosql.mypopescu.com/post/346471814/usecase-nosql-based-blogs).

6\. [Note taking apps a la NoSQL](http://nosql.mypopescu.com/post/425140372/note-taking-apps-a-la-nosql).

7\. Redis:

* Rob Watson. [A Redis-powered newsfeed
  implementation](http://rfw.posterous.com/a-redis-powered-newsfeed-implementation)

8\. NodeJS:

* Rob Watson. [How NodeJS saved my web
  application](http://rfw.posterous.com/how-nodejs-saved-my-web-application)

9\. [MySQL vs MongoDB](http://blog.boardtracker.com/viewtopic.php?f=4&t=75)

10\. Ian Warshak.
[Faceted search with MongoDB](http://ianwarshak.posterous.com/faceted-search-with-mongodb) —
przepisać na CouchDB.

11\. [MongoDB geospatial examples in Ruby](http://codesnotdead.blogspot.com/2010/03/mongodb-geospatial-indexing-examples-in.html) — przepisać na CouchDB.

12\. [CouchDB Case Studies](http://nosql.mypopescu.com/post/597651382/couchdb-case-studies)

13\. [A NoSQL Use Case: URL Shorteners](http://nosql.mypopescu.com/post/597603446/a-nosql-use-case-url-shorteners): MongoDB+Redis, Riak+Sinatra, [CouchDB](http://github.com/janl/io).


<!--
**Nowe:** Zadanie *bonusowe* za 5-20 pkt. Należy zgłosić *pull request*,
repozytorium [water](https://github.com/wbzyl/water),
z przykładem ilustrującym możliwości biblioteki *d3.js*.

Kilkanaście gotowych przykładów jest
[tutaj](https://github.com/wbzyl/water/tree/master/examples)
i wszystkie można obejrzeć [tutaj, circle-05](http://deep-water.herokuapp.com/#circle-05).
-->
