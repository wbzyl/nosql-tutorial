#### {% title "Oswajamy CouchDB" %}

Co to są [dokumentowe bazy danych] [document-oriented database]?
Dlaczego korzystamy z dokumentowych baz danych:
„Another advantage of document oriented databases is **the ease of
usage and programming** so that untrained business users, for example,
can create applications and design their own databases. Information
can be added without worrying about the „record size” and so
programmers simply need to build an interface to allow the
information to be entered easily.”

Co jest ciekawego w CouchDB opisuje Daniel Alexiuc w artykule
(pod mylącym tytułem) [Enterprise Web Application Architecture 2.0 and
kittens](http://justsomejavaguy.blogspot.com/2010/02/enterprise-web-application-architecture.html).
Przypowieść o CouchDB,
[The Parable of CouchDB](http://www.iriscouch.com/blog/2011/06/the-parable-of-couchdb)

<blockquote>
 <h2>Kot pewnego guru</h2>
 <p>
  Co wieczór, gdy guru zasiadał do odprawiania nabożeństwa
  łaził tamtędy kot należący do aśramu,
  rozpraszając wiernych.
  Dlatego guru polecił, by związywać kota
  podczas nabożeństwa.
 <p>
  Długo po śmierci guru
  nadal związywano kota
  podczas wieczornego nabożeństwa,
  a gdy kot w końcu umarł,
  sprowadzono do aśramu innego kota,
  aby móc go związywać
  podczas wieczornego nabożeństwa.
 <p>
  Wieki później uczniowie guru
  pisali wielce uczone traktaty
  o istotnej roli kota
  w należytym odprawianiu nabożeństwa.
</blockquote>

## Dlaczego CouchDB?

* Master-master replication to provide a base network for
  interoperability and distribution of the data, without any need for
  a centralized configuration or pre-designed network architecture.
* Simple, standard API interfaces, utilizing HTTP as much as possible
* JSON data structures
* Map/Reduce type analytic capability
* Flexible architecture
* Open source
* Scalable / supports large datasets
* Minimal administration requirements
* Modern technology, utilizing modern standards

Źródło:
[The US Departments of Education and Defense use CouchDB as part of their Learning Registry Research Program](http://www.couchbase.com/case-studies/learningregistry)


## Trochę faktów z historii CouchDB

* [Damien Katz](http://damienkatz.net/) – autor
* Przepisanie programu z C++ na Erlang – 2006
* Restful API – kwiecień 2006
* Pierwsza dostępna wersja 0.2 – sierpień 2006
* Przejście z XML na JSON, Javascript językiem zapytań – sierpień 2007
* [Map/Reduce][map-reduce] – luty 2008
* Wychodzi wersja 0.11 (ostatnia przed wersją 1.0) – kwiecień 2010
* CouchDB + Membase = [Couchbase](http://blog.couchbase.com/hello-couchbase) – luty 2011;
  zob. też „white paper“ –
  [NoSQL Database Technology](http://www.couchbase.com/sites/default/files/uploads/all/whitepapers/NoSQL-Whitepaper.pdf)
* Ostatnia stabilna wersja 1.0.3 – kwiecień 2011
* [Free CouchDB hosting](http://www.iriscouch.com/) – kwiecień 2011
* [CouchDB Release 1.1 Feature Guide](http://docs.couchbase.org/couchdb-release-1.1/) – czerwiec 2011


## REST API dla CouchDB

Dokumentacja:

* [Couchbase HTTP API Reference](http://www.couchbase.org/sites/default/files/uploads/all/documentation/couchbase-api.html)

CRUD to skrót od pierwszych liter słów:
Create, Read, Update, Delete.

Poniżej zobaczymy jak korzystając z programu *curl*
**utworzyć** nową bazę danych, **usunąć** bazę, **pobrać informację** o bazie.

Tworzymy nową bazę o nazwie *xxx*:

    curl -X PUT http://127.0.0.1:5984/xxx

Pobieramy info o bazie *xxx*:

    curl -X GET http://127.0.0.1:5984/xxx

Usuwamy bazę *xxx*:

    curl -X DELETE http://127.0.0.1:5984/xxx

Nie ma polecenia dla **update**.

Omówić pozostałe operacje z sekcji „Database level”
z [API Cheatsheet](http://wiki.apache.org/couchdb/API_Cheatsheet).

**REST** to akronim od *Represenational State Transfer*.
Zwykle w kontekście WWW rozumiemy ten skrót tak:

* Dane są zasobami (ang. *resources*)
* Każdy zasób ma swój unikalny URI
* Na zasobach można wykonywać cztery podstawowe operacje CRUD
* Klient i serwer komunikują się ze sobą korzystając z protokołu
  bezstanowego. Oznacza to, że klient zwraca się z żądaniem do
  serwera. Serwer odpowiada i cała konwersacja się kończy.

Oczywiście operacje CRUD możemy zaprogramować i wykonać
używając swojego ulubionego języka programowania.


# Linki

* J. Chris Anderson, Jan Lehnardt, Noah Slater.
  [CouchDB: The Definitive Guide][couchdb]
* [CouchDB jQuery Plugin Reference](http://bradley-holt.com/2011/07/couchdb-jquery-plugin-reference/)
* [BrowserCouch Tutorial](http://hg.toolness.com/browser-couch/raw-file/blog-post/tutorial.html)
* [CouchApp.org: Simple JavaScript Applications with CouchDB](http://couchapp.org/page/index) –
  utilities to make standalone CouchDB application development simple
* [Nginx As a Reverse Proxy](http://wiki.apache.org/couchdb/Nginx_As_a_Reverse_Proxy)
* [Relaxed.tv](http://relaxed.tv/) – CouchDB Movietime!

Cykl artykułów, Jan Lehnardt. *What’s new in CouchDB*:

* Part 1: [Nice URLs with Rewrite Rules and Virtual Hosts](http://blog.couchbase.com/whats-new-in-apache-couchdb-0-11-part-one-nice-urls)
* Part 2: [Views; JOINs Redux, Raw Collation for Speed](http://blog.couchbase.com/whats-new-in-apache-couchdb-0-11-part-two-views)
* Part 3: [New Features in Replication](http://blog.couchbase.com/whats-new-in-apache-couchdb-0-11-part-three-new)
* Part 4: [Security’n stuff: Users, Authentication, Authorisation and Permissions](http://blog.couchbase.com/whats-new-in-couchdb-1-0-part-4-securityn-stuff)

Pozostałe linki:

* [CouchDB Wiki][couchdb wiki].
   * [Reference](http://wiki.apache.org/couchdb/Reference) – API, Views, Configuration, Security
   * [Basics](http://wiki.apache.org/couchdb/Basics) – C, Ruby, Javascript…
   * [HowTo Guides](http://wiki.apache.org/couchdb/How-To_Guides)
* Caolan McMahon. [Blog](http://caolanmcmahon.com/)
   * [On _designs undocumented](http://caolanmcmahon.com/on_designs_undocumented.html)
* Javascript templates:
   * [Announcing Handlebars.js](http://yehudakatz.com/2010/09/09/announcing-handlebars-js/)
* CouchDB korzysta z [CommonJS Spec Wiki](http://wiki.commonjs.org/wiki/CommonJS),
  [Modules/1.0](http://wiki.commonjs.org/wiki/Modules/1.0)
  (przykładowa implementacja –  D. Flanagan,
  [A module loader with simple dependency management](http://www.davidflanagan.com/2009/11/a-module-loader.html))
* [GeoCouch: The future is now](http://vmx.cx/cgi-bin/blog/index.cgi/geocouch-the-future-is-now:2010-05-03:en,CouchDB,Python,Erlang,geo) ([Geo Demo](http://vmx.iriscouch.com/blocks/_design/geodemo/index.html))
* [What’s wrong with Ruby libraries for CouchDB?](http://gist.github.com/503660)
* [A gentle introduction to CouchDB for relational practitioners](http://www.xaprb.com/blog/2010/09/07/a-gentle-introduction-to-couchdb-for-relational-practitioners/)
* Karel Minarik.
  [A small application to demonstrate basic CouchDB features](http://github.com/karmi/couchdb-showcase)
* Jesse Hallett. [Database Queries
  the CouchDB Way](http://sitr.us/2009/06/30/database-queries-the-couchdb-way.html)
* Steve Krenzel. [Finding Friends](http://stevekrenzel.com/articles/finding-friends)


[couchdb wiki]: http://wiki.apache.org/couchdb/ "Couchdb Wiki"
[couchdb]: http://guide.couchdb.org/ "CouchDB: The Definitive Guide"
