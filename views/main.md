<blockquote>
 {%= image_tag "/images/alan-kay.jpg", :alt => "[Alan Kay]" %}
 <p>
   Once you have something that grows faster than education grows,
   you’re always going to get a pop culture.
 </p>
 <p class="author">– <a href="https://en.wikipedia.org/wiki/Alan_Kay">Alan Kay</a></p>
</blockquote>

## Zaczynamy – luty 2017!

Indeks „TIOBE” dla baz danych:

* [DB-Engines Ranking](http://db-engines.com/en/ranking) –
  popularity ranking of database management systems


## Co to jest „NoSQL”?

<!--
Więcej informacji o „NoSQL” zebrałem {%= link_to "tutaj", "/motywacja" %}.
-->

**K. Haines**<br>
„Applications, whether web apps, simple dynamic websites or command
line apps, frequently need some sort of persistent data store. As a
result, databases have become ubiquitous on modern systems, and
because of this chicken and egg relationship, programmers will often
habitually reach for a relational database when the project only calls
for a way to persist data.”

- replication, sharding, fault-tolerance
  ([The Raft Consensus Algorithm](https://raft.github.io))
- data pipelines
- obliczenia rozproszone (map-reduce, agregacje)

**L. Carlson, L. Richardson**<br>
Wszyscy chcą pozostawić po sobie coś trwałego. […]
Każdy program, który piszemy, pozostawia jakiś ślad swojego działania
(w najprostszym przypadku są to dane wyświetlane na standardowym
urządzeniu wyjściowym). Większość bardziej rozbudowanych programów
idzie o krok dalej: zapisują one – w pliku o określonej strukturze –
dane stanowiące rezultat jednego uruchomienia, by przy następnym
uruchomieniu rozpocząć działanie w stanie, w którym zakończyła się
poprzednia sesja. **Istnieje wiele sposobów takiego
*utrwalania danych*, zarówno bardzo prostych, jak i wielce
skomplikowanych.**

- [Facebook’s Top Open Data Problems](https://research.fb.com/facebook-s-top-open-data-problems/)

W 2009 roku Johan Oskarsson organizował konferencję
poświęconą bazom danych, które pojawiły się po roku 2000.
Informacje o konferencji chciał umieścić na Twitterze.
Dlatego potrzebował łatwego do wyszukiwaniu w tweetach hashtaga.
Użył *\#nosql* zaproponowanego przez Erica Evansa z Rackspace.

<!--
Zobacz też artykuł [NoSQL](http://en.wikipedia.org/wiki/NoSQL) w Wikipedii.
Warto też przeczytać artykuł Teda Newarda,
[The Vietnam of Computer Science](http://blogs.tedneward.com/2006/06/26/The+Vietnam+Of+Computer+Science.aspx).
(I to też [Gay marriage: the database engineering perspective](http://qntm.org/gay).)
-->

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
1. {%= link_to "Proste grupowania", "/mongodb-grouping" %}
1. {%= link_to "Aggregation Pipeline", "/mongodb-aggregation" %}
1. {%= link_to "Platforma obliczeniowa MapReduce", "/mongodb-mapreduce" %}
1. {%= link_to "MapReduce Cookbook", "/mongodb-mapreduce-cookbook" %}
1. {%= link_to "Wyszukiwanie pełnotekstowe", "/mongodb-full-text-search" %}

## Elastic / ElasticSearch

1. {%= link_to "Wyszukiwanie z ElasticSearch", "/elasticsearch" %}
1. {%= link_to "Hurtowy import danych do ElasticSearch", "/elasticsearch-import" %}
1. {%= link_to "Mappings & Stempel analysis for Polish", "https://nosql.github.io/nosql_101/elastic-stempel" %}
1. {%= link_to "ElasticSearch & Ruby", "/elasticsearch-ruby" %}

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
