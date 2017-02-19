<blockquote>
 {%= image_tag "/images/alan-kay.jpg", :alt => "[Alan Kay]" %}
 <p>
   Once you have something that grows faster than education grows,
   you’re always going to get a pop culture.
 </p>
 <p class="author">– Alan Kay</p>
</blockquote>

## Zaczynamy – luty 2017!

- [Facebook’s Top Open Data Problems](https://research.facebook.com/blog/1522692927972019/facebook-s-top-open-data-problems/)

Indeks „TIOBE” dla baz danych:

* [DB-Engines Ranking](http://db-engines.com/en/ranking) –
  popularity ranking of database management systems

Data visualizations tools, [more thorough and up to date, by Edoardo L'Astorina](http://inspire.blufra.me/big-data-visualization-review-of-the-20-best-tools/):

- [d3.js](http://bost.ocks.org/mike/d3/workshop/):
  - [filterable gallery of examples](http://biovisualize.github.com/d3visualization/)
  - Malcolm Maclean, [D3 Tips and Tricks](https://leanpub.com/D3-Tips-and-Tricks/read)
  - Scott Murray, [Interactive Data Visualization for the Web](http://chimera.labs.oreilly.com/books/1230000000345)
- [c3.js](http://c3js.org/) – d3-based reusable chart library
- [Leaflet](http://leafletjs.com/) – JavaScript library for mobile-friendly interactive maps
  - [GeoJSONLint](http://geojsonlint.com/)


<!--
* Geir Kjetil Sandve, Anton Nekrutenko, James Taylor, Eivind Hovig,
  [Ten Simple Rules for Reproducible Computational Research](http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1003285)
* Kaushik Ghose, [Data Management](http://kaushikghose.wordpress.com/2013/09/26/data-management/)
-->


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

## MongoDB

1. {%= link_to "Co to jest MongoDB?", "/mongodb" %}
1. {%= link_to "Interaktywna powłoka mongo", "/mongodb-shell" %}
1. {%= link_to "Uruchamianie i zatrzymywanie demona mongod", "/mongodb-daemon" %}
1. {%= link_to "Proste grupowania", "/mongodb-grouping" %}
1. {%= link_to "Aggregation Pipeline", "/mongodb-aggregation" %}
1. {%= link_to "Platforma obliczeniowa MapReduce", "/mongodb-mapreduce" %}
1. {%= link_to "MapReduce Cookbook", "/mongodb-mapreduce-cookbook" %}
1. {%= link_to "Wyszukiwanie pełnotekstowe", "/mongodb-full-text-search" %}


## Elastic / ElasticSearch

1. {%= link_to "Wyszukiwanie z ElasticSearch", "/elasticsearch" %}
1. {%= link_to "Hurtowy import danych do ElasticSearch", "/elasticsearch-import" %}
1. {%= link_to "ElasticSearch & Ruby", "/elasticsearch-ruby" %}
1. {%= link_to "Wtyczki ElasticSearch", "/elasticsearch-plugins" %}

<!--

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

-->

## Laboratoria

*  {%= link_to "Zadania", "/zadania" %}


<!--

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

-->
