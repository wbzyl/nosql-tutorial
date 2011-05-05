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

<!--
<iframe width="640" height="385" src="http://cdn.livestream.com/embed/gigaombigdata?layout=4&clip=pla_770fb9d2-5ee0-4094-946f-09c3a2c4431e&color=0xe7e7e7&autoPlay=false&mute=false&iconColorOver=0x888888&iconColor=0x777777&allowchat=true" style="border:0;outline:0" frameborder="0" scrolling="no"></iframe><div style="font-size:11px;padding-top:10px;text-align:center;width:640px">Watch <a href=http://www.livestream.com/?utm_source=lsplayer&amp;utm_medium=embed&amp;utm_campaign=footerlinks title=live streaming video>live streaming video</a> from <a href=http://www.livestream.com/gigaombigdata?utm_source=lsplayer&amp;utm_medium=embed&amp;utm_campaign=footerlinks title=Watch gigaombigdata at livestream.com>gigaombigdata</a> at livestream.com</div>

[2011.03.28] The Many Faces of MapReduce…

<object width="446" height="326"><param name="movie" value="http://video.ted.com/assets/player/swf/EmbedPlayer.swf"></param><param name="allowFullScreen" value="true" /><param name="allowScriptAccess" value="always"/><param name="wmode" value="transparent"></param><param name="bgColor" value="#ffffff"></param> <param name="flashvars" value="vu=http://video.ted.com/talks/dynamic/DebRoy_2011-medium.flv&su=http://images.ted.com/images/ted/tedindex/embed-posters/DebRoy-2011.embed_thumbnail.jpg&vw=432&vh=240&ap=0&ti=1092&lang=&introDuration=15330&adDuration=4000&postAdDuration=830&adKeys=talk=deb_roy_the_birth_of_a_word;year=2011;theme=a_taste_of_ted2011;theme=new_on_ted_com;theme=words_about_words;theme=how_we_learn;event=TED2011;&preAdTag=tconf.ted/embed;tile=1;sz=512x288;" /><embed src="http://video.ted.com/assets/player/swf/EmbedPlayer.swf" pluginspace="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" wmode="transparent" bgColor="#ffffff" width="446" height="326" allowFullScreen="true" allowScriptAccess="always" flashvars="vu=http://video.ted.com/talks/dynamic/DebRoy_2011-medium.flv&su=http://images.ted.com/images/ted/tedindex/embed-posters/DebRoy-2011.embed_thumbnail.jpg&vw=432&vh=240&ap=0&ti=1092&lang=&introDuration=15330&adDuration=4000&postAdDuration=830&adKeys=talk=deb_roy_the_birth_of_a_word;year=2011;theme=a_taste_of_ted2011;theme=new_on_ted_com;theme=words_about_words;theme=how_we_learn;event=TED2011;"></embed></object>

[2011.04.02] D. Roy, The birth of a word
(the future of data science, extreme data analysis, brilliant visualization)

-->

[2011.04.19] [Where can I get large datasets open to the public?](http://www.quora.com/Data/Where-can-I-get-large-datasets-open-to-the-public),
[Kaggle](http://www.kaggle.com/) – a platform for data prediction competitions that allows
organizations to post their data and have it scrutinized by the world's best data scientists

[2011.04.18] [This Tech Bubble Is Different](http://www.businessweek.com/print/magazine/content/11_17/b4225060960537.htm) –
z historii „big data”: Facebook, Cloudera

[2011.04.07] [How NoSQL Is Helping Allay Seattle’s Radiation Fears](http://www.nytimes.com/external/gigaom/2011/03/31/31gigaom-how-nosql-is-helping-allay-seattles-radiation-fea-40912.html?partner=rss&emc=rss), [Fukushima from Afar](http://blog.cloudant.com/fukushima/) (Mike Miller, 02.04.2011)

[2011.04.04] Następny konkurs.
[The goal of the prize is to develop a predictive algorithm that can identify patients who will be admitted to the hospital within the next year, using historical claims data](http://www.heritagehealthprize.com/c/hhp). Są interesujące dane do pobrania.

[2011.03.24] [Geocouch](https://github.com/couchbase/geocouch) – GeoCouch, a spatial index for CouchDB.
Teraz Geocouch jest wtyczką/rozszerzeniem do CouchDB.
Instalacja jest banalnie prosta. Warto dodać je do swojego servera CouchDB.

[2011.03.22] [5 Criteria to Compare Data Marketplaces](http://nosql.mypopescu.com/post/4020294957/5-criteria-to-compare-data-marketplaces).
Nie masz jeszcze swoich danych. Zajrzyj tutaj → [Factual](http://www.factual.com/)
i tutaj → [Freebase](http://www.freebase.com/).

[2011.03.21] [Source Code Visualisation](http://www.youtube.com/watch?v=T5RrEVAzdM4). Polecam!
Warto samemu obejrzeć co się działo w repozytoriach CouchDB i MongoDB.
Jak? [Gource](http://code.google.com/p/gource/).


[2011.03.16] 28.03. zapraszam na prezentację „Narzędzia do wizualizacji baz danych”.
Pozostałe prezentacje odbędą się według harmonogramu poniżej.
Grupy powinny materiały pomocnicze do prezentacji i same prezentacje umieścić
w specjalnie w tym celu przygotowanych repozytoriach (zlinkowanych z tytułami prezentacji niżej):

* 28.03. — [Narzędzia do wizualizacji baz danych](https://github.com/nosql/data-visualisation-tools)
* 04.04. — [Jak działa Hadoop?](https://github.com/nosql/hadoop-about)
* 09.05. — [Wyszukiwanie z Elasticsearch](https://github.com/nosql/elasticsearch-about) (kontynuacja)
* 16.05. — [Oswajanie Neo4j](https://github.com/nosql/neo4j-about)

[2011.03.02] Konkurs z nagrodami – [Visualize Your Taxes](http://datavizchallenge.org/).
Pierwsza nagroda $10K.

Wszystkie prace przygotowywane w ramach zajęć muszą działać na *Sigmie*.
Dla prac należy założyć „free” repozytorium na serwerze *github.com*.
Repozytorium należy nazwać **nosql**.
(W miarę możliwości należy stosować się do uwag Tima Pope,
[A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).)

Implementacje należy przygotować w jednym z języków:
Javascript, Ruby, Perl, Python, Scala
(zob. też [top languages](https://github.com/languages)).


<blockquote>
 {%= image_tag "/images/s-mountain-range-visualisation.png", :alt => "[wizualizacja]" %}
 <h2>Ząb mądrości Davy’ego</h2>
 <p>
   Humphry Davy zauważył, że gdy był wpływem działania gazu rozweselającego
   przestał go boleć ząb mądrości. Niestety, nie wyciągnął
   logicznego wniosku, że należało wtedy wyrwać ten bolący ząb.
   Przez następne dwa pokolenia ludzie cierpieli na stołach
   operacyjnych. Znieczulenie poraz pierwszy zastosował
   dentysta Horace Wells dopiero w 1884 roku.
 </p>
 <p>
   Niektórzy uczeni twierdzą, że było to zarówno kulturalne jak i technologiczne
   zahamowanie. W końcu XVIII wieku nie dopuszczano nawet myśli
   o operacji bez bólu. Umiejętność radzenia sobie z bólem pacjenta
   (przede wszystkim przez szybkość dokonywania amputacji lub ekstrakcji)
   stanowiła zasadniczą część <b>umiejętności zawodowych</b>
   chirurga. Do rozpoczęcia bezbolesnych zabiegów potrzebna była
   <b>zmiana paradygmatu</b>.<br>(<i>S. Snow</i>, Operations without pain, 2005.)
 </p>
</blockquote>


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
1. {%= link_to "NodeJS i moduł node.couchapp.js", "/node-couchapp" %}
1. {%= link_to "Szablony Mustache w CouchDB", "/couchdb-mustache" %}
1. {%= link_to "Widok ≡ Map&#x200a;►Reduce (opcjonalnie)", "/couchdb-views" %}
1. {%= link_to "Generator przemówień i inne zastosowania…", "/couchdb-gp" %}
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
1. {%= link_to "Powłoka MongoDB", "/mongodb-shell" %}
1. {%= link_to "JTZ – bazy danych, "/mongodb-databases" %}


<!--
1. {%= link_to "Replikacja", "/mongodb-replikacja" %}
1. {%= link_to "Sharding", "/mongodb-sharding" %}
-->


## Redis

1. {%= link_to "Oswajamy bazę Redis", "/redis" %}


## Różne rzeczy

1. {%= link_to "Spidermonkey", "/couchdb-spidermonkey" %}
1. {%= link_to "Mustache – wąsate szablony", "/mustache" %}
1. {%= link_to "Dostęp do CouchDB via NodeJS", "/couchdb-nodejs" %}


# Laboratorium

*  {%= link_to "Instalacja i konfiguracja baz: CouchDB, MongoDB, Redis", "/instalacja" %}
*  {%= link_to "Zadania", "/zadania" %}


# Prezentacje

* Elasticsearch – jak wyszukiwać (np. co to są *facets*),
  import bazy do elasticsearch, połączenie z CouchDB (przykład)
  (<i>T. Widanka</i>, <i>K. Pluszczewicz</i>, <i>B. Rożek</i>)
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


# Narzędzia do wizualizacji & wizualizacje danych

* [Processing.js](http://processingjs.org/)
* [Strata Conference | Twitter Analysis](http://strataconf.nexalogy.com/)


<blockquote>
 {%= image_tag "/images/google-bigtable.jpg", :alt => "[Google Big Table]" %}
 <p>
   Perhaps when it comes to natural language processing and related
   fields, we’re doomed to complex theories that will never have the
   elegance of physics equations. But if that’s so, we should stop
   acting as if our goal is to author extremely elegant theories, and
   instead embrace complexity and make use of the best ally we have:
   the unreasonable effectiveness of data.
 </p>
 <p class="author">— <a href="http://research.google.com/pubs/archive/35179.pdf">A. Halevy, P. Norvig, F. Pereira</a></p>
</blockquote>

# Databases in the wild

Infochimps – find the world's data:

* [Infochimps Data Marketplace + Commons: Download Sell or Share Databases, statistics, datasets for free](http://infochimps.com/)
* [Million Songs](http://infochimps.com/collections/million-songs) – ok 200GB danych
* [Daily 1970-2010 Open, Close, Hi, Low and Volume (NASDAQ exchange)](http://infochimps.com/datasets/daily-1970-2010-open-close-hi-low-and-volume-nasdaq-exchange)

Twitter:

* [How Tweet It Is!: Library Acquires Entire Twitter Archive](http://blogs.loc.gov/loc/2010/04/how-tweet-it-is-library-acquires-entire-twitter-archive/)

Google:

* [Books Ngram Viewer](http://ngrams.googlelabs.com/) ([datasets](http://ngrams.googlelabs.com/datasets))

Amazon public datasets:

* [The WestburyLab USENET corpus](http://aws.amazon.com/datasets/1679761938200766) – 40GB
* [Wikipedia Traffic Statistics V2](http://aws.amazon.com/datasets/4182)
* [Daily Global Weather Measurements, 1929-2009 (NCDC, GSOD)](http://aws.amazon.com/datasets/2759) – 20GB

Newspapers:

* [Times Developer Network - Welcome](http://developer.nytimes.com/) –
  [API Request Tool](http://prototype.nytimes.com/gst/apitool/index.html);
  zob. API artykułów oraz filmów (<i>Marcin Sulkowski</i>)

Movies:

* [The Internet Movie Database](ftp://ftp.fu-berlin.de/pub/misc/movies/database/) –
  [info](ftp://ftp.fu-berlin.de/pub/misc/movies/database/tools/README) (<i>Marian Smolinski</i>)

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

* [Couchbase HTTP API Reference](http://techzone.couchbase.com/sites/default/files/uploads/all/documentation/couchbase-api.html)
* [CouchDB API Cheatsheet](http://wiki.apache.org/couchdb/API_Cheatsheet),
  [Quering Options](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options),
  [The Antepenultimate CouchDB Reference Card](http://blog.fupps.com/2010/04/20/the-antepenultimate-couchdb-reference-card/)
  (Jan-Piet Mens)
* [CSS3 Cheat Sheet](http://www.smashingmagazine.com/2009/07/13/css-3-cheat-sheet-pdf/)


<blockquote>
 <p>
  If you live to please the others, everyone will love you, except yourself.
 </p>
 <p class="author">– Paul Coelho</p>
</blockquote>


# Niesklasyfikowany misz masz

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
* Paul Joseph Davis, [New CouchDB Externals API](http://davispj.com/2010/09/26/new-couchdb-externals-api.html)
* [Grapevine](https://github.com/benbjohnson/grapevine) – trending topics for stuff you care about
* [Getting Started with CouchDB](http://net.tutsplus.com/tutorials/getting-started-with-couchdb/) – tutorial
* [Open Data Manual](http://opendatamanual.org/) – discusses legal, social and technical aspects of open data
* [Cassandra vs MongoDB vs CouchDB vs Redis vs Riak vs HBase comparison](http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis)
* [MapReduce: A Flexible Data Processing Tool](http://cacm.acm.org/magazines/2010/1/55744-mapreduce-a-flexible-data-processing-tool/fulltext)
* Joe Hellerstein. [We Lose](http://db.cs.berkeley.edu/jmh/talks/hpts2001-we-lose.pdf) – z 2001 roku!
* [MapReduce: A major step backwards](http://databasecolumn.vertica.com/database-innovation/mapreduce-a-major-step-backwards/) –
  47 interesujących komentarzy
