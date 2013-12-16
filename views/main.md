<blockquote>
 {%= image_tag "/images/alan-kay.jpg", :alt => "[Alan Kay]" %}
 <p>
   Once you have something that grows faster than education grows,
   you’re always going to get a pop culture.
 </p>
 <p class="author">– Alan Kay</p>
</blockquote>

Proponowane tematy referatów:

* **Co to jest Hadoop?**
* **Wprowadzenie do Neo4j**:
  - [Using a Graph Database with Ruby. Part I: Introduction](http://rubysource.com/using-a-graph-database-with-ruby-part-i-introduction/)
  - [Using a Graph Database with Ruby, Part II: Integration](http://rubysource.com/using-a-graph-database-with-ruby-part-ii-integration/)
  - [On Importing Data into Neo4j](http://jexp.de/blog/2013/05/on-importing-data-in-neo4j-blog-series/)
  - [Visualizing Fraud Data with Cambridge Intelligence](http://vimeo.com/64827612)
* **Wizualizacja danych**:
  - [d3.js](http://bost.ocks.org/mike/d3/workshop/):
    - [filterable gallery of examples](http://biovisualize.github.com/d3visualization/)
    - Malcolm Maclean, [D3 Tips and Tricks](https://leanpub.com/D3-Tips-and-Tricks/read)
    - Scott Murray, [Interactive Data Visualization for the Web](http://chimera.labs.oreilly.com/books/1230000000345)
  - [Let’s Make a Map](http://bost.ocks.org/mike/map/)
  - [Leaflet](http://leafletjs.com/) – JavaScript library for mobile-friendly interactive maps
  - [Neo4j GraphGist](http://gist.neo4j.org/) – share documents includeing Cypher queries
  - [c3.js](http://c3js.org/) – d3-based reusable chart library
* **Map Tiles, Geocoding**:
  - [CloudMade](http://cloudmade.com/) –
  the Location Platform Serving OEMs, Enterprises & Developers


## 8.10.2013 – zaczynamy!

**[2013.12]:**

* Geir Kjetil Sandve, Anton Nekrutenko, James Taylor, Eivind Hovig,
  [Ten Simple Rules for Reproducible Computational Research](http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1003285)
* [Redesigned percolator](http://www.elasticsearch.org/blog/percolator-redesign-blog-post/) in Elasticsearch

**[2013.11]:**

* [GeoJSON Previewing](https://github.com/blog/1638-geojson-previewing):
  „We've been rendering GeoJSON files for a while now, but now it's
  even easier to preview them if you edit them in the web view. Simply
  click the "Preview" button while editing to view a live preview of
  the file as you've edited it.”. Przykłady:
  - [Chicago zipcodes](https://github.com/smartchicago/chicago-atlas/blob/master/db/import/zipcodes.geojson),
  [Chicago zipcodes centroids](https://github.com/smartchicago/chicago-atlas/blob/master/db/import/zipcode_centroids.geojson)
  zob. też [MapBox](https://www.mapbox.com/tour/) – fast and beautiful maps,
* [GeoJSONLint](http://geojsonlint.com/)
* [DB-Engines Ranking](http://db-engines.com/en/ranking) –
  popularity ranking of database management systems

**[2013.10]:**

* Bill Ruh,
  [How the industrial internet will help you to stop worrying and love the data](http://gigaom.com/2013/10/02/how-the-industrial-internet-will-help-you-to-stop-worrying-and-love-the-data/) – zob. wykres, data collection and aggregation, extensibility and customizability
* Tomas Mikolov, Ilya Sutskever, Quoc Le, Jeff Dean,
  [word2vec](https://code.google.com/p/word2vec/); zob. artykuł na Google Open Source Blog
  [Learning the meaning behind words](http://google-opensource.blogspot.com/2013/08/learning-meaning-behind-words.html)
* Andrew Ng,
  [Stanford Machine Learning](https://www.coursera.org/course/ml)
  na [Coursera](https://www.coursera.org/)


## Co to jest „NoSQL”?

W 2009 roku Johan Oskarsson organizował konferencję
poświęconą bazom danych, które pojawiły się po roku 2000.
Informacje o konferencji chciał umieścić na Twitterze.
Dlatego potrzebował łatwego do wyszukiwaniu w tweetach hashtaga.
Użył *\#nosql* zaproponowanego przez Erica Evansa z Rackspace.

Zobacz też artykuł [NoSQL](http://en.wikipedia.org/wiki/NoSQL) w Wikipedii.

Więcej informacji o „NoSQL” zebrałem {%= link_to "tutaj", "/motywacja" %}.
Warto też przeczytać artykuł Teda Newarda,
[The Vietnam of Computer Science](http://blogs.tedneward.com/2006/06/26/The+Vietnam+Of+Computer+Science.aspx).


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

## MongoDB

1. {%= link_to "Co to jest MongoDB?", "/mongodb" %}
1. {%= link_to "Interaktywna powłoka mongo", "/mongodb-shell" %}
1. {%= link_to "Zabezpieczamy MongoDB w kwadrans", "/security" %}
1. {%= link_to "GridFS w kwadrans", "/gridfs" %}
1. {%= link_to "Proste grupowania", "/mongodb-grouping" %}
1. {%= link_to "Aggregation Framework", "/mongodb-aggregation" %}
1. {%= link_to "Kopiowanie baz danych i kolekcji", "/mongodb-copydatabases" %}
1. {%= link_to "Platforma obliczeniowa MapReduce", "/mongodb-mapreduce" %}
1. {%= link_to "MapReduce Cookbook", "/mongodb-mapreduce-cookbook" %}
1. {%= link_to "Wyszukiwanie pełnotekstowe", "/mongodb-full-text-search" %}


## ElasticSearch

1. {%= link_to "Wyszukiwanie z ElasticSearch", "/elasticsearch" %}
1. {%= link_to "Hurtowy import danych do ElasticSearch", "/elasticsearch-import" %}
1. {%= link_to "ElasticSearch & Ruby", "/elasticsearch-ruby" %}
1. {%= link_to "Wtyczki ElasticSearch", "/elasticsearch-plugins" %}


## CouchDB

1. {%= link_to "Oswajamy CouchDB", "/couchdb" %}
1. {%= link_to "Replikacja – jakie to proste!", "/couchdb-replication" %}
1. {%= link_to "Korzystamy z REST API", "/couchdb-crud" %}
1. {%= link_to "Funkcje Show", "/couchdb-show" %}
1. {%= link_to "NodeJS ← Couchapp + CouchClient + Cradle", "/node-couchapp" %}
1. {%= link_to "Erlang ← Erica", "/erlang-couchapp" %}
1. {%= link_to "GeoCouch", "/couchdb-geo" %}
1. {%= link_to "Szablony Mustache w CouchDB", "/couchdb-mustache" %}
1. {%= link_to "View ≡ Map+Reduce", "/couchdb-views" %}
1. {%= link_to "Kilka zastosowań widoków", "/couchdb-gp" %}
1. {%= link_to "Funkcje Lists", "/couchdb-lists" %}
1. {%= link_to "CouchDB & Ruby", "/couchdb-ruby" %}
1. {%= link_to "Walidacja", "/couchdb-validation" %}
1. {%= link_to "Ściąga z API", "/couchdb-api-cheatsheet" %}


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

## Laboratoria

*  {%= link_to "Zadania", "/zadania" %}


## DATA

* [Europarl Parallel Corpus](http://statmt.org/europarl/)
* [GetGlue](http://getglue.com/) – your app for TV movies and sports;
  [GetGlue sample](http://getglue-data.s3.amazonaws.com/getglue_sample.tar.gz) –
  1.4 GB, 19_831_300 JSON–ów


## Różne rzeczy

1. {%= link_to "Spidermonkey", "/couchdb-spidermonkey" %}
1. {%= link_to "Mustache – wąsate szablony", "/mustache" %}
1. {%= link_to "D3.js", "/d3js" %}
1. {%= link_to "Instalacja ze źródeł CouchDB, MongoDB, Redis oraz ElasticSearch", "/instalacja" %}
1. {%= link_to "NodeJS+NPM", "/nodejs_npm" %}
1. {%= link_to "Przygotowywanie paczek RPM dla Fedory 16+", "/fedora" %}

Użyteczne linki:

1. [Data Science Weekly](http://www.datascienceweekly.org/newsletters)
1. Jimmy Lin, Chris Dyer,
   [Data-Intensive Text Processing with MapReduce](http://lintool.github.com/MapReduceAlgorithms/index.html)
1. [A List of Data Science and Machine Learning Resources](http://conductrics.com/data-science-resources/)
1. Data Visualisation –
   [A Carefully Selected List of Recommended Tools](http://selection.datavisualization.ch/)
1. [Overpass API](http://www.overpass-api.de/) – Open Street Map data
1. Dan Foreman-Mackey.
   [The open source report card](http://osrc.dfm.io/) – ciekawe!
1. Alberto Diego Prieto Löfkrantz.
   [Do you know Cassandra?](http://blogs.atlassian.com/2013/09/do-you-know-cassandra)
