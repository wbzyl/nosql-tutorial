# Bazy NoSQL

<blockquote>
 {%= image_tag "/images/conan_doyle.jpg", :alt => "[Sir Arthur Conan Doyle]" %}
 <p>
   I never guess. It is a capital mistake to theorize before one has
   data. Insensibly one begins to twist facts to suit theories, instead
   of theories to suit facts.
 </p>
 <p class="author">— Sir Arthur Conan Doyle</p>
</blockquote>

<!--

[2011.02.15] Coś do poczytania –
[Sapling Learning Blog](http://blog.saplinglearning.com/2011/02/data-mining-6-things-i-learned-from.html).
A jakie są nasze zwyczaje?

[2011.02.15] Poprawiłem opis instalacji programów z których będziemy korzystać.
Proszę **przed następnymi zajęciami** zainstalować wszystkie programy.
Jeśli pojawią się jakieś problemy proszę o maila.

[2011.02.16] Termin konsultacji: poniedziałek, g. 15.30, p. 228.

-->

Wszystkie prace przygotowywane w ramach zajęć muszą działać na *Sigmie*.
Dla prac należy założyć „free” repozytorium na serwerze *github.com*.
Repozytorium należy nazwać **nosql**.
(W miarę możliwości należy stosować się do uwag Tima Pope,
[A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).)

Implementacje należy przygotować w jednym z języków:
Javascript, Ruby, Perl, Python, Scala
(zob. też [top languages](https://github.com/languages)).


## Co to jest „NoSQL”

Termin „NoSQL” można rozszyfrować jako ***Not only SQL***. Carlo
Strozzi wprowadził ten termin w 1998 roku. W 2009 roku Eric Evans
użył terminu NoSQL w kontekście „the emergence of a
growing number of non-relational, distributed data stores”
([wikipedia](http://en.wikipedia.org/wiki/NoSQL)).

Więcej informacji o „NoSQL” zebrałem {%= link_to "tutaj", "/motywacja" %}.
Dodatkowo warto przeczytać artykuł Teda Newarda,
[The Vietnam of Computer Science](http://blogs.tedneward.com/2006/06/26/The+Vietnam+Of+Computer+Science.aspx).


## CouchDB

1. {%= link_to "Oswajamy CouchDB", "/couchdb" %}
1. {%= link_to "Korzystamy z RESTFUL API", "/couchdb-crud" %}
1. {%= link_to "Replikacja – jakie to proste!", "/couchdb-replication" %}
1. {%= link_to "ElasticSearch – odjazdowy „sweet spot”", "/couchdb-elasticsearch" %}
1. {%= link_to "Funkcje Show", "/couchdb-show" %}
1. {%= link_to "Futon: Map ⇒ Reduce → Rereduce", "/couchdb-futon" %}
1. {%= link_to "Views ≡ Map + Reduce", "/couchdb-views" %}
1. {%= link_to "Funkcje Lists", "/couchdb-lists" %}
1. {%= link_to "CouchDB & Ruby", "/couchdb-ruby" %}
1. {%= link_to "Rewrite – przepisywanie adresów URL", "/couchdb-rewrite" %}
1. {%= link_to "KansoJS framework dla CouchDB", "/couchdb-kansojs" %}
1. {%= link_to "Walidacja", "/couchdb-validation" %}

<!--

TODO:

1. {%= link_to "CouchApp", "/couchdb-couchapp" %}
1. {%= link_to "Autentykacja", "/couchdb-authentication" %}
1. {%= link_to "Apache", "/couchdb-apache" %}

-->

## MongoDB

1. {%= link_to "Oswajamy MongoDB", "/mongodb" %}
1. {%= link_to "Replikacja", "/mongodb-replikacja" %}
1. {%= link_to "Sharding", "/mongodb-sharding" %}


## Redis

1. {%= link_to "Oswajamy bazę Redis", "/redis" %}


## Różne rzeczy

1. {%= link_to "Spidermonkey", "/couchdb-spidermonkey" %}
1. {%= link_to "Mustache – wąsate szablony", "/mustache" %}
1. {%= link_to "Dostęp do CouchDB via NodeJS", "/couchdb-nodejs" %}


# Laboratorium

*  {%= link_to "Instalacja i konfiguracja baz: CouchDB, MongoDB, Redis", "/instalacja" %}
*  {%= link_to "Zadania", "/zadania" %}


# Referaty

* Elasticsearch – howto wyszukiwania (np. co to są *facets*),
  import bazy do elasticsearch, połączenie z CouchDB (przykład)
* [Neo4j](http://neo4j.org/) – instalacja na Sigmie, przykład objaśniający
  ideę grafowych baz danych (diagramy, [narzędzie do rysowania](https://cacoo.com/))
  (<i>M. Kaliszuk, M. Kaszałowicz, M. Tupacz, M. Maszkiewicz</i>)
* [Hadoop](http://hadoop.apache.org/) – instalacja na Sigmie, przykład objaśniający jak to działa (diagramy),
  do czego można użyć hadoopa, hadoop mapreduce w przykładach
  (<i>Sz. Szypulski, M. Chadaj, B. Drzazgowski, D. Zmitrowicz</i>)
* Narzędzia do wizualizacji baz danych – zacząć od projektu [Simile](http://simile.mit.edu/),
  przykłady tylko dla JSONów (<em>M. Rusajczyk, M. Pętlicki, M. Smolinski</em>)


# Przykładowe bazy danych

* {%= link_to "CouchDB", "/couchdb-databases" %}
* {%= link_to "MongoDB", "/mongodb-databases" %}
* {%= link_to "Redis", "/redis-databases" %}


# Wizualizacje danych

* [Strata Conference | Twitter Analysis](http://strataconf.nexalogy.com/)


# Databases in the wild

Infochimps – find the world's data:

* [Infochimps Data Marketplace + Commons: Download Sell or Share Databases, statistics, datasets for free](http://infochimps.com/)
* [Million Songs](http://infochimps.com/collections/million-songs) – ok 200GB danych
* [Daily 1970-2010 Open, Close, Hi, Low and Volume (NASDAQ exchange)](http://infochimps.com/datasets/daily-1970-2010-open-close-hi-low-and-volume-nasdaq-exchange)

Twitter:

* [How Tweet It Is!: Library Acquires Entire Twitter Archive](http://blogs.loc.gov/loc/2010/04/how-tweet-it-is-library-acquires-entire-twitter-archive/)

Google:

* [Books Ngram Viewer](http://ngrams.googlelabs.com/)

Amazon public datasets:

* [The WestburyLab USENET corpus](http://aws.amazon.com/datasets/1679761938200766) – 40GB
* [Wikipedia Traffic Statistics V2](http://aws.amazon.com/datasets/4182)
* [Daily Global Weather Measurements, 1929-2009 (NCDC, GSOD)](http://aws.amazon.com/datasets/2759) – 20GB

Newspapers:

* [Times Developer Network - Welcome](http://developer.nytimes.com/) –
  [API Request Tool](http://prototype.nytimes.com/gst/apitool/index.html);
  zob. API artykułów oraz filmów (<i>Marcin Sulkowski</i>)

Movies:

* [](ftp://ftp.fu-berlin.de/pub/misc/movies/database/) (<i>Marian Smolinski</i>)

[Geobytes](http://geobytes.com/) – GeoWorldMap w formacie CSV
(denormalizacja, konwersja na UTF-8).

[Enron Email Dataset](http://www.cs.cmu.edu/~enron/) – ok. 400MB.

[PDX API](http://www.pdxapi.com/) i [CivicApps](http://www.civicapps.org/);
zob. też [Code for America](http://codeforamerica.org/),
[Max Ogden on twitter](http://twitter.com/#!/maxogden)
oraz E. Knuth [bulk loading shapefiles into postgis](http://iknuth.com/2010/05/bulk-loading-shapefiles-into-postgis/).


# Linki

* [myNoSQL](http://nosql.mypopescu.com/)
* [HTML5](http://html5.org/) – najważniejsze linki
* [HTML5 Draft](http://www.whatwg.org/specs/web-apps/current-work/multipage/)
* [HTML5 differences from HTML4](http://dev.w3.org/html5/html4-differences/)
* [CSS3.info](http://www.css3.info/)
* [jQuery](http://jquery.com/), [JS Bin](http://jsbin.com/)
* [Code Conventions for the JavaScript Programming Language](http://javascript.crockford.com/code.html)
* [Introducing JSON](http://www.json.org/) ([polska wersja strony](http://www.json.org/json-pl.html))


Ściągi:

* [CouchDB API Cheatsheet](http://wiki.apache.org/couchdb/API_Cheatsheet),
  [Quering Options](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options),
  [The Antepenultimate CouchDB Reference Card](http://blog.fupps.com/2010/04/20/the-antepenultimate-couchdb-reference-card/)
  (Jan-Piet Mens)
* [CSS3 Cheat Sheet](http://www.smashingmagazine.com/2009/07/13/css-3-cheat-sheet-pdf/)


Różne:

* [Cloudant](https://cloudant.com/#!/solutions/cloud)
* [CouchOne](http://www.couchone.com/get)
* Susan Potter. Why proponents of marriage equality should love graph databases,
  [Part 1: A Reply to „The Database Engineering
  Perspective”](http://geek.susanpotter.net/2010/03/why-proponents-of-marriage-equality.html)
* [Gay marriage: the database engineering perspective](http://qntm.org/gay)
* [NOSQL Databases for web CRUD (CouchDB) —
  Shows/Views](http://www.ilyasterin.com/blog/2010/02/nosql-databases-for-web-crud-couchdb-showsviews.html)
* [Why Herb Kelleher (of SouthWest) invented
  NoSQL](http://blog.acaro.org/entry/why-herb-kelleher-of-southwest-invented-nosql)
* Michael Will.
  [Modeling Life and Data](http://www.geopense.net/distrib/cassandra-life-science.pdf)
* [ACID Transactions Are Overrated](http://infogrid.org/blog/2010/08/acid-transactions-are-overrated/)
* [A demo Rails app that shows of loose_change and geocouch](https://github.com/joshuamiller/loose_change_demo)
* [Cassandra vs MongoDB vs CouchDB vs Redis vs Riak vs HBase comparison](http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis)
* [PDX API](http://www.pdxapi.com/) – is a JSON API that provides
  access to geographic and real time data from Portland;
  [aplikacja CouchApp + narzędzia do konwersji danych](https://github.com/maxogden/PDXAPI)
* [Fluid user interface components](http://www.fluidproject.org/).
  [Setting Up CouchDB and Lucene](http://wiki.fluidproject.org/display/fluid/Setting+Up+CouchDB+and+Lucene)
* [**Open**Government](http://opengovernment.org/) (źródła na [githubie](https://github.com/opengovernment))
* Rob Ashton.
  [RavenDB vs MongoDB - Why I don't usually bother](http://codeofrob.com/archive/2011/01/26/ravendb-vs-mongodb-why-i-dont-usually-bother.aspx)
* [Data Modeling in Performant Systems](http://railstips.org/blog/archives/2011/01/27/data-modeling-in-performant-systems/) (from [Moneta](https://github.com/wycats/moneta) to [ToyStore](https://github.com/newtoy/toystore))
* Chris Storm. [couch_docs](http://github.com/eee-c/couch_docs) —
  provides a mapping between CouchDB documents and the file system
* [Add a Searchbox to your CouchApps and CouchDB Databases in 10 Minutes](http://blog.cloudant.com/searchapp-add-a-searchbox-to-your-couchapps-and-couchdb-databases-in-10-minutes/)
* [Ion](https://github.com/rstacruz/ion) – wyszukiwanie z redis+ruby ohm,
  [dokumentacja](http://ricostacruz.com/ion/) (rocco)
* John Mettraux. [Rufus-jig](https://github.com/jmettraux/rufus-jig) –
  a HTTP client, greedy with JSON content, GETting conditionally (Ruby gem).
* [Orbit: A Slick jQuery Image Slider Plugin](http://www.zurb.com/playground/orbit-jquery-image-slider)
* [nodechat.js – Using node.js, backbone.js, socket.io, and redis to make a real time chat app](http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/)
* [backbone-couchdb](http://janmonschke.github.com/backbone-couchdb/)
  (zob. doc [backbone-couchdb.js](http://janmonschke.github.com/backbone-couchdb/backbone-couchdb.html))
