#### {% title "Co to jest MongoDB?" %}

<blockquote>
 <p>
   Nie możesz zajmować się poważnie stolarką gołymi rękami
   i nie możesz zajmować się poważnie myśleniem gołym mózgiem.
 </p>
 <p class="author">— Bo Dahlbom</p>
</blockquote>

„MongoDB is a document-oriented database.
Each MongoDB instance has multiple databases, and each database
can have multiple collections.”

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
  <h2>Left or right-brained?</h2>
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


## CAP & MongoDB

Dane w klastrze MongoDB są *sharded* i *replicated*
(*shard* możemy przetłumaczyć jako kawałek, *replica* – kopia).

{%= image_tag "/images/mongodb-cluster.jpg", :alt => "[mongodb cluster]" %}

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

Minimum deployment requirements:

1. Each member of a replica set, whether it’s a complete replica or an arbiter,
needs to live on a distinct machine.
2. Every replicating replica set member needs its own machine.
3. Replica set arbiters are lightweight enough to share a machine with another
process.
4. Config servers can optionally share a machine. The only hard requirement is
that all config servers in the config cluster reside on distinct machines.

(źródło, K. Banker, *MongoDB in Action*)

Przykład jak to można zrobić dla dwóch *shards*
(*replica set* = 2 kopie + 1 arbiter) i 3 *config servers*.

{%= image_tag "/images/mongodb-sharded-cluster.png", :alt => "[MongoDB sharded cluster]" %}

Jak widać wystarczą 4 komputery.

## Manuale, samouczki, ściągi…

* Karl Seguin. [The Little MongoDB Book](http://openmymind.net/mongodb.pdf).
* Pytania z [stackoverflow.com](http://stackoverflow.com/questions/tagged/mongodb).
  oznaczone etykietką *mongodb*.

## Schemas & Embedded/Non-Embedded Docs

* [Schema Design](https://docs.mongodb.com/manual/data-modeling/)
* [Designing MongoDB Schemas with Embedded, Non-Embedded and Bucket Structures](https://blog.openshift.com/designing-mongodb-schemas-with-embedded-non-embedded-and-bucket-structures/)
