#### {% title "NoSQL is about choice", false %}

# „NoSQL is about choice” – Jan Lehnardt

<blockquote>
 <p>
  Structurally speaking, they are multilevel treemaps (kind of, at
  least Cassandra). Nothing fancy, just something from the
  60ies. Hashmaps are just the quickest way to get data after an
  array. Which sounds very good for a database.
 </p>
 <p>
  […] Ok, what's more? Nothing. That's it. So
  the next question is now: Why haven't we thought about it earlier?
  <b>Why have we spent decades trying to make it more complicated instead
  of simpler?</b> The aforementioned new-comer expects some juice and I
  can't provide any.
 </p>
<!--
 <p>
  Ok, I don't see banks going to NoSQL in the short-run, it's a nice
  model for a database with simple schemas like web-apps. I can think
  easily of an usage of a NoSQL for twitter, digg etc., maybe tougher
  for a Bank. But maybe again it's my 20th century brain. How can I
  optimize my schema? Simple: don't have one. Mhm…
 </p>
-->
 <p class="author">— <a href="http://blog.acaro.org/entry/why-herb-kelleher-of-southwest-invented-nosql">Claudio Martella</a></p>
</blockquote>

[K. Haines][key-value stores part 1]:
„Applications, whether web apps, simple dynamic websites or command
line apps, frequently need some sort of persistent data store. As a
result, databases have become ubiquitous on modern systems, and
because of this chicken and egg relationship, programmers will often
habitually reach for a relational database when the project only calls
for a way to persist data.”

[L. Carlson, L. Richardson][ruby receptury]:
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


## Why NoSQL?

* [Post-relational data management for interactive software systems](http://www.couchbase.com/why-nosql/nosql-database)


## What Does Big Data Mean to Infrastructure Professionals?

Cytat z [Ten “Big Data” Realities and What They Mean to You](http://wikibon.org/blog/ten-%E2%80%9Cbig-data%E2%80%9D-realities-and-what-they-mean-to-you/):

* Big data means the amount of data you’re working with today will
  look trivial within five years.
* Huge amounts of data will be kept longer and have way more value than
  today’s archived data.
* Business people will covet a new breed of alpha geeks. You will need
  new skills around data science, new types of programming, more math
  and statistics skills and data hackers… lots of data hackers.
* **You are going to have to develop new techniques to access, secure,
  move, analyze, process, visualize and enhance data; in near real
  time.**
* **You will be minimizing data movement wherever possible by moving
  function to the data instead of data to function.** You will be
  leveraging or inventing specialized capabilities to do certain types
  of processing — e.g. early recognition of images or content types —
  so you can do some processing close to the head.
* The cloud will become the compute and storage platform for big data
  which will be populated by mobile devices and social networks.
* Metadata management will become increasingly important.
* **You will have opportunities to separate data from applications and
  create new data products.**
* You will need orders of magnitude cheaper infrastructure that
  emphasizes bandwidth, not iops and data movement and efficient
  metadata management.
* You will realize sooner or later that data and your ability to
  exploit it is going to change your business, social and personal
  life; permanently.

[The Potential Of Big Data](http://columnfivemedia.com/work-items/get-satisfaction-infographic-the-potential-of-big-data/) –
infographic which shows how big data has the potential to become the next
frontier for innovation, competition and profit.


## CAP Theorem

&nbsp;{%= image_tag "/images/cap.png", :alt =>"Visual Guide to NoSQL systems" %}

Źródło: Nathan Hurst.
[Visual Guide to NoSQL Systems](http://blog.nahurst.com/visual-guide-to-nosql-systems).

Zobacz też:

* Julian Browne,
  [Brewer’s CAP Theorem](http://www.julianbrowne.com/article/viewer/brewers-cap-theorem)
* Mike Stonebraker,
  [Errors in Database Systems, Eventual Consistency, and the CAP Theorem](http://cacm.acm.org/blogs/blog-cacm/83396-errors-in-database-systems-eventual-consistency-and-the-cap-theorem/fulltext)
* [NoSQL Deep Dive – The Missing White Paper](http://www.pythian.com/news/16817/nosql-deep-dive-the-missing-white-paper/)
(posted by shapira on Sep 14, 2010).


[key-value stores part 1]: http://www.engineyard.com/blog/2009/key-value-stores-in-ruby/ "Kirk Haines, Key-Value Stores in Ruby: Part 1"
[ruby receptury]: http://helion.pl/ksiazki/rubyre.htm "Ruby Receptury, Bazy danych i trwałość obiektów."


<blockquote>
 {%= image_tag "/images/s-mountain-range-visualisation.png", :alt => "[wizualizacja]" %}
</blockquote>

# Wizualizacje – biblioteki i przykłady

* [JavaScript InfoVis Toolkit](http://thejit.org/) –
 interactive data visualizations for the web (grafy)
* [Highcharts JS](http://www.highcharts.com/) –
  charting library offering an easy way of adding interactive charts
  to web sities or web apps
* [d3.js](http://mbostock.github.com/d3/) –
  data-driven documents
* [Circos](http://circos.ca/) – circular visualization
* [Raphaël—JavaScript Library](http://raphaeljs.com/) –
  simplify work with vector graphics on the web
* [Protovis](http://vis.stanford.edu/protovis/) –
  graphical toolkit, designed for visualization
* [Processing.js](http://processingjs.org/) –
  data visualizations, digital art, interactive animations,
  educational graphs, video games
* [PhiloGL](http://senchalabs.github.com/philogl/) –
  a WebGL Framework for Data Visualization, Creative Coding and Game Development
* [dygraphs](http://dygraphs.com/) –
  produces interactive, zoomable charts of time series


Przykłady:

* [Fizz](http://fizz.bloom.io/) – Processing.js (Twitter)
* [US Budget spending](http://blog.thejit.org/assets/dataviz/index.html) –
  InfoVis Toolkit (Google’s Data Visualization Challenge)
* [Graph Operations](http://thejit.org/static/v20/Jit/Examples/ForceDirected/example2.html) –
  InfoVis Toolkit
* [As Lost Ends, Creators Explain How They Did It, What’s Going On](http://www.wired.com/magazine/2010/04/ff_lost/5/) –
  Circos
* [Strata Conference | Twitter Analysis](http://strataconf.nexalogy.com/)
* [Scatterplot Matrix](http://mbostock.github.com/d3/ex/splom.html) – d3.js
* [D3 Tutorials](http://www.janwillemtulp.com/category/d3/) – d3.js
* [Parallel Coordinates](http://vis.stanford.edu/protovis/ex/cars.html) – Protovis
* [Stanford Dissertation Browser](http://nlp.stanford.edu/projects/dissertations/browser.html)
* [Twistori](http://twistori.com/#i_wish)


Różne:

* [Colorbrewer](http://colorbrewer2.org/) – color advice for maps


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
* [Topsy](http://corp.topsy.com/developers/api/) – realtime search for the social web

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

Różne:

* [Geobytes](http://geobytes.com/) – GeoWorldMap w formacie CSV
 (denormalizacja, konwersja na UTF-8)
* Social Security Online, [Popular Baby Names](http://www.ssa.gov/OACT/babynames/limits.html)
* [Enron Email Dataset](http://www.cs.cmu.edu/~enron/) – ok. 400MB
* [PDX API](http://www.pdxapi.com/) i [CivicApps](http://www.civicapps.org/);
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
* [What every programer should know about time](http://unix4lyfe.org/time/)


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
* [MongoDB Powering MTV’s Web Properties](http://blog.mongodb.org/post/5360007734/mongodb-powering-mtvs-web-properties)
* Amy Balliett.
  [The Do’s And Don’ts Of Infographic Design](http://www.smashingmagazine.com/2011/10/14/the-dos-and-donts-of-infographic-design/)


### Prezentacje, demo

* Max Ogden,
  [Build the Civic Web with GeoCouch!](http://max.couchone.com/where/_design/presentation/_rewrite)
