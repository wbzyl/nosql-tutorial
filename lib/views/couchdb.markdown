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

## Trochę faktów z historii CouchDB

* [Damien Katz](http://damienkatz.net/) – autor
* Przepisanie programu z C++ na Erlang – 2006
* Restful API – kwiecień 2006
* Pierwsza dostępna wersja 0.2 – sierpień 2006
* Przejście z XML na JSON, Javascript językiem zapytań – sierpień 2007
* [Map/Reduce][map-reduce] – luty 2008
* Wychodzi wersja 0.11 (ostatnia przed wersją 1.0) – kwiecień 2010


## REST API dla CouchDB

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
* [CouchDB HTTP API Reference](http://docs.couchone.com/couchdb-api/index.html)
* [couch.js](http://www.couch.io/page/library-couch-js)
* [jquery.couch.js](http://www.couch.io/page/library-jquery-couch-js)
* [BrowserCouch Tutorial](http://hg.toolness.com/browser-couch/raw-file/blog-post/tutorial.html)
* [CouchApp.org: Simple JavaScript Applications with CouchDB](http://couchapp.org/page/index) –
  utilities to make standalone CouchDB application development simple
* [Nginx As a Reverse Proxy](http://wiki.apache.org/couchdb/Nginx_As_a_Reverse_Proxy)

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
* [GeoCouch: The future is now](http://vmx.cx/cgi-bin/blog/index.cgi/geocouch-the-future-is-now:2010-05-03:en,CouchDB,Python,Erlang,geo)
* [What’s wrong with Ruby libraries for CouchDB?](http://gist.github.com/503660)
* [A gentle introduction to CouchDB for relational practitioners](http://www.xaprb.com/blog/2010/09/07/a-gentle-introduction-to-couchdb-for-relational-practitioners/)
* Karel Minarik.
  [A small application to demonstrate basic CouchDB features](http://github.com/karmi/couchdb-showcase)
* Jesse Hallett. [Database Queries
  the CouchDB Way](http://sitr.us/2009/06/30/database-queries-the-couchdb-way.html)
* Steve Krenzel. [Finding Friends](http://stevekrenzel.com/articles/finding-friends)


[couchdb wiki]: http://wiki.apache.org/couchdb/ "Couchdb Wiki"
[couchdb]: http://guide.couchdb.org/ "CouchDB: The Definitive Guide"
