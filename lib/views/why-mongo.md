#### {% title "Why MongoDB? (Starbienino, 22.09.2011)" %}

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

Co powinniśmy wiedzieć o bazach danych:

* rodzaje baz: relacyjne, dokumentowe, klucz-wartość, grafowe, kolumnowe
* replikacja
* sharding
* obliczenia MapReduce


## Dlaczego potrzebujemy nierelacyjnych baz?

* *Twitter:* RT @textwise:
  [Taming the Unstructured Data Beast](https://twitter.com/#!/theideaworks/status/10992528410)
  <– "95% of that 1800 exabytes is considered unstructured data.
* *New York Times:*
  Wpisy na blogach lepiej jest przechowywać jako dokumenty.
  Unikamy w ten sposób kosztownych *joins*. Możliwy też jest sharding
  wpisów.
* *Rozproszone systemy:*
  Twitter users generate more than 12 terabytes of data every day.
  Even if Twitter used the fastest disk drives,
  it would take more than 40
  hours to record this information.
  [NoSQL: Breaking free of structured data](http://www.itworld.com/data-centerservers/172477/nosql-breaking-free-structured-data)
* *VISA:* Some of the datasets are enormous: for example, when Visa was
  looking to process two years' worth of credit card transaction s –
  some 70 billion of them, – they turned to a NoSQL solution and were
  able to cut their processing time from a solid month using
  traditional relational solutions to just 13 minutes.
  [NoSQL: Breaking free of structured data](http://www.itworld.com/data-centerservers/172477/nosql-breaking-free-structured-data)
* *Platforma obliczeniowa MapReduce:*
  [Facebook has the world's largest Hadoop cluster!](http://hadoopblog.blogspot.com/2010/05/facebook-has-worlds-largest-hadoop.html)

Przykład pokazujący o co chodzi w podpunkcie z *VISA* powyżej:

* [Importing CSV Files to PostgreSQL Databases](http://www.ensode.net/postgresql_csv_import.html)
* Importing CSV Files to MongoDB Databases


## MongoDB w kwadrans

Przykład:

    gem install twitter
    irb

Kod:

    :::ruby
    require 'twitter'
    a = Twitter::Search.new.containing("rails").fetch ; nil
    a[0].text

Dokumentacja źródłowa gemu Twitter:

* [Twitter RDOC](http://rdoc.info/gems/twitter/1.6.2/Twitter/Search)


## Kiedy korzystać z MongoDB?

[Przykłady użycia](http://www.mongodb.org/display/DOCS/Use+Cases):

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



### Warto kliknąć

{%= image_tag "/images/panther.jpg", :alt => "Roaring panther" %}

* [Handy resources for learning MongoDB](http://mongly.com/)
* [The Little MongoDB Book](http://openmymind.net/mongodb.pdf)
* [MongoDB in Three Minutes](http://kylebanker.com/blog/2009/11/mongodb-in-three-minutes/)
* [How to process a million songs in 20 minutes](http://musicmachinery.com/2011/09/04/how-to-process-a-million-songs-in-20-minutes/) ([Million Song Dataset ](http://labrosa.ee.columbia.edu/millionsong/))


## MapReduce

[Zliczanie słów](http://csillustrated.berkeley.edu/PDFs/mapreduce-example.pdf),
czyli przykład „hello world” dla MapReduce.
