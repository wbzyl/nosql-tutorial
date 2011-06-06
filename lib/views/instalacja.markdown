#### {% title "Instalacja & Konfiguracja" %}

<blockquote>
 {%= image_tag "/images/cv.jpg", :alt => "[How to write a CV]" %}
</blockquote>

Zanim zainstalujemy paczkę z programami których będziemy używać na zajęciach,
sprawdzamy, czy mamy wystarczająco dużo miejsca na *Sigmie*.

Logujemy się na *Sigmie* i sprawdzamy, korzystając z polecenia
*quota*, swoje limity dyskowe i zużycie miejsca na dysku:

    ssh sigma
    quota

Jeśli wolnego miejsca jest mniej niż ok. 200 MB, to niestety musimy
usunąć zbędne rzeczy.  Tutaj może być pomocne wykonanie polecenia,
wypisującego dziesięć katalogów zajmujących najwięcej miejsca:

    du -m ~ | sort -k1nr | head

Dopiero teraz pobieramy paczkę z programami, którą rozpakowujemy
w katalogu domowym:

    :::shell-unix-generic
    cd ~
    git clone git://sigma.ug.edu.pl/~wbzyl/nosql
    tar zxf nosql/nosql-2011-02-15.tar.gz

Archiwum powinno się rozpakować do katalogu *~/.nosql*.

Instalację kończymy dodając do zmiennej *PATH* katalog *$HOME/.nosql/bin*.
W tym celu dopisujemy w pliku *~/.bashrc*:

    :::shell-unix-generic
    export PATH=$HOME/.nosql/bin:$PATH

Teraz wypadałoby wczytać nowe ustawienia ścieżki. W tym celu
albo się przelogowujemy (zalecane podejście) albo wykonujemy polecenie:

    source ~/.bashrc

Do uruchamiania demonów kontaktujących nas z bazami przygotowałem dwa
skrypty (po instalacji oba powinny się znaleźć w katalogu *~/.nosql/bin*):

* *mongo.sh*
* *redis.sh*



## Uwagi o instalacji programów na *Sigmie*

1. W laboratoriach na komputerach lokalnych w trakcie konfiguracji nie
są tworzone dowiązania symboliczne do plików poza katalogiem */home*.
Powoduje to masę probelmów z instalacją gemów.

Przed zalogowaniem się na Sigmę:

    rpm -qa | grep sqlite3
    sqlite3-3.7.3-1.i686

Po zalogowaniu:

    ssh sigma
    rpm -qa | grep sqlite3
    sqlite3-3.7.3-1.i686
    sqlite3-devel-3.7.3-1.i686


2. Program konfigurujący *bootstrap* nie sprawdza,
czy linki symboliczne zostały zostały poprawnie utworzone.

Na przykład, w trakcie konfiguracji CouchDB *bootstrap*
próbuje utworzyć linki symboliczne do katalogu */usr*. Dlatego
kompilacja zakończy się błędem albo po instalacji, programy nie będą
działać.

**Dlatego, wszystkie polecenia należy wykonywać po zalogowaniu się na *Sigmie*.**


<blockquote>
 {%= image_tag "/images/benjamin_franklin.jpg", :alt => "[Benjamin Franklin]" %}
 <p>
   Ktoś mnie zapytał: „Jaki może być pożytek z balonu?”
   Odpowiedziałem: A jaki jest pożytek z nowo narodzonego dziecka?
 </p>
 <p class="author">— Benjamin Franklin (1706–1790)</p>
</blockquote>

# Każdy leży na swojej *CouchDB*

Z serwera *github.com* klonujemy repozytorium CouchDB:

    :::shell-unix-generic
    git clone git://github.com/apache/couchdb.git

Następnie przechodzimy do katalogu *couchdb* i wykonujemy kolejno polecenia:

    :::shell-unix-generic
    cd couchdb
    git checkout 1.1.0  # ta wersja działa z GeoCouch
    ./bootstrap
    ./configure --prefix=$HOME/.nosql
    make
    make install

Oczywiście możemy też „live on the edge”. Niestety (18.05.2011)
rozszerzenie Geocouch nie działa z wersją „edge” CouchDB.

*Uwaga:* Na Fedorze 64-bitowej, konfiguracja przebiega inaczej, musimy
podać ścieżkę do plików nagłówkowych:

    ./configure --prefix=$HOME/.nosql --with-erlang=/usr/lib64/erlang/usr/include


Instalację kończymy, edytując pliku *local.ini*, sekcję *httpd*:

    :::ini ~/.nosql/etc/couchdb/local.ini
    [httpd]
    port = XXXXX
    bind_address = 0.0.0.0

Powyżej zamiast *XXXXX* wpisujemy numer portu przydzielony na zajęciach.

Wirtualnymi hostami zajmiemy się później, tę część na razie pomijamy:

    :::ini ~/.nosql/etc/couchdb/local.ini
    ; host *lvh.me* przekierowuje na *127.0.0.1* (czyli na *localhost*).
    ; dlatego zamiast *example.com* poniżej,
    ; powinno zadziałać coś takiego i coś takiego:
    ; http://lvh.me:4000
    ; http://couchdb.lvh.me:4000
    ;
    ; To enable Virtual Hosts in CouchDB,
    ; add a vhost = path directive. All requests to
    ; the Virual Host will be redirected to the path.
    ; In the example below all requests to
    ; http://example.com:5984/ are redirected to /database.
    ; [vhosts]
    ; example.com:4000 = /database/

Ale można postąpić tak jak to opisano
w [Auto-configuring Proxy Settings with a PAC File](http://mikewest.org/2007/01/auto-configuring-proxy-settings-with-a-pac-file).


## Testujemy instalację

Uruchamiamy serwer:

    couchdb
      Apache CouchDB 1.1.0 (LogLevel=info) is starting.
      Apache CouchDB has started. Time to relax.
      [info] [<0.31.0>] Apache CouchDB has started on http://127.0.0.1:XXXXX/

*Uwaga:* Poniżej, zamiast *XXXXX* będę wpisywał *5984* – domyślny port
na którym uruchamia się CouchDB.

Sprawdzamy, czy instalacja przebiegła bez błędów:

    :::shell-unix-generic
    curl http://127.0.0.1:5984
      {"couchdb":"Welcome","version":"1.1.0"}

Następnie wchodzimy na stronę:

    http://127.0.0.1:5984/_utils/

gdzie dostępny jest *Futon*, czyli narzędzie do administracji bazami
danych zarządzanymi przez CouchDB.

Informacje o bazach i serwerze można uzyskać kilkając w odpowiednie zakładki
*Futona*, albo korzystając programu *curl*:

    :::shell-unix-generic
    curl -X GET http://127.0.0.1:5984/_all_dbs
    curl -X GET http://127.0.0.1:5984/_config

W odpowiedzi na każde żądanie HTTP (*request*), dostajemy
odpowiedź HTTP (*response*) w formacie [JSON][json].

Jeśli skorzystamy z opcji *-v*, to *curl* wypisze szczegóły tego co robi:

    curl -vX POST http://127.0.0.1:5984/_config

Chociaż teraz widzimy, że **Content-Type** jest ustawiony na
**text/plain;charset=utf-8**.  Dlaczego?


## Gdzie są moje bazy?

Standardowo, CouchDB, tworzy nowe bazy w katalogu */var/lib/couchdb*.
Oczywiście, na Sigmie nie mamy praw do zapisywania w tym katalogu.
Dlatego bazy przenosimy na swoje konto, na przykład
do katalogu *$HOME/.data/var/lib/couchdb*:

    mkdir $HOME/.data/var/lib/couchdb -p

i informujemy swoją CouchDB o tej zmianie, dopisując (całą ścieżkę)
na początku pliku *local.ini*, na przykład

    :::ini ~/.nosql/etc/couchdb/local.ini
    [couchdb]
    database_dir = /home/wbzyl/.data/var/lib/couchdb
    view_index_dir = /home/wbzyl/.data//var/lib/couchdb

Na moim koncie na sigmie, mam takie bazy:

    razem 4047240
    -rw-rw-r--. 1 wbzyl wbzyl 2629685354  apache-time-logs.couch
    -rw-rw-r--. 1 wbzyl wbzyl  376643684  nosql.couch
    -rw-rw-r--. 1 wbzyl wbzyl   48316516  gutenberg.couch
    -rw-rw-r--. 1 wbzyl wbzyl    6512740  chromium.couch
    -rw-rw-r--. 1 wbzyl wbzyl    1577060  imdb.couch
    ...

Pierwsza baza zajmuje 2.5GB! Hmm… Dlaczego? Coś trzeba będzie z tym zrobić.


## Logrotate

Logi z czasem też zajmują dużo miejsca.
Dlatego należy je rotować za pomocą *logrotate*.
W tym celu w katalogu */etc/logrotate.d/*
umieszczamy plik *couchdb* o następującej zawartości:

    /home/wbzyl/.data/var/log/couchdb/*.log {
       weekly
       rotate 10
       copytruncate
       delaycompress
       compress
       notifempty
       missingok
    }

Sprawdamy czy to zadziała:

    logrotate -d couchdb

I to wszystko. Na koniec polecam lekturę
[Rotating Linux Log Files – Part 2: logrotate](http://www.ducea.com/2006/06/06/rotating-linux-log-files-part-2-logrotate/)


## Instalujemy rozszerzenie GeoCouch

Zaczynamy od sklonowania rozszerzenia i *cd* do katalogu repozytorium:

    git clone git://github.com/couchbase/geocouch.git
    cd geocouch

Następnie ustawiamy wartość zmiennej *COUCH_SRC*, tak aby wskazywała
na katalog z zainstalowanym plikiem nagłówkowym *couch_db.hrl*
i uruchamiamy *make*:

    :::shell-unix-generic
    export COUCH_SRC=$HOME/.nosql/lib/couchdb/erlang/lib/couch-1.1.0/include
    make

Kończymy instalację kopiując skompilowane pliki oraz plik konfiguracyjny GeoCouch
do odpowiednich katalogów:

    cp etc/couchdb/local.d/geocouch.ini $HOME/.nosql/etc/couchdb/local.d/
    cp build/*  $HOME/.nosql/lib/couchdb/erlang/lib/couch-1.1.0/ebin/

Na koniec sprawdzamy czy geolokacja działa.
W tym celu restartujemy serwer *couchdb* i przeklikowujemy na konsolę
polecenia z sekcji *Using GeoCouch* pliku
[README.md](https://github.com/couchbase/geocouch).

Więcej informacji o *Geocouch*:

* [Welcome to the world of GeoCouch](https://github.com/couchbase/geocouch)
* [GeoCouch: Bulk Insertion](http://blog.couchbase.com/geocouch-bulk-insertion)
* GeoJSON: [Geometry Objects](http://geojson.org/geojson-spec.html#geometry-objects)


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

Lista oficjalnych sterowników jest na stronie
[CouchDB Database Drivers - CouchApp Pages](http://www.couchone.com/page/couchdb-drivers).


# MongoDB

**Uwaga:** Niestety na *Sigmie* poniższa procedura nie zadziała, ponieważ nie jest zainstalowana
biblioteka *Boost*. Dlatego w archiwum umieściłem pliki z dystrybucji
[Nightly download](http://www.mongodb.org/downloads).

Z serwera *github.com* klonujemy repozytorium:

    :::shell-unix-generic
    git://github.com/mongodb/mongo.git

Następnie w katalogu *mongo* wykonujemy kolejno polecenia:

    :::shell-unix-generic
    cd mongo
    git checkout v1.8
    scons all
    scons --prefix=$HOME/.nosql install


## Testujemy instalację

Najpierw uruchamiamy *serwer* korzystając ze skryptu *mongo.sh*:

    :::shell-unix-generic
    mkdir $HOME/.mongo/var/lib/mongodb -p # tutaj będziemy trzymać swoje bazy
    mongod --dbpath=$HOME/.mongo/var/lib/mongodb --port 16000
        Tue Dec 28 ... MongoDB starting : pid=25909 port=16000  ...
        Tue Dec 28 ... git version: 3b7152d81bc6b30fa15bfd301d28924a33ac5dfe
        Tue Dec 28 ... sys info: Linux localhost.localdomain ...
        Tue Dec 28 ... [initandlisten] waiting for connections on port 16000
        Tue Dec 28 ... [websvr] web admin interface listening on port 16000+1000

Następnie uruchamiamy powłokę *mongo*:

    :::shell-unix-generic
    mongo --port 16000
      MongoDB shell version: 1.9.1
      connecting to: 127.0.0.1:16000/test
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


Więcej prostych przykładów:

* [Example showing that MongoDB uses native units for regular 2d queries, and radians for spherical 2d queries](https://gist.github.com/964262)
* TODO


## Gdzie są moje bazy?

Podobnie, jak to zrobiliśmy dla CouchDB, przeniesiemy bazy MongoDB
na swoje konto, na przykład do katalogu *$HOME/.mongo/var/lib/mongodb*:

    mkdir $HOME/.data/var/lib/mongodb -p

Teraz przy każdym uruchomieniu *mongod* musimy podać ten katalog.
Nie jest to wygodne. Pozbędziemy się tego kłopotu uruchamiając
serwer *mongod* (i powłokę *mongo*) za pomocą prostego skryptu:

    mongo.sh
    mongo.sh server
    mongo.sh server 16000
    mongo.sh shell
    mongo.sh shell 16000

Oto ten skrypt:

    :::shell-unix-generic mongo.sh
    #! /bin/bash
    function usageexit() {
        echo "Usage:  $(basename $0) server|shell [PORT]" >&2
        exit 1
    }
    dbpath=$HOME/.data/var/lib/mongodb
    type=$1
    port=$2
    shift ; shift
    : ${type:="server"}
    : ${port:=27017}
    case $type in
        server)
            mongod --config $HOME/bin/mongodb.config --dbpath $dbpath --port $port "$@"
            ;;
        shell)
            mongo --port $port "$@"
            ;;
        *)
            usageexit
            ;;
    esac

Pozostałe opcje przekazwywane do *mongod* są wpisane w pliku *mongodb.config*:

    :::ini
    # bind_ip=0.0.0.0
    journal=true # wymaga extra > 0.5GB
    rest=true
    cpu=true
    directoryperdb=true
    jsonp=true
    nssize=2
    smallfiles=true
    objcheck=true
    syncdelay=4


## Logrotate

Journal i bazy MongoDB zajmują sporo miejsca na dysku:

    ls -l ~/.mongo/var/lib/mongodb/journal/
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 12:36 prealloc.0
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 11:56 prealloc.1
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 11:56 prealloc.2
    ls -l ~/.mongo/var/lib/mongodb/twitter/
    drwxrwxr-x. 2 wbzyl wbzyl     4096 05-10 12:01 _tmp
    -rw-------. 1 wbzyl wbzyl 16777216 05-10 12:36 twitter.0
    -rw-------. 1 wbzyl wbzyl 33554432 05-10 12:01 twitter.1
    -rw-------. 1 wbzyl wbzyl  2097152 05-10 12:36 twitter.ns
    ...

Logi z czasem też. Dlatego od czasu do czasu wykonujemy:

    mongo
    use admin
    db.runCommand("logRotate");

Wygodniej jest rotować pliki log za pomocą *logrotate*.
W tym celu w katalogu */etc/logrotate.d/*
umieszczamy plik *mongodb* o następującej zawartości:

    /home/wbzyl/.data/var/log/mongodb/*.log {
       weekly
       rotate 10
       copytruncate
       delaycompress
       compress
       notifempty
       missingok
    }

I to wszystko! Logi z ostatniego tygodnia będą
kompresowane w osobnym pliku.


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

Z serwera *github.com* klonujemy repozytorium:

    :::shell-unix-generic
    git clone git://github.com/antirez/redis.git

Następnie przechodzimy do katalogu *redis*, gdzie wykonujemy polecenia:

    :::shell-unix-generic
    cd redis
    git checkout 2.2
    make
    make PREFIX=$HOME/.nosql install
    make test  # nie działa na Sigmie (brak tclsh8.5)

Na koniec edytujemy plik *redis.conf*, gdzie wpisujemy swoje dane i zmieniamy
adres dla *bind*:

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
    redis.sh server 16000
        [26787] 28 Dec ... * Server started, Redis version 2.1.8
        [26787] 28 Dec ... * The server is now ready to accept connections on port 12000
        [26787] 28 Dec ... - 0 clients connected (0 slaves), 790448 bytes in use

W innym terminalu wpisujemy:

    redis-cli -p 16000  set mykey "hello world"
        OK
    redis-cli -p 16000 get mykey
        hello world

Albo przechodzimy bezpośrednio do powłoki (klienta) wykonując polecenie:

    redis.sh shell 16000
    set mykey "hello world"
    get mykey

Więcej poleceń jest opisanych
w [﻿A fifteen minutes introduction to Redis data types](http://redis.io/topics/data-types-intro).


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
