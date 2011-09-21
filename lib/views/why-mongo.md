#### {% title "Dlaczego MapReduce?" %}

<blockquote>
 <p>
  In the emerging, highly programmed landscape ahead, you will either
  create the software or you will be the software. It’s really that
  simple: <b>Program, or be programmed.</b> Choose the former, and you gain
  access to the control panel of civilization. Choose the latter, and it
  could be the last real choice you get to make.
 </p>
 <p class="author">— Douglas Rushkoff</p>
</blockquote>

<!-- http://www.emc.com/leadership/programs/digital-universe.htm -->
<embed pluginspage="http://www.macromedia.com/go/getflashplayer"
  src="{%= to('EMCTicker2010Web.swf') %}"
  width="674" height="258"
  type="application/x-shockwave-flash"
  bgcolor="#ffffff" wmode="transparent" quality="high">
</embed>

1,5 zetabytes = 1 500 exabytes = 1 500 000 petabytes = 1 500 000 000 terabytes

* *Twitter:* RT @textwise:
  [Taming the Unstructured Data Beast](https://twitter.com/#!/theideaworks/status/10992528410):
  95% z tych 1800 exabajtów to „unstructured data”:
  - *New York Times:* Wpisy na blogach lepiej jest przechowywać jako dokumenty.
  Unikamy w ten sposób kosztownych *joins*. Możliwy też jest sharding wpisów.
* Zalew informacji
  – „szukanie igły w stogu siana”, gdzie zapisałem **ten** dokument
  - to samo pytanie po 10 latach
  - przeszukiwanie milionów katalogów, po to aby odszukać wiele kopii tego samego pliku
  (profilaktyka – deduplikacja danych?)
* *Rozproszone systemy danych:*
  Twitter users generate more than 12 terabytes of data every day.
  Even if Twitter used the fastest disk drives,
  it would take more than 40 hours to record this information
  ([NoSQL: Breaking free of structured data](http://www.itworld.com/data-centerservers/172477/nosql-breaking-free-structured-data))
* *Platforma obliczeniowa MapReduce:*
  [Facebook has the world's largest Hadoop cluster!](http://hadoopblog.blogspot.com/2010/05/facebook-has-worlds-largest-hadoop.html)
* *VISA:* Some of the datasets are enormous: for example, when Visa was
  looking to process two years' worth of credit card transactions —
  some 70 billion of them, — they turned to a NoSQL solution and were
  able to cut their processing time from a solid month using
  traditional relational solutions to just 13 minutes.
  [NoSQL: Breaking free of structured data](http://www.itworld.com/data-centerservers/172477/nosql-breaking-free-structured-data)

*Źródła:* [IDC EMC Digital Universe](http://www.emc.com/collateral/about/news/idc-emc-digital-universe-2011-infographic.pdf)

## Lots of data w Google

- example: 20+ billion web pages x 20KB = **400+ terabytes**
- one computer can read 30-35 MB/sec from disk
- ~four months to read the web pages
- ~1,000 hard drives just to store the web pages
- even more to do something with the data

Źródło: Jeff Dean, [Experiences with MapReduce, an Abstraction for Large-Scale Computation](http://www.cs.virginia.edu/~pact2006/program/mapreduce-pact06-keynote.pdf)


## Zalew danych w Instytucie Informatyki UG

W ciągu semestru akademickiego maszyny generują 500 MB
logów dziennie, co sprowadza się do 20 milionów linii tekstu,
czyli ponad 800 tysięcy na godzinę, prawie 14 tysięcy
w ciągu każdej minuty, 231 operacji na sekundę.

Należy pamiętać, że są to operacje uśrednione z 24 godzin, większość
akcji jest generowana między godziną 8 a 16 ze szczytem przypadającym
na przedział między godzinami 12 a 14, gdy ilość generowanych
informacji przekracza kilka tysięcy w ciągu sekundy.

**Źródło:** Ze wstępu pracy magisterskiej Szymona


# Co powinniśmy wiedzieć o bazach danych?

* Rodzaje baz: relacyjne, dokumentowe, klucz-wartość, grafowe, kolumnowe
* Konfiguracja master-slave, replikacja, *replica sets*
* Sharding
* Obliczenia MapReduce


# W poszukiwaniu platformy MapReduce

Niektóre bazy danych mają zaimplementowane MapReduce. Dla przykładu
Hadoop, CouchDB oraz MongoDB. My przyjrzymy się implementacji
w MongoDB.

Co powinna nam zapewnić *platforma obliczeniowa MapReduce*:

* automatic parallelization and distribution
* fault-tolerance
* I/O scheduling
* status and monitoring

Źródło: [Large Scale Data Processing](http://labs.google.com/papers/mapreduce-osdi04-slides/index-auto-0002.html)

To samo całym zdaniem:
„Programs written in this functional style are automatically
parallelized and executed on a large cluster of commodity
machines. The run-time system takes care of the details of
partitioning the input data, scheduling the program's execution across
a set of machines, handling machine failures, and managing the
required inter-machine communication. This allows programmers without
any experience with parallel and distributed systems to easily utilize
the resources of a large distributed system.”

Jeffrey Dean, Sanjay Ghemawa.
[MapReduce: Simplied Data Processing on Large Clusters](http://static.googleusercontent.com/external_content/untrusted_dlcp/labs.google.com/pl//papers/mapreduce-osdi04.pdf)
– klasyczny artykuł z Google.


## Powtórka z PostgreSQL

Które funkcjonalności MapReduce implementuje PostgreSQL?

Wykonanie tych kilku poleceń powinno odświeżyć nam pamięć:

    :::sql apache.sql
    -- DROP TABLE apache;
    CREATE TABLE apache (
          time text,
          hostname text,
          client text,
          request text,
          status text,
          responsesize text,
          useragent text );
    \copy apache from 'apache.filtered.2011.09.03.csv' with csv header

    CREATE INDEX apache_hostname ON apache (hostname);
    ALTER TABLE apache DROP COLUMN time;
    SELECT count(*) FROM apache;

    SELECT hostname,client,request FROM apache LIMIT 10;
    ALTER TABLE apache ADD COLUMN header text;
    SELECT pg_database_size('wbzyl');
    SELECT pg_size_pretty(pg_total_relation_size('apache'));

Zapisujemy wszystkie polecenia w pliku *apache.sql* i uruchamiamy
powłokę PostgreSQL *psql*, gdzie wykonujemy wszystkie te polecenia:

    :::sql
    \i apache.sql


## To samo w bazie MongoDB

Które funkcjonalności MapReduce implementuje MongoDB?

Importujemy dane z pliku JSON do bazy *apache* MongoDB,
następnie uruchamiamy powłokę mongo:

    :::shell
    mongoimport --db test --collection apache --drop --type json \
      --file apache.filtered.2011.09.09.json --headerline
    mongo

Jeśli indeks nie będzie nam potrzebny, to wcześniej należało wykonać

    :::javascript
    db.createCollection('apache', { autoIndexId: false })  // bez indeksu na _id

W powłoce sprawdzamy co się zaimportowało:

    :::javascript
    db.stats()
    db.apache.stats()
    db.apache.count()
    db.apache.findOne()

Teraz, aby przyspieszyć wyszukiwanie, generujemy indeksy:

    db.apache.ensureIndex({hostname: 1})
    db.apache.ensureIndex({request: 1})

Na koniec wykonujemy przykładowe zapytania:

    :::javascript
    db.apache.find({request: /sinatra/}).skip(20).limit(2)
    db.apache.find({request: /sinatra/}).explain()
    db.apache.find({request: /sinatra/}, {_id: 0, request: 1, useragent: 1}).limit(2)

Pozostałe polecenia powłoki *mongo*:

* [dbshell Reference](http://www.mongodb.org/display/DOCS/dbshell+Reference)
* [Overview - The MongoDB Interactive Shell](http://www.mongodb.org/display/DOCS/Overview+-+The+MongoDB+Interactive+Shell)

**Zadanie:** Pobrać dane z Open Library ([Bulk Download](http://openlibrary.org/data)) —
„has a lot of catalog records, over 20 million editions and some 6 million authors.”
Zaimportować dane do bazy PostgreSQL i MongoDB.<br>
*Wskazówka:* [Importing a large dataset into a database](http://stackoverflow.com/questions/2449166/importing-a-large-dataset-into-a-database),
[MongoHydrator](https://github.com/gregspurrier/mongo_hydrator)
— „makes expanding embedded MongoDB IDs into embedded subdocuments quick and easy”.

Zobacz też
[Converting from UNIX timestamp to PostgreSQL timestamp or date](http://www.postgresonline.com/journal/archives/3-Converting-from-Unix-Timestamp-to-PostgreSQL-Timestamp-or-Date.html).


## PostgreSQL v. MongoDB

<p class="center">
<strong>PostgreSQL    &harr;    MongoDB</strong><br>
tabelka    &harr;    collection<br>
wiersz    &harr;    dokument JSON<br>
indeks    &harr;    indeks<br>
join    &harr;    embedded document<br>
partition    &harr;    shard<br></p>


<blockquote>
 <p>
  Wszechświat jet tak bogaty, jak się nam wydaje,
  a nie tak bezbarwny, jakim zwykle ukazuje go nauka.
 </p>
 <p class="author">— Julian Barbour</p>
</blockquote>

## MongoDB w kwadrans

Przykład z Twitterem & Ruby. Zaczynamy od instalacji gemów:

    gem install mongo bson_ext twitter
    irb

Prosty skrypt w Ruby:

    :::ruby update-tweetsArchive.rb
    require 'mongo'
    require 'twitter'

    TAGS = ["mongodb", "ruby"]

    connection = Mongo::Connection.new
    db         = connection['test']

    Tweets     = db['tweetsArchive']

    def save_tweets_for(term)
      tweets_found = 0
      Twitter::Search.new.containing(term).each do |tweet|
        tweets_found += 1
        # request a response from the server to ensure that NO errors have occurred
        # Tweets.save(tweet, :safe => true)

        # update if exists; insert if new
        Tweets.save(tweet)
      end
      tweets_found
    end

    # guarantee that no documents are inserted whose values
    # for the indexed keys match those of an existing document
    Tweets.create_index([['id', 1]], :unique => true)

    TAGS.each do |tag|
      tweets_found = 0
      puts "Starting Twitter search for '#{tag}'..."
      tweets_found = save_tweets_for(tag)
      print "#{tweets_found} tweets saved.\n\n"
    end

Zapisujemy interesujące nas tweets w bazie *test*
w kolekcji *tweetsArchive*:

    ruby update-tweetsArchive.rb

A na konsoli *mongo* sprawdzimy co ciekawego
dzieje się na Twitterze:

    :::javascript
    var cursor = db.tweetsArchive.find()
    cursor.forEach(function(tweet) { printjson(tweet); })
    cursor.forEach(function(tweet) { print(tweet.text); })

Dokumentacja źródłowa:

* [Twitter](http://rdoc.info/gems/twitter/1.6.2/Twitter/Search)
* [MongoDb Ruby driver](http://rdoc.info/github/mongodb/mongo-ruby-driver/master/file/README.md)
* [Object IDs](http://www.mongodb.org/display/DOCS/Object+IDs)


## Kiedy korzystać z MongoDB?

* Archiving and event logging
* Document and Content Management Systems - as a document-oriented
  (JSON) database, MongoDB's flexible schemas are a good fit for this.
* ECommerce. Several sites are using MongoDB as the core of their
  ecommerce infrastructure (often in combination with an RDBMS for the
  final order processing and accounting).
* Gaming. High performance small read/writes are a good fit for
  MongoDB; also for certain games geospatial indexes can be helpful.
* High volume problems.  Problems where a traditional DBMS might be
  too expensive for the data in question.  In many cases developers
  would traditionally write custom code to a filesystem instead using
  flat files or other methodologies.
* Mobile. Specifically, the server-side infrastructure of mobile
  systems. Geospatial key here.
* Operational data store of a web site MongoDB is very good at
  real-time inserts, updates, and queries. Scalability and replication
  are provided which are necessary functions for large web sites'
  real-time data stores. Specific web use case examples:
  - content management
  - comment storage, management, voting
  - user registration, profile, session data
* Projects using iterative/agile development methodologies.  Mongo's
  BSON data format makes it very easy to store and retrieve data in a
  document-style / "schemaless" format. Addition of new properties to
  existing objects is easy and does not generally require blocking
  "ALTER TABLE" style operations.
* Real-time stats/analytics

[Use cases](http://www.mongodb.org/display/DOCS/Use+Cases):

- [Wordnik](http://www.wordnik.com/)
- [Scrabb.ly is now Word^2 !](http://scrabb.ly/)
- [Disney](http://www.disney.pl/)
- [Foursquare](https://foursquare.com/)


## Warto kliknąć

{%= image_tag "/images/panther.jpg", :alt => "Roaring panther" %}

* [Handy resources for learning MongoDB](http://mongly.com/)
* [The Little MongoDB Book](http://openmymind.net/mongodb.pdf)
* [MongoDB in Three Minutes](http://kylebanker.com/blog/2009/11/mongodb-in-three-minutes/)
* Roger Bodamer, [Building Web Applications with MongoDB: An Introduction](http://www.10gen.com/presentation/mongosf-2011/building-web-applications-mongodb-introduction)
* [How to process a million songs in 20 minutes](http://musicmachinery.com/2011/09/04/how-to-process-a-million-songs-in-20-minutes/) ([Million Song Dataset ](http://labrosa.ee.columbia.edu/millionsong/))


<blockquote>
 {%= image_tag "/images/ralph_waldo_emerson.jpg", :alt => "[Ralph Waldo Emerson]" %}
 <p>I hate quotations. Tell me what you know.</p>
 <p class="author">— Ralph Waldo Emerson</p>
</blockquote>

## MapReduce w MongoDB

Obliczenia MapReduce są wykonywane w trzech krokach:

1. **map** – wykonywana jest funkcja *map* na każdym dokumencie z kolekcji;
  funkcja map nic nie wylicza; ale może wywołać, być może kilkakrotnie, funkcję *emit(key, value)*
2. **shuffle step** – *keys* are grouped and arrays of emitted *values* are created for each *key*
3. **reduce** – wykonywana jest funkcja *reduce*, która dla danego *key* redukuje tablicę *values*
  do jednego elementu; element ten wraz kluczem jest zwracany do „shuffle step”,
  aż dla każdego klucza tablica *values* będzie zawierać jeden element


## Przykład „hello world” dla MapReduce

[Zliczanie słów](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf),
czyli przykład „hello world” dla MapReduce opisałem tutaj:

* {%= link_to "MapReduce w przykładach", "/mongodb-mapreduce" %}
