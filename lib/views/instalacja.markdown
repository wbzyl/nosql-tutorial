#### {% title "Instalacja & Konfiguracja" %}

Przygotowałem archiwum *NoSQL* z bazami i skryptami do ich uruchamiania.
Paczkę rozpakowujemy w katalogu domowym:

    :::shell-unix-generic
    tar zxvf nosql-2011-01-01.tar.gz

Archiwum powinno się rozpakować w katalogu *~/.nosql*.

Instalację kończymy dodając do zmiennej *PATH* katalog *$HOME/.nosql/bin*.
W tym celu w pliku *~/.bashrc* dopisujemy:

    :::shell-unix-generic
    export PATH=$HOME/.nosql/bin:$PATH

Poniżej opisałem jak powstawała paczka *NoSQL*, jak skonfigurować bazy
oraz jak przetestować instalację.


# CouchDB

Z serwera *github.com* sklonowałem repozytorium:

    :::shell-unix-generic
    git://github.com/apache/couchdb.git

Następnie w katalogu *couchdb* wykonujemy kolejno polecenia:

    :::shell-unix-generic
    ./bootstrap
    ./configure --prefix=$HOME/.nosql
    # Fedora 64-bit
    # ./configure --prefix=$HOME/.nosql --with-erlang=/usr/lib64/erlang/usr/include
    make
    make install

Edytujemy w pliku *local.ini*, sekcję *httpd*:

    :::ini ~/.node/etc/couchdb/local.ini
    [httpd]
    port = XXXX             # numer zostanie przydzielony na pierwszych zajęciach
    bind_address = 0.0.0.0
    ; ???
    ; To enable Virtual Hosts in CouchDB, add a vhost = path directive. All requests to
    ; the Virual Host will be redirected to the path. In the example below all requests
    ; to http://example.com:5984/ are redirected to /database.
    [vhosts]
    127.0.0.1:4000 = /database/

**Uwaga:** Host *lvh.me* przekierowuje na *127.0.0.1* (czyli na *localhost*).
Zamiast *example.com* powinno zadziałać coś takiego i coś takiego:

    http://lvh.me:4000
    http://couchdb.lvh.me:4000

Sprawdzić!

Można też tak [Auto-configuring Proxy Settings with a PAC File](http://mikewest.org/2007/01/auto-configuring-proxy-settings-with-a-pac-file).


## Testujemy instalację

Uruchamiamy serwer:

    couchdb
        Apache CouchDB 1.2.0aa18429b-git (LogLevel=info) is starting.
        Apache CouchDB has started. Time to relax.
        [info] [<0.31.0>] Apache CouchDB has started on http://0.0.0.0:4000/

Sprawdzamy, czy instalacja przebiegła bez błędów:

    :::shell-unix-generic
    curl http://127.0.0.1:XXXX
        {"couchdb":"Welcome","version":"1.2.0aa18429b-git"}

Następnie wchodzimy na stronę:

    http://127.0.0.1:XXXX/_utils/

gdzie dostępny jest *Futon*, czyli narzędzie do administracji bazami
danych zarządzanymi przez CouchDB.

Informacje o bazach i serwerze można uzyskać kilkając w odpowiednie zakładki
*Futona*, albo korzystając programu *curl*:

    :::shell-unix-generic
    curl -X GET http://127.0.0.1:XXXX/_all_dbs
    curl -X GET http://127.0.0.1:XXXX/_config

W odpowiedzi na każde żądanie HTTP (*request*), dostajemy
odpowiedź HTTP (*response*) w formacie [JSON][json].

Jeśli skorzystamy z opcji *-v*, to *curl* wypisze szczegóły tego co robi:

    curl -vX POST http://127.0.0.1:XXXX/_config

Chociaż teraz widzimy, że **Content-Type** jest ustawiony na
**text/plain;charset=utf-8**.  Dlaczego?


## Linki

* J. Chris Anderson, Jan Lehnardt, Noah Slater.
  [CouchDB: The Definitive Guide][couchdb]
* Lena Herrmann.
  [CouchDB http API docs](https://github.com/lenalena/couchdb-http-api-docs)
* [CouchDB Wiki][couchdb wiki].
   * [Reference](http://wiki.apache.org/couchdb/Reference) – API, Views, Configuration, Security
   * [Basics](http://wiki.apache.org/couchdb/Basics) – C, Ruby, Javascript…
   * [HowTo Guides](http://wiki.apache.org/couchdb/How-To_Guides)
* Caolan McMahon. [Blog](http://caolanmcmahon.com/)
   * [On _designs undocumented](http://caolanmcmahon.com/on_designs_undocumented.html)
* [CouchDB Implementation](http://horicky.blogspot.com/2008/10/couchdb-implementation.html)
* CouchDB korzysta z [CommonJS Spec Wiki](http://wiki.commonjs.org/wiki/CommonJS),
  [Modules/1.0](http://wiki.commonjs.org/wiki/Modules/1.0)
  (przykładowa implementacja –  D. Flanagan,
  [A module loader with simple dependency management](http://www.davidflanagan.com/2009/11/a-module-loader.html))
* [GeoCouch: The future is now](http://vmx.cx/cgi-bin/blog/index.cgi/geocouch-the-future-is-now:2010-05-03:en,CouchDB,Python,Erlang,geo)
* [What’s wrong with Ruby libraries for CouchDB?](http://gist.github.com/503660)
* Karel Minarik.
  [A small application to demonstrate basic CouchDB features](http://github.com/karmi/couchdb-showcase)
* [CouchApp](http://github.com/couchapp/couchapp) –
  utilities to make standalone CouchDB application development simple
* [Google Group](http://groups.google.com/group/couchapp) –
  standalone CouchDB application development made simple
* Jesse Hallett. [Database Queries
  the CouchDB Way](http://sitr.us/2009/06/30/database-queries-the-couchdb-way.html)

## Sterowniki:

Lista oficjalnych sterwoników jest na stronie
[CouchDB Database Drivers - CouchApp Pages](http://www.couchone.com/page/couchdb-drivers).


# MongoDB

Z serwera *github.com* sklonowałem repozytorium:

    :::shell-unix-generic
    git://github.com/mongodb/mongo.git

Następnie w katalogu *mongo* wykonujemy kolejno polecenia:

    :::shell-unix-generic
    scons all
    scons --prefix=$HOME/.nosql install


## Testujemy instalację

Najpierw uruchamiamy *serwer* korzystając ze skryptu *mongo.sh*:

    :::shell-unix-generic
    mongo.sh server XXXXX
        Tue Dec 28 ... MongoDB starting : pid=25909 port=XXXXX dbpath=.../.nosql/var/lib/mongodb ...
        Tue Dec 28 ... git version: 3b7152d81bc6b30fa15bfd301d28924a33ac5dfe
        Tue Dec 28 ... sys info: Linux localhost.localdomain ...
        Tue Dec 28 ... [initandlisten] waiting for connections on port XXXXX
        Tue Dec 28 ... [websvr] web admin interface listening on port XXXXX+1000

gdzie jest unikatowym numerem portu przydzielonym w trakcie zajęć.

Następnie uruchamiamy powłokę *mongo*:

    :::shell-unix-generic
    mongo.sh shell XXXXX
        MongoDB shell version: 1...
        connecting to: 127.0.0.1:XXXXX/test
    help
	db.help()                    help on db methods
	db.mycoll.help()             help on collection methods
        ...
    x = 2 ; y = 2; x + y
        4
    post = {"title" : "hello world"}
    db.blog.insert(post)
    db.blog.find()
        { "_id" : ObjectId("4d1b168bc4846bb508a713f2"), "title" : "hello world" }


## Linki

* [MongoDB](http://www.mongodb.org/)
* [MongoDB DOCS](http://www.mongodb.org/display/DOCS/Home)
* [MongoDB Blog] [mongodb-blog]
* [MongoDB: A Light in the Darkness!] [mongodb-light]
* [Try MongoDB](http://try.mongodb.org/) —
  A Tiny MongoDB Browser Shell (mini tutorial included).
  Just enough to scratch the surface

MongoDB & Ruby:

* [Mongoid](http://mongoid.org/) –
  provides an elegant way to persist and query Ruby objects to documents in MongoDB
* [Ruby driver for MongoDB](http://github.com/mongodb/mongo-ruby-driver)
* Marek Kołodziejczyk.
  [Rails + MongoDB resources](http://code-fu.pl/2010/01/17/rails-mongodb-resources.html)
* Daniel Wertheim.
  - [Simple-MongoDB – Part 1, Getting started](http://daniel.wertheim.se/2010/04/12/simple-mongodb-part-1-getting-started/)
  - [Simple-MongoDB – Part 2, Anonymous types, JSON, Embedded entities
  and references](http://daniel.wertheim.se/2010/04/21/simple-mongodb-part-2-anonymous-types-json-embedded-entities-and-references/)
* [What If A Key/Value Store Mated With A Relational Database System?](http://railstips.org/2009/6/3/what-if-a-key-value-store-mated-with-a-relational-database-system)


# Redis

Z serwera *github.com* sklonowałem repozytorium:

    :::shell-unix-generic
    git clone git://github.com/antirez/redis.git

Następnie w katalogu *redis* wykonujemy kolejno polecenia:

    :::shell-unix-generic
    make
    make PREFIX=/home/wbzyl/.nosql/ install
    make test

Edytujemy plik *redis.conf*:

    :::ssh-config  ~/.nosql/etc/redis.conf
    # When running daemonized, Redis writes a pid file in /var/run/redis.pid by
    # default. You can specify a custom pid file location here.
    pidfile /home/wbzyl/.nosql/var/run/redis.pid

    # If you want you can bind a single interface, if the bind option is not
    # specified all the interfaces will listen for incoming connections.
    bind 0.0.0.0


## Testujemy instalację

Uruchamiamy serwer, korzystając ze skryptu *redis.sh*:

    :::shell-unix-generic
    redis.sh server
        [26787] 28 Dec ... * Server started, Redis version 2.1.8
        [26787] 28 Dec ... * The server is now ready to accept connections on port 12000
        [26787] 28 Dec ... - 0 clients connected (0 slaves), 790448 bytes in use

W innym terminalu wpisujemy:

    redis-cli -p XXXX  set mykey "hello world"
        OK
    redis-cli -p XXXX mykey

Więcej poleceń: [﻿A fifteen minutes introduction to Redis data types](http://redis.io/topics/data-types-intro).


## Linki

* [Redis IO](http://redis.io/)
* [Try Redis](http://try.redis-db.com/)
* [Redis Clients](http://redis.io/clients)
* [Ohm] [ohm]
* [The Redis Cookbook](http://rediscookbook.org/)
* Simon Willison,
  [Redis tutorial, April 2010](http://simonwillison.net/static/2010/redis-tutorial/)
* [Real-time Collaborative Editing with Web Sockets,
  Node.js & Redis](http://nosql.mypopescu.com/post/653065773/redis-pub-sub-used-for-real-time-collaborative-web)
* [To Redis or Not To Redis?] [redis-or-not]


# FAQ

TODO


[json]: http://www.json.org/ "JSON"

[couchdb]: http://guide.couchdb.org/ "CouchDB: The Definitive Guide"
[couchdb wiki]: http://wiki.apache.org/couchdb/ "Couchdb Wiki"

[document-oriented database]: http://en.wikipedia.org/wiki/Document-oriented_database "Document-oriented database"
[map-reduce]: http://en.wikipedia.org/wiki/MapReduce "MapReduce"


[mongodb-light]: http://www.engineyard.com/blog/2009/mongodb-a-light-in-the-darkness-key-value-stores-part-5/ "A Light in the Darkness"
[mongodb-blog]: http://blog.mongodb.org/ "MongoDB Blog"

[mongodb]: http://www.engineyard.com/blog/2009/mongodb-a-light-in-the-darkness-key-value-stores-part-5/ "A Light in the Darkness"
[mongodb ruby]: "http://github.com/mongodb/mongo-ruby-driver" "Ruby driver for the 10gen MongoDB"

[redis]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis or not…"
[ohm]: http://ohm.keyvalue.org/ "Object-Hash Mapping for Redis"
[redis-or-not]: http://www.engineyard.com/blog/2009/key-value-stores-for-ruby-part-4-to-redis-or-not-to-redis/ "Redis orn not…"
