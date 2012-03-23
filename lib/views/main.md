# Bazy NoSQL

<blockquote>
 {%= image_tag "/images/alan-kay.jpg", :alt => "[Alan Kay]" %}
 <p>
   Once you have something that grows faster than education grows,
   you’re always going to get a pop culture.
 </p>
 <p class="author">– Alan Kay</p>
</blockquote>

Na początek polecam lekturę artykułu [Big Data is the Answer — What was the Question?](http://www.saama.com/blog/bid/76211/Big-Data-is-the-Answer-What-was-the-Question)
oraz zastanowienie się dlaczego niektóre proste rzeczy liczymy miesiącami,
na przykład „Some of the datasets are enormous: for example, when Visa was looking
to process two years’ worth of credit card transactions — some 70
billion of them, — they turned to a NoSQL solution and were able to
cut their processing time from a solid month using traditional
relational solutions to just 13 minutes.”,
cytat z [Breaking free of structured data](http://www.itworld.com/data-centerservers/172477/nosql-breaking-free-structured-data)


# Wasze prezentacje

* [7.03.2012] **MapReduce** – Piotr Kamiński, Jacek Dzido, Olga Juhas
* [??.04.2012] **Hadoop** – Dawid Milewski, …
* [??.0?.2012] **Wizualizacja danych**, wprowadzenie do [d3.js](http://bost.ocks.org/mike/d3/workshop/)
* [??.0?.2012] **Data is Messy**, [Google Refine](http://code.google.com/p/google-refine/),
  [Data Wrangler](http://vis.stanford.edu/wrangler/)
* [??.0?.2012] **Aggregacja w ElasticSearch**.
* [??.0?.2012] **Wprowadzenie do Neo4j**.


<blockquote>
 <p>Having good ideas is most of writing well. If you know what you're
  talking about, you can say it in the plainest words and you'll be
  perceived as having a good style. With speaking it's the opposite:
  having good ideas is an alarmingly small component of being a good
  speaker.</p>
 <p class="author">– <a href="http://paulgraham.com/speak.html">Paul Graham</a></p>
</blockquote>

## Różne rzeczy

[2012.03.21] [Where can I get large datasets open to the public?](http://www.quora.com/Data/Where-can-I-get-large-datasets-open-to-the-public)

[2012.03.20] [SQL Fiddle](http://sqlfiddle.com/) –
a tool for database developers to test out their SQL queries.

[2012.03.18] Luanne Misquitta.
[Flavorwocky](http://flavorwocky.herokuapp.com/) –
Neo4j Heroku Challenge Winner.

[2012.03.10] Mike Bostock.
[D3 Workshop](http://bost.ocks.org/mike/d3/workshop/);
zob. też [stack.js](https://github.com/mbostock/stack)
oraz slajdy [index.html](http://mbostock.github.com/stack/)
(gh-pages).

[2012.02.08] [A simple viewer for code examples hosted on GitHub Gist](http://bl.ocks.org/) –
może się przydać w czasie przygotowywania wizualizacji.

[2012.03.03] Ilya Katsov.
[NoSQL Data Modeling Techniques](http://highlyscalable.wordpress.com/2012/03/01/nosql-data-modeling-techniques/).

[20.02.2012] Rzeczy do zreferowania na wykładach:

* Hadoop
* Baza grafowa Neo4j (2 referaty)
* Konfiguracja MongoDB (sharding, replica sets)
* ElasticSearch / Konfiguracja ElasticSearch
  - [Search made easy for (web) developers](http://spinscale.github.com/elasticsearch/2012-03-jugm.html)


[4.02.2012] [Udacity](http://www.udacity.com/) – kurs online
[Building a Search Engine](http://www.udacity.com/cs#101).
Kurs „Building Web Applications” planowany jest w tym roku.

[26.01.2012] [jSlate](http://jslate.com/) – dashboarding with no restrictions.
jSlate is a blank slate where you can track and visualize anything you
want, in any way you want.

[Data-Driven Documents](http://mbostock.github.com/d3/) z [d3.js](https://github.com/mbostock/d3):
[dokumentacja](http://mbostock.github.com/d3/api/),
[przykłady](http://mbostock.github.com/d3/ex/).

New York Times [Developer Network](http://developer.nytimes.com/);
przykłady z [faceted search.](http://developer.nytimes.com/docs/article_search_api#h3-facets).

[New York Times Infographics ](http://www.smallmeans.com/new-york-times-infographics/);
zob. też [about](http://www.smallmeans.com/about/).

[22.01.2012] Brett Kiefer.
[The Trello Tech Stack](http://blog.fogcreek.com/the-trello-tech-stack/).

[12.01.2012] Kristóf Kovács.
[Cassandra vs MongoDB vs CouchDB vs Redis vs Riak vs HBase vs Membase vs Neo4j comparison](http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis).

[11.01.2012] Interesujące.
[OpenLogic Announces 2011 Open Source Adoption Trending Report](http://www.openlogic.com/news/press/01.04.12.php).


<blockquote>
 {%= image_tag "/images/conan_doyle.jpg", :alt => "[Sir Arthur Conan Doyle]" %}
 <p>
   I never guess. It is a capital mistake to theorize before one has
   data. Insensibly one begins to twist facts to suit theories, instead
   of theories to suit facts.
 </p>
 <p class="author">— Sir Arthur Conan Doyle</p>
</blockquote>

## Co to jest „NoSQL”?

Termin „NoSQL” można rozszyfrować jako ***Not only SQL***. Carlo
Strozzi wprowadził ten termin w 1998 roku. W 2009 roku Eric Evans
użył terminu NoSQL w kontekście „the emergence of a
growing number of non-relational, distributed data stores”
([wikipedia](http://en.wikipedia.org/wiki/NoSQL)).

Więcej informacji o „NoSQL” zebrałem {%= link_to "tutaj", "/motywacja" %}.
Dodatkowo warto przeczytać artykuł Teda Newarda,
[The Vietnam of Computer Science](http://blogs.tedneward.com/2006/06/26/The+Vietnam+Of+Computer+Science.aspx).


## ElasticSearch

Instalacja, REST API, przykładowa aplikacja Rails:
[Wyszukiwanie z ElasticSearch](http://wbzyl.inf.ug.edu.pl/rails4/elasticsearch).
Wdrażamy aplikację „EST” na Sigmie.


## MongoDB

1. {%= link_to "Co to jest MongoDB?", "/mongodb" %}
1. {%= link_to "Interaktywna powłoka mongo", "/mongodb-shell" %}
1. {%= link_to "Język zapytań", "/mongodb-queries" %}
1. {%= link_to "Kopiowanie baz danych", "/mongodb-copydatabases" %}
1. {%= link_to "Sterowniki NodeJS i Ruby dla MongoDB", "/mongo" %}
1. {%= link_to "Agregacja danych", "/mongodb-aggregation" %}
1. {%= link_to "MapReduce w przykładach", "/mongodb-mapreduce" %}
1. {%= link_to "MapReduce Cookbook", "/mongodb-mapreduce-cookbook" %}

<!--
1. {%= link_to "Rails3 i MongoDB", "/mongodb-rails3" %}
1. {%= link_to "Masters & Slaves", "/mongodb-masters-slaves" %}
1. {%= link_to "Replikacja", "/mongodb-replikacja" %}
1. {%= link_to "Sharding", "/mongodb-sharding" %}
-->


<blockquote>
 <p>
   Humphry Davy zauważył, że gdy był pod wpływem gazu rozweselającego,
   przestał go boleć ząb mądrości. Niestety, nie wyciągnął
   logicznego wniosku, że należało wtedy wyrwać ten bolący ząb.
   Przez następne dwa pokolenia ludzie cierpieli na stołach
   operacyjnych. Znieczulenie po raz pierwszy zastosował
   dentysta Horace Wells dopiero w 1884 roku.
 </p>
 <p>
   Niektórzy uczeni twierdzą, że było to zarówno kulturalne jak i technologiczne
   zahamowanie. W końcu XVIII wieku nie dopuszczano nawet myśli
   o operacji bez bólu. Umiejętność radzenia sobie z bólem pacjenta
   (przede wszystkim przez szybkość dokonywania amputacji lub ekstrakcji)
   stanowiła zasadniczą część <b>umiejętności zawodowych</b>
   chirurga. Do rozpoczęcia bezbolesnych zabiegów potrzebna była
   <b>zmiana paradygmatu</b>.
 </p>
 <p class=""author">— S. Snow, Operations without pain</p>
</blockquote>

## CouchDB

1. {%= link_to "Oswajamy CouchDB", "/couchdb" %}
1. {%= link_to "Korzystamy z RESTFUL API", "/couchdb-crud" %}
1. {%= link_to "Replikacja – jakie to proste!", "/couchdb-replication" %}
1. {%= link_to "ElasticSearch – odjazdowy „sweet spot”", "/couchdb-elasticsearch" %}
1. {%= link_to "Funkcje Show", "/couchdb-show" %}
1. {%= link_to "NodeJS ← Couchapp + CouchClient + Cradle", "/node-couchapp" %}
1. {%= link_to "GeoCouch", "/couchdb-geo" %}
1. {%= link_to "Szablony Mustache w CouchDB", "/couchdb-mustache" %}
1. {%= link_to "Widok ≡ Map&#x200a;►Reduce (opcjonalnie)", "/couchdb-views" %}
1. {%= link_to "Generator przemówień i inne zastosowania…", "/couchdb-gp" %}
1. {%= link_to "Funkcje Lists", "/couchdb-lists" %}
1. {%= link_to "CouchDB & Ruby", "/couchdb-ruby" %}
1. {%= link_to "Rewrite – przepisywanie adresów URL", "/couchdb-rewrite" %}
1. {%= link_to "KansoJS framework dla CouchDB", "/couchdb-kansojs" %}
1. {%= link_to "Walidacja", "/couchdb-validation" %}

<!--

1. {%= link_to "CouchApp", "/couchdb-couchapp" %}
1. {%= link_to "Autentykacja", "/couchdb-authentication" %}
1. {%= link_to "Apache", "/couchdb-apache" %}

-->


## Redis

1. {%= link_to "Oswajamy bazę Redis", "/redis" %}


## Laboratorium

*  {%= link_to "Instalacja i konfiguracja baz: CouchDB, MongoDB, Redis oraz wyszukiwarki ElasticSearch", "/instalacja" %}
*  {%= link_to "Instalacja NodeJS i NPM", "/nodejs_npm" %}
*  {%= link_to "Zadania", "/zadania" %}


<blockquote>
 <p>
  In the relational databases world the data modeling process was
  mainly a single step activity: <b>design the schema based on
  normalization rules</b>. In the NoSQL world, designing the schema means
  <b>analyzing data access patterns</b>.
  Differently put the question shifted
  from <b>how do I store data</b> to
  <b>how will I access data</b>.
  </p>
  <p class="author">
  [<a href="http://nosql.mypopescu.com/post/5623952119/schema-design-in-schema-less-datastores">Schema Design in Schema-less Datastores</a>]
  </p>
</blockquote>

## Przykładowe bazy danych

* {%= link_to "Bazy CouchDB", "/couchdb-databases" %}
* {%= link_to "Kolekcje MongoDB", "/mongodb-databases" %}
* {%= link_to "Redis", "/redis-databases" %}


## Różne rzeczy

1. {%= link_to "Spidermonkey", "/couchdb-spidermonkey" %}
1. {%= link_to "Mustache – wąsate szablony", "/mustache" %}
1. {%= link_to "NodeJS", "/node" %}


## Machine Learning

…czyli komputerowe uczenie się:

* [Intro to Machine Learning in Ruby](http://blog.siyelo.com/machine-learning-in-ruby-statistic-classifica)
* 0xfe. [K-Means Clustering and Art](http://0xfe.blogspot.com/2011/12/k-means-clustering-and-art.html)


<blockquote>
 {%= image_tag "/images/data_perspective.jpg", :alt => "[data perspective]" %}
 <p>
   Jeśli coś widzisz źle, to zmień perspektywę.
 </p>
 <p class="author">[stare powiedzenie]</p>
</blockquote>

# Wasze prezentacje (2011)

* Elasticsearch –
  import bazy do elasticsearch, połączenie z CouchDB i MongoDB,
  wyszukiwanie fasetowe
  (<i>T. Widanka</i>, <i>K. Pluszczewicz</i>, <i>B. Rożek</i>)
* [Neo4j](http://neo4j.org/) – instalacja na Sigmie, przykład objaśniający
  ideę grafowych baz danych (diagramy, [narzędzie do rysowania](https://cacoo.com/))
  (<i>M. Kaliszuk, M. Kaszałowicz, M. Tupacz, M. Maszkiewicz</i>)
* [Hadoop](http://hadoop.apache.org/) – instalacja na Sigmie,
  przykład objaśniający jak to działa (diagramy),
  do czego można użyć hadoopa, hadoop mapreduce w przykładach
  (<i>Sz. Szypulski, M. Chadaj, B. Drzazgowski, D. Zmitrowicz</i>)
* Narzędzia do wizualizacji baz danych
  (<em>M. Rusajczyk, M. Pętlicki, M. Smolinski</em>)
