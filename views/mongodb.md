#### {% title "Co to jest MongoDB?" %}

<blockquote>
 {%= image_tag "/images/datacharmer.gif", :alt => "[Data Charmer]" %}
 <p>
   Data seem sometimes to have their own life and will, and they
   refuse to behave as we wish. Then, you need a firm hand to tame
   the wild data and turn them into quiet and obeying pets.
 </p>
 <p class="author">— <a href="http://datacharmer.blogspot.com/">The Data Charmer</a></p>
</blockquote>

MongoDB is a document-oriented database.
Each MongoDB instance has multiple databases, and each database
can have multiple collections.

MongoDB can be thought of as the goodness that erupts when
a traditional key-value store collides with a relational database
management system, mixing their essences into something that’s not
quite either, but rather something novel and fascinating.

MongoDB is written in C++ and offers the following features:

* Collection oriented storage: easy storage of object/JSON-style data
* Dynamic queries
* Full index support, including on inner objects and embedded arrays
* Query profiling
* Efficient storage of binary data including large objects (e.g. photos and videos)

## Twierdzenie CAP (Eric Brewer, 2000)

[CAP](http://en.wikipedia.org/wiki/CAP_theorem)
to [skrótowiec](http://pl.wikipedia.org/wiki/Skr%C3%B3towiec)
literowy – „Consistency, Availability, Partition tolerance”.

**Twierdzenie CAP** mówi, że **rozproszony system baz danych** nie może
jednocześnie zapewniać *consistency*, *availability*, *partition tolerance*.

**Consistency** (spójność)
comes in various forms, and that one word covers a myriad of
ways errors can creep into your life:

* *update*: *write-write conflict* – kilku użytkowników
uaktualnia te same dane w tym samym czasie

Approaches for maintaining consistency in the face of concurrency are often
described as **pessimistic** or **optimistic**.
A pessimistic approach works by preventing conflicts from occurring;
an optimistic approach lets conflicts occur, but detects
them and takes action to sort them out.

* *read*: różne rodzaje – *logical consistency*,
*replication consistency*, *eventually consistent*;
również *inconsistency window* i *atomic updates*

**Availability** (dostępność)
means that **if you can talk to a node in the cluster**,
it can read and write data.

<blockquote>
  <h3>Are you left or right-brained?</h3>
  {%= image_tag "/images/hands.jpg", :alt => "[Are you left or right-brained?]" %}
  <p>Prof. R. Wiseman, Neuropsychologist and Magician, suggests easy
  and entertaining ways to discover whether you are
  left-brained or right-brained. One way is to clasp your hands casually
  and see whether right or left thumb is positioned on the top
  (see the picture). If the left thumb comes on top,
  you are right brained and artistic, adventurous and accommodative.
  If the right thumb is on the top, you are analytical,
  fluent with words and conservative.</p>
</blockquote>

**Partition tolerance** (odporność na podział sieci)
means that the cluster can survive communication
breakages in the cluster that separate the cluster into multiple partitions
unable to communicate with each other (situation known as a split brain).

(źródło: P.J. Sadalage, M. Fowler, *NoSQL Distilled*)


## CAP i MongoDB

Dane w klastrze MongoDB są *sharded* i *replicated*
(*shard* możemy przetłumaczyć jako kawałek, *replica* – kopia).

{%= image_tag "/images/mongodb-cluster.png", :alt => "[mongodb cluster]" %}

**MongoDB sharded cluster**

A sharded cluster consists of *shards*, *mongos* routers
(an interface to the cluster as a whole; typically reside on the
same machines as the application servers),
and *config servers* (store the shard cluster’s state – configuration,
location of each database and collection, shard ranges of;
typically reside in separate failure domains).

Each shard is a *replica set*.
Replica sets are used for data redundancy,
automated failover, read scaling, server maintenance without downtime,
and disaster recovery. Shards are used fo write scaling.

**Consistency** in MongoDB database is configured by using the *replica sets*
and choosing to wait for the writes to be replicated to all the slaves
or a given number of slaves. Every write can specify the number
of servers the write has to be propagated to before it returns as successful.

By default, a write is reported successful once the database receives it;
you can change this so as to wait for the
writes to be synced to disk or to propagate to two or more slaves.
This is known as ***write concern***.

Document databases try to improve on **availability** by replicating
data using the master-slave setup.
The same data is available on multiple nodes and the clients can get to the
data even when the primary node is down.

## Deployment topologies

Przykład jak to można zrobić dla dwóch *shards*
(*replica set* = 2 kopie + 1 arbiter) i 3 *config servers*.

{%= image_tag "/images/mongodb-sharded-cluster.png", :alt => "[MongoDB sharded cluster]" %}

Minimum deployment requirements:

1. Each member of a replica set, whether it’s a complete replica or an arbiter,
needs to live on a distinct machine.
2. Every replicating replica set member needs its own machine.
3. Replica set arbiters are lightweight enough to share a machine with another
process.
4. Config servers can optionally share a machine. The only hard requirement is
that all config servers in the config cluster reside on distinct machines.

(źródło, K. Banker, *MongoDB in Action*)

Jak widać potrzebne są 4 komputery.


## Manuale, samouczki, ściągi…

* [The MongoDB Manual](http://docs.mongodb.org/manual/).
  ([single page html](http://docs.mongodb.org/master/single/index.html), źródło [github](https://github.com/mongodb/docs)).
* Pytania z [stackoverflow.com](http://stackoverflow.com/questions/tagged/mongodb).
  oznaczone etykietką *mongodb*.
* Karl Seguin. [The Little MongoDB Book](http://openmymind.net/mongodb.pdf).
* Karl Seguin. [Learn Mongo](http://mongly.com/) – interaktywny samouczek.
* Krótki opis gemu [Mongo](http://api.mongodb.org/ruby/current/index.html).
  i dłuższy samouczek [MongoDB Ruby Driver Tutorial](http://api.mongodb.org/ruby/current/file.TUTORIAL.html)
* [NoSQL DZone](http://dzone.com/mz/nosql).


## Historia

* [History of MongoDB](http://www.snailinaturtleneck.com/blog/2010/08/23/history-of-mongodb/)


## Schemas & Embedded/Non-Embedded Docs

* [Schema Design](http://www.mongodb.org/display/DOCS/Schema+Design)
* [Designing MongoDB Schemas with Embedded, Non-Embedded and Bucket Structures](https://openshift.redhat.com/community/blogs/designing-mongodb-schemas-with-embedded-non-embedded-and-bucket-structures)


## MapReduce

* [Translate SQL to MongoDB MapReduce](http://nosql.mypopescu.com/post/392418792/translate-sql-to-mongodb-mapreduce)
* [NoSQL Data Modeling](http://nosql.mypopescu.com/post/451094148/nosql-data-modeling)
* [MongoDB Tutorial: MapReduce](http://nosql.mypopescu.com/post/394779847/mongodb-tutorial-mapreduce)

K. Banker, MongoDB Aggregation:

* [Counting and Grouping](http://kylebanker.com/blog/2009/11/mongodb-count-group/)
* [Grouping Elaborated](http://kylebanker.com/blog/2009/11/mongodb-advanced-grouping/)
* [Map-Reduce Basics](http://kylebanker.com/blog/2009/12/mongodb-map-reduce-basics/)


Przykłady:

* [MapReduce Example Programs](http://holumbus.fh-wedel.de/trac/wiki/MapReduceExamples) –
 proste grafiki pokazujące o co chodzi w mapreduce
* [MapReduce and K-Means Clustering](http://blog.data-miners.com/2008/02/mapreduce-and-k-means-clustering.html) –
 tylko dla MongoDB
* [Cube](http://square.github.com/cube/) –
  an open-source system for visualizing time series data, built on MongoDB,
  Node and [D3](http://mbostock.github.com/d3/)


## Full Text Search

* [MongoDB Text Search Explained](http://blog.codecentric.de/en/2013/01/text-search-mongodb-stemming/)


## Różne

* [Being Awesome with the MongoDB Ruby Driver](http://rubylearning.com/blog/2010/12/21/being-awesome-with-the-mongodb-ruby-driver/)
* Ricky Ho.
  [MongoDb Architecture ](http://horicky.blogspot.com/2012/04/mongodb-architecture.html) –
  zob. rozdział „Map/Reduce Execution”