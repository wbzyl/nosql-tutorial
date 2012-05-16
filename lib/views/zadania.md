#### {% title "Zadania" %}

<blockquote>
 <p>
   After three days without programming, life becomes meaningless.
 </p>
 <p class="author">[The Tao of Programming 2.1]</p>
</blockquote>

Warunkiem zaliczenia ćwiczeń jest:

* Wyszukanie w sieci interesujących danych.
* Zapisanie tych danych w jednej z baz: MongoDB, CouchDB lub Elasticsearch.
* Napisanie skryptu, który przeniesie zapisane dane do innej bazy
  (tutaj można wybrać bazę PostgreSQL).
* Napisanie funkcji map oraz reduce dla swoich danych,
  dla baz MongoDB oraz CouchDB.
* Wrzucenie wszystkich tych rzeczy wraz z krótkim opisem tego co zostało
  zrobione (w pliku *README.md*) do repozytorium Git’a.
  Adres repozytorium należy wpisać w polu *comments*
  na swojej liście obecności.

Ostateczny termin wpisania adresu repozytorium z rzeczami
na zaliczenie upływa *17.05.2012*.

**Nowe:** Zadanie *bonusowe* za 5-20 pkt. Należy zgłosić *pull request*,
repozytorium [water](https://github.com/wbzyl/water),
z przykładem ilustrującym możliwości biblioteki *d3.js*.

Kilkanaście gotowych przykładów jest
[tutaj](https://github.com/wbzyl/water/tree/master/examples)
i wszystkie można obejrzeć [tutaj, circle-05](http://deep-water.herokuapp.com/#circle-05).
Jak zgłaszać *pull request* przedstawiono w artykule
[How to GitHub: Fork, Branch, Track, Squash and Pull Request](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).

Na ocenę db z egzaminu należy przygotować aplikację
korzystającą z obliczeń MapReduce.
Na ocenę bdb należy przygotować prezentację
z jednego z tematów podanych na stronie głównej tego wykładu.


## Typowe zastosowania dokumentowych baz danych

* Contact Address/Phone Book
* Forum/Discussion
* Bug Tracking
* Document Collaboration/Wiki
* Customer Call Tracking
* Expense Reporting
* To-Dos
* Time Sheets
* E-mail
* Help/Reference Desk
* CRM(?)

Typowe zastosowania baz klucz-wartość to:

* …

Typowe zastosowania grafowych baz danych to:

* …


<blockquote>
 {%= image_tag "/images/hemingway_and_marlins.jpg", :alt => "[Ernest Hemingway and marlins]" %}
 <p>
  Wszystko, co musisz zrobić, to napisać jedno prawdziwe zdanie.
  Napisz najprawdziwsze zdanie, jakie znasz.
 </p>
 <p class="author">— Ernest Hemingway</p>
</blockquote>

## A to co za zadanie?

{%= image_tag "/images/es-mongo-couch.png", :alt => "[ES - Mongo - Couch]" %}

Zaczynamy od pobrania danych w formacie TSV o pojawieniach się UFO w USA,
dane o katastrofach, oraz danych tekstowych ze stacji meteo na lotnisku w Rębiechowie
i danych w formacie [GPX](http://www.topografix.com/GPX/1/0/gpx.xsd)
z wycieczki w okolicach Zakopanego, dane w formacie JSON zawierający uri zdjęć
ze współrzędnymi GEO:

    git clone git://sigma.ug.edu.pl/~wbzyl/infochimps.git

Dane pochodzą z serwisu [Infochimps](http://www.infochimps.com/).
Dane o UFO zostały „cleaned up”. Dane są zapisane w formacie TSV.

50,000+ tweets zebranych w kwietniu 2012, plik *tweets.json.gz*.
Słowa kluczowe: rails, elasticsearch, redis, mongodb, couchdb, jquery.

Zapisać dane w jednej z baz: Elasticsearch albo MongoDB, albo CouchDB.
Następnie wyeksportować z tej bazy dane do pliku w formacie JSON.
Na koniec zapisać dane w formacie w JSON w pozostałych dwóch bazach.

W repozytorium jest też skrypt importujący dane *flickr_search.json*
do bazy CouchDB. Najpierw tworzymy w Futonie bazę *tatry*, a następnie
wykonujemy:

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


### Nieco informacji o danych

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

Na Infochimps znajdziemy dużo interesujących danych, na przykład:

* [The First Billion Digits of Pi](http://www.infochimps.com/datasets/the-first-billion-digits-of-pi)
* [Word List - 350,000+ Simple English Words (Excel readable)](http://www.infochimps.com/datasets/word-list-350000-simple-english-words-excel-readable)


## MongoDB

1\. Ze strony [Zasoby](http://korpus.pl/index.php?page=download)
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

**Zadanie 1.** Wykonać „pivot” na dokumentach. Oznacza to, że należy zamienić
wszystkie dokumenty według schematu:

    :::json
    {
      "base" : "ziemski",
      "lex" : [
         {
           "orth" : "ziemskimi",
           "ctag" : "adj:pl:inst:n:pos"
         }
      ],
      "_id" : ObjectId("4faeb1778de17f7162000001")
    }

*Uwaga:* "lex" jest tablicą! *Wskazówka:* zadanie na MapReduce.

<!--
Można zacząć od skopiowania bazy na konsoli *mongo*:

    :::js
    db.toks.copyTo("base")
-->

Wyszukiwarki:

* [Poliqarp](http://korpus.pl/poliqarp/poliqarp.php); konkordancje
* [PELCRA](http://nkjp.uni.lodz.pl/); konkordancje + kolokator


<h2 class="clear">CouchDB</h2>

<blockquote>
 <p>
  A well-written program is its own heaven; a poorly-written program is its own hell.
 </p>
 <p class="author">[The Tao of Programming 4.1]</p>
</blockquote>

1\. Baza (CouchDB) „książki” zawiera dokumenty z informacjami o książkach,
na przykład:

    :::javascript books
    {
      "_id": "3194d86ab7cb2c1465fa5fea901f4c55",
      "_rev": "1-2724eb06ca15197e71e13e1b46b75aee",
      "isbn": "1844571696",
      "isbn13": "",
      "book_id": "100_shakespeare_films_a01"
    }

Bazę *books* oraz inne bazy można przeglądać (oraz replikować)
w trakcie zajęć pod adresem:

     http://wbzyl.inf.ug.edu.pl:5984/_utils/

Inne dokumenty mogą zawierać inne pola: *publisher*, *authors*, *title*.

Napisać widok wyliczający ile i jakie pola zawarte są w dokumentach tej bazy.
Niektóre pola są puste. Uwzględnić to w rachunkach.


# TODO

1\. Wizualizacja przykładowych danych.
Klasyczny przykład opisałem w „Generator przemówień i inne zastosowania…”.

2\. [Anagram Finder](http://www.anagramfinder.net/).
Dokumentacja [Anagram Finder: A Do-It-Yourself Little Big Data Project](http://www.databonanza.com/2011/09/anagram-finder-do-it-yourself-little.html). Napisać coś takiego w CouchDB? MongoDB?

2\. **SQL & JSON**. [Yahoo! Query Language](http://developer.yahoo.com/yql/).
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

3\. [BigQuery](http://code.google.com/intl/pl/apis/bigquery/) –
is a web service that enables you to do interactive analysis of
massively large datasets.
Both RESTful and JSON-RPC methods are available. Queries are expressed
in a SQL dialect.

4\. [Building a Twitter Filter With Sinatra, Redis, and
TweetStream](http://www.digitalhobbit.com/2009/11/08/building-a-twitter-filter-with-sinatra-redis-and-tweetstream/).

Linki:

* Twitter [Streaming API Documentation](http://apiwiki.twitter.com/Streaming-API-Documentation)
* [tweetstream](http://github.com/intridea/tweetstream) – a RubyGem to access the Twitter Streaming API

3\. [NoSQL Twitter Applications](http://nosql.mypopescu.com/post/319859407/nosql-twitter-applications).

4\. [Usecase: NoSQL-based Blogs](http://nosql.mypopescu.com/post/346471814/usecase-nosql-based-blogs).

5\. [Note taking apps a la NoSQL](http://nosql.mypopescu.com/post/425140372/note-taking-apps-a-la-nosql).

6\. Redis:

* Rob Watson. [A Redis-powered newsfeed
  implementation](http://rfw.posterous.com/a-redis-powered-newsfeed-implementation)

7\. NodeJS:

* Rob Watson. [How NodeJS saved my web
  application](http://rfw.posterous.com/how-nodejs-saved-my-web-application)

8\. Michael Dirolf.
[Getting Non-Relational with MongoDB](http://www.softdevtube.com/2010/03/15/getting-non-relational-with-mongodb/) —
This talk will introduce MongoDB and discuss some of the reasons why
MongoDB might be the right choice for your project. It will include an
overview of MongoDB as well as detailed examples using MongoDB in
Ruby.

<embed src='http://rubyconf2009.confreaks.com/player.swf' height='285' width='480' allowscriptaccess='always' allowfullscreen='true' flashvars='image=images%2F19-nov-2009-16-20-getting-non-relational-with-mongodb-michael-dirolf-preview.png&file=http%3A%2F%2Frubyconf2009.confreaks.com%2Fvideos%2F19-nov-2009-16-20-getting-non-relational-with-mongodb-michael-dirolf-small.mp4&plugins=viral-1'/>

9\. [MySQL vs MongoDB](http://blog.boardtracker.com/viewtopic.php?f=4&t=75)

10\. Ian Warshak.
[Faceted search with MongoDB](http://ianwarshak.posterous.com/faceted-search-with-mongodb) —
przepisać na CouchDB.

7\. [MongoDB geospatial examples in Ruby](http://codesnotdead.blogspot.com/2010/03/mongodb-geospatial-indexing-examples-in.html) — przepisać na CouchDB.

8\. [CouchDB Case Studies](http://nosql.mypopescu.com/post/597651382/couchdb-case-studies)

9\. [A NoSQL Use Case: URL Shorteners](http://nosql.mypopescu.com/post/597603446/a-nosql-use-case-url-shorteners): MongoDB+Redis, Riak+Sinatra, [CouchDB](http://github.com/janl/io).


# Prezentacje (ok. 30 min.)

* **Cassandra** — podstawy, indeksowanie, wyjaśnić
  pojęcie *kolumnowa baza danych*, wyjaśnić dlaczego odczytywanie
  danych z bazy jest tak szybkie
  -- [kilka linków na początek](http://nosql.mypopescu.com/post/660373825/presentation-cassandra-basics-indexing)
* [Node.JS + Riak](http://nosql.mypopescu.com/post/654107903/presentation-an-introduction-to-node-js-and-riak) – koszt operacji IO „Numbers Everyone Should Know”
