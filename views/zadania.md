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

Narzędzia przydatne w trakcie EDA:

* [JQ](http://stedolan.github.io/jq/) –
  a lightweight and flexible command-line JSON processor
* [CSVKIT](http://csvkit.readthedocs.org/en/latest/) –
  a suite of utilities for converting to and working with CSV,
  the king of tabular file formats


### Zadanie 1

Co to jest [Exploratory Data Analysis](http://en.wikipedia.org/wiki/Exploratory_Data_Analysis) (EDA)?

{%= image_tag "/images/data-cleaning.png", :alt => "[Data Cleaning]" %}

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

Przykładowy rekord CSV z pliku *Train.csv*:

    :::csv
    "2","How can I prevent firefox from closing when I press ctrl-w",
    "<p>In my favorite editor […]</p>

    <p>Rene</p>
    ","firefox"

Do testowania swoich rozwiązań można skorzystać ze 101 JSON–ów
[fb101.json](https://github.com/nosql/aggregations-2/blob/master/data/wbzyl/fb101.json).
Wybrałem je losowo po zapisaniu rekordów z *Train.csv* w bazie MongoDB.

   ☀☀☀

*Zadanie 1a* polega na zaimportowaniu, do systemów baz danych
uruchomionych na **swoim komputerze**, danych z pliku *Train.csv* bazy:

* MongoDB
* PostgreSQL – opcjonalnie dla znających fanów SQL

*Zadanie 1b.* Zliczyć liczbę zaimportowanych rekordów
(Odpowiedź: imported 6\_034\_195 objects).

*Zadanie 1c.* (Zamiana formatu danych.) Zamienić string zawierający tagi
na tablicę napisów z tagami następnie zliczyć wszystkie tagi
i wszystkie różne tagi. Napisać program, który to zrobi
korzystając z jednego ze sterowników. Lista sterowników
jest na stronie [MongoDB Ecosystem](http://docs.mongodb.org/ecosystem/).


<blockquote>
 {%= image_tag "/images/tukey-john.jpg", :alt => "[John Tukey]" %}
 <p>
  <i>Exploratory Data Analysis</i> (EDA) is an attitude, a state of flexibility,
  a willingness to look for those things that we believe are not there,
  as well as those we believe to be there.
 </p>
 <p class="author">— <a href="http://en.wikipedia.org/wiki/John_Tukey">John Tukey</a></p>
</blockquote>

*Zadanie 1d.* Ściągnąć plik *text8.zip* ze strony
[Matt Mahoney](http://mattmahoney.net/dc/textdata.html) (po rozpakowaniu 100MB):

    :::sh
    wget http://mattmahoney.net/dc/text8.zip -O text8.gz

Zapisać wszystkie słowa w bazie MongoDB.
Następnie zliczyć liczbę słów oraz liczbę różnych słów w tym pliku.
Ile procent całego pliku stanowi:

* najczęściej występujące słowo w tym pliku
* 10, 100, 1000 najczęściej występujących słów w tym pliku

*Wskazówka:* Zaczynamy od prostego EDA. Sprawdzamy, czy plik *text8*
zawiera wyłącznie znaki alfanumeryczne i białe:

    :::sh
    tr --delete '[:alnum:][:blank:]' < text8 > deleted.txt
    ls -l deleted.txt
      -rw-rw-r--. 1 wbzyl wbzyl 0 10-16 12:58 deleted.txt # rozmiar 0 -> OK
    rm deleted.txt

Dopiero teraz wykonujemy te polecenia:

    :::bash
    wc text8
      0         17005207 100000000 text8
    tr --squeeze-repeats '[:blank:]' '\n' < text8 > text8.txt
    wc text8.txt
      17005207  17005207 100000000 text8.txt  # powtórzone 17005207 -> OK

*Zadanie 1e.* Wyszukać w sieci dane zawierające
[obiekty GeoJSON](http://geojson.org/geojson-spec.html#examples).
Zapisać dane w bazie *MongoDB*.

Dla zapisanych danych przygotować 6–9 różnych
[Geospatial Queries](http://docs.mongodb.org/manual/applications/geospatial-indexes/)
(co najmniej po jednym dla obiektów Point, LineString i Polygon).
W przykładach należy użyć każdego z tych operatorów:
**$geoWithin**, **$geoIntersect**, **$near**.

Przykład pokazujący o co chodzi w tym zadaniu.

Poniższe dane zapisujemy w pliku *places.json*:

    :::json places.json
    {"_id": "oakland",  "loc":{"type":"Point","coordinates":[-122.270833,37.804444]}}
    {"_id": "augsburg", "loc":{"type":"Point","coordinates":[10.898333,48.371667]}}
    {"_id": "namibia",  "loc":{"type":"Point","coordinates":[17.15,-22.566667]}}
    {"_id": "australia","loc":{"type":"Point","coordinates":[135,-25]}}
    {"_id": "brasilia", "loc":{"type":"Point","coordinates":[-52.95,-10.65]}}

Importujemy je do kolekcji *places* w bazie *test*:

    :::bash
    mongoimport -c places < places.json

Logujemy się do bazy za pomocą *mongo*. Po zalogowaniu
dodajemy geo-indeks do kolekcji *places*:

    :::js
    db.places.ensureIndex({"loc" : "2dsphere"})

Przykładowe zapytanie z *$near*:

    :::js
    db.places.find({ loc: {$near: {$geometry: origin}} })
    var origin = {type: "Point", coordinates: [0,0]}

Na stronie [GeoCouch](http://wbzyl.inf.ug.edu.pl/nosql/couchdb-geo)
znajdziemy dane z kolekcji *places* naniesione na mapkę.
Korzystając z tej mapki możemy sprawdzić
(biorąc poprawkę na różne skale na osiach i odwzorowanie powierzchni Ziemi na prostokąt)
czy wyniki są prawidłowe:

    :::json
    {"_id": "namibia"}
    {"_id": "augsburg"}
    {"_id": "brasilia"}
    {"_id": "oakland"}
    {"_id": "australia"}

   ☀☀☀

Rozwiązania dla baz MongoDB i PostgreSQL należy przedstawić do 4.11.2013 (**deadline**).

**Uwaga:** Do opisów dodać kilka liczb. Przykładowo, ile czasu trwał
import (skorzystać z polecenia *time*), ile miejsca zajmują kolekcje
(bez indeksów i z indeksami), wykorzystanie pamięci w trakcie importu
(zrzut ekranu z programu monitor systemu;
na przykład *gnome-system-monitor* lub podobny) itp.

Rozwiązania zadania należy przygotować jako
[pull request](https://help.github.com/articles/using-pull-requests)
repozytorium [aggregations-2](https://github.com/nosql/aggregations-2).


<blockquote>
 {%= image_tag "/images/why_manage_your_data.png", :alt => "[Why Manage Your Data]" %}
 <p>
  You’ll know when you’ve gotten past the data management stage: your
 code starts to become shorter, dealing more with mathematical
 transforms and less with handling exceptions in the data. It’s nice
 to come to this stage. It’s a bit like those fights in Lord of the
 Rings, where you spend a lot of time crossing the murky swamp full of
 nasty creatures, which isn’t that much of a challenge, but you could
 die if you don’t pay attention. Then you get out of the swamp and
 into the evil lair and that’s when things get interesting, short and
 quick.
 </p>
 <p class="author"><a href="http://kaushikghose.wordpress.com/2013/09/26/data-management/">Data Management</a></p>
</blockquote>


#### TL;DR

* Przykład EDA – konkurs
  [Kaggle bulldozers: Basic cleaning](http://danielfrg.github.io/blog/2013/03/07/kaggle-bulldozers-basic-cleaning/),<br>
  [nagroda dla najlepszego rozwiązania $10,000](http://www.kaggle.com/c/bluebook-for-bulldozers/data)
* Interesujące dane –
  [Detecting Insults in Social Commentary](http://www.kaggle.com/c/detecting-insults-in-social-commentary/),<br>
  [3948 rekordów](http://www.kaggle.com/c/detecting-insults-in-social-commentary/data);
  zob. też Andreas Mueller [Machine Learning with scikit-learn](http://amueller.github.io/sklearn_tutorial/)


<!--

2013-09-27T13:04:45.582+0200 check 9 6034196
2013-09-27T13:04:45.689+0200

no. of rows: 6,034,195
min. value for Id: 1
max. value for Id: 6,034,195
no. of unique tags: 42,048
no. of occurrences of tags: 17,409,994
max. no. of tags/question: 5
avg. no. of tags/question: 2.89

% of questions with specified no. of tags:

1 : 13.76
2 : 26.65
3 : 28.65
4 : 19.1

PostgreSQL:

create table RAW_TRAIN(ID BIGINT PRIMARY KEY, TITLE TEXT, BODY TEXT, TAGS TEXT);
copy RAW_TEST from '/home/wbzyl/NN/Facebook-Kaggle/train.csv' csv header;

-->


### Zadanie 2 (+1M)

1\. Wyszukać w sieci dane zawierające co najmniej 1_000_000 rekordów/jsonów.

2\. Dane zapisać w bazach MongoDB i Elasticsearch.

3\. Wymyśleć i opisać cztery agregacje – po dwie dla każdej z baz.

4\. Zaprogramować i wykonać wszystkie aggregacje.

5\. Wyniki przedstawić w postaci graficznej (wykresów, itp.).

Również rozwiązania tego zadania należy przygotować jako
[pull request](https://help.github.com/articles/using-pull-requests)
repozytorium [aggregations-2](https://github.com/nosql/aggregations-2).<br>

    ☀☀☀

Termin rozwiązania tego zadania upływa **31.12.2013**.


#### TL;DR

Do czyszczenia danych, jeśli okaże się to konieczne,
można użyć jednego z tych narzędzi:
[Google Refine](http://code.google.com/p/google-refine/) lub
[Data Wrangler](http://vis.stanford.edu/wrangler/).

Szczególnie polecam obejrzenie tych trzech krótkich filmów:
[Intro 1](http://www.youtube.com/watch?v=B70J_H_zAWM),
[Intro 2](http://www.youtube.com/watch?v=cO8NVCs_Ba0),
[Intro 3](https://www.youtube.com/watch?v=5tsyz3ibYzk).



<blockquote>
 {%= image_tag "/images/hemingway_and_marlins.jpg", :alt => "[Ernest Hemingway and marlins]" %}
 <p>
  Wszystko, co musisz zrobić, to napisać jedno prawdziwe zdanie.
  Napisz najprawdziwsze zdanie, jakie znasz.
 </p>
 <p class="author">— Ernest Hemingway</p>
</blockquote>

# Egzamin

Na ocenę db z egzaminu należy wykonać zadanie 3 poniżej.

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
