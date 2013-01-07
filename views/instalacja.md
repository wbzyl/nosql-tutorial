#### {% title "Instalacja & Konfiguracja" %}

<blockquote>
 {%= image_tag "/images/cv.jpg", :alt => "[How to write a CV]" %}
</blockquote>

W Google pod hasłem **NoSQL** znajdziemy linki
do programów będących alternatywą dla relacyjnych systemów baz danych
takich jak PostgreSQL czy MySQL. Na wykładach zostaną
omówione:

* ElasticSearch – wyszukiwarka
* MongoDB – baza dokumentowa
* CouchDB – baza dokumentowa

oraz (referaty)

* Neo4j – baza grafowa
* Redis – baza klucz–wartość


Przed instalacją tych programów powinniśmy sprawdzić, czy mamy
wystarczająco dużo miejsca na swoim koncie na *Sigmie*. W tym celu
logujemy się na *Sigmie*, gdzie wykonujemy polecenie:

    quota

Polecenie to wypisze nasze limity dyskowe.
Jeśli mamy mniej niż ok. 200 MB do dyspozycji, to musimy
usunąć zbędne rzeczy.

Aby się zorientować, jakie katalogi zajmują dużo miejsca,
możemy wykonać to polecenie:

    du -m ~ | sort -k1nr | head

Wypisze ono dziesięć katalogów zajmujących najwięcej miejsca.

Użyteczny jest też program *ncdu* (zainstalowany na *Sigmie*).


## Post Installation

<!--
Instalację kończymy dodając do ścieżek wyszukiwania *PATH*
ścieżki do zainstalowanych programów oraz skryptów.
W tym celu dopiszemy w pliku *~/.bashrc*:

    :::text
    export PATH=$HOME/.nosql/bin:$PATH

Teraz wypadałoby wczytać nowe ustawienia.
Dlatego przelogowujemy się (zalecane podejście) albo wykonujemy polecenie:

    source ~/.bashrc

-->

Bazy danych utworzymy w katalogu *$HOME/.data*,
czyli poza katalogami utworzonymi w czasie instalacji. Dlaczego?

Domyślne ustawienia są inne, dlatego demony baz danych będziemy
uruchamiać za pomocą skryptów w których wpiszemy odpowiednie ścieżki:

* [CouchDB](https://gist.github.com/4477030)
* [MongoDB](https://gist.github.com/1967489)
* [ElasticSearch](https://gist.github.com/1687963)

<!--
* [Redis](https://gist.github.com/1374681)
-->


## Bazy 32-bitowe czy 64-bitowe?

Jeśli programy instalujemy na maszynach w pracowni, to instalujemy
wersje 32-bitowe. Jeśli na *Sigmie* – 64-bitowe.


<blockquote>
 {%= image_tag "/images/benjamin_franklin.jpg", :alt => "[Benjamin Franklin]" %}
 <p>
   Ktoś mnie zapytał: „Jaki może być pożytek z balonu?”
   Odpowiedziałem: A jaki jest pożytek z nowo narodzonego dziecka?
 </p>
 <p class="author">— Benjamin Franklin (1706–1790)</p>
</blockquote>

# CouchDB z rozszerzeniem GeoCouch

Rozszerzenie GeoCouch działa z wersjami CouchDb do wersji 1.3.x włącznie.

Zaczynamy od sklonowania repozytoriów couchdb i geocouch:

    :::bash
    git clone http://git-wip-us.apache.org/repos/asf/couchdb.git
    git clone git://github.com/couchbase/geocouch.git

Tak jak to opisano w GeoCouch README przechodzimy na gałąź 1.3.x:

    :::text
    cd couchdb
    git branch -a
    git checkout --track origin/1.3.x
    ./bootstrap
    # ./configure --prefix=$HOME/.nosql # 32-bity
    ./configure --prefix=$HOME/.nosql --with-erlang=/usr/lib64/erlang/usr/include # 64-bity
    make
    make install

Zobacz też [Road Map](https://issues.apache.org/jira/browse/COUCHDB).


## Post-install

Kończymy instalację tworząc nowy plik *sigma.ini* i wpisując do niego
następujące rzeczy:

    :::plain
    ; Plik ~/.nosql/etc/couchdb/local.d/sigma.ini

    [httpd]
    port = 5984
    bind_address = 0.0.0.0

    [couchdb]
    database_dir = /home/wbzyl/.data/var/lib/couchdb
    view_index_dir = /home/wbzyl/.data/var/lib/couchdb

    [log]
    file = /home/wbzyl/.data/var/log/couchdb/couch.log

Ponieważ katalogi, te nie istnieją, Tworzymy je:

    mkdir $HOME/.data/var/lib/couchdb/ -p
    mkdir $HOME/.data/var/log/couchdb/ -p

**Dwie uwagi**

1. Powyżej zamiast domyślnego numeru portu *5984* wpisujemy numer przydzielony na zajęciach.

2. Oczywiście zamiast */home/wbzyl/* wstawiamy ścieżkę do swojego katalogu domowego
(albo jakąś inną).

Hostami wirtualnymi zajmiemy się później:

    :::plain
    ; Plik ~/.nosql/etc/couchdb/local.d/sigma.ini

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

Alternatywny sposób konfiguracji hostów wirtualnych opisano
w [Auto-configuring Proxy Settings with a PAC File](http://mikewest.org/2007/01/auto-configuring-proxy-settings-with-a-pac-file).


## Testujemy instalację

Uruchamiamy serwer:

    couchdb.sh
      Apache CouchDB 1.3.0a-98988dd-git (LogLevel=info) is starting.
      Apache CouchDB has started. Time to relax.
      [info] [<0.31.0>] Apache CouchDB has started on http://0.0.0.0:5984/

Sprawdzamy, czy instalacja przebiegła bez błędów:

    :::text
    curl http://127.0.0.1:5984
    {
      "couchdb":"Welcome",
      "uuid":"9a5f855eda071efad446d49b1cd09a8b",
      "version":"1.3.0a-98988dd-git",
      "vendor":{"version":"1.3.0a-98988dd-git","name":"The Apache Software Foundation"}
    }

Następnie wchodzimy na stronę:

    http://127.0.0.1:5984/_utils/

gdzie dostępny jest *Futon*, czyli narzędzie do administracji bazami
danych zarządzanymi przez CouchDB.

Informacje o bazach i serwerze można uzyskać kilkając w odpowiednie zakładki
*Futona*, albo korzystając programu *curl*:

    :::text
    curl -X GET http://127.0.0.1:5984/_all_dbs
    curl -X GET http://127.0.0.1:5984/_config

Na każde powyższe żądanie (*request*) odpowiedzią (*response*) servera CouchDB
jest tekst w formacie [JSON][json].

Jeśli skorzystamy z opcji *-v*, to *curl* wypisze szczegóły tego co robi:

    curl -vX GET http://127.0.0.1:5984/_config

Chociaż teraz widzimy, że **Content-Type** jest ustawiony na
**text/plain;charset=utf-8**.  Dlaczego?

W przeszłości często się zdarzało, że nie działał replikator.
Dlatego w ramach testowania, sprawdzimy czy działa replikator.

W tym celu zreplikujemy jakąś bazę z servera*Tao*, na przykład

    http://couch.inf.ug.edu.pl/ls

Następnie, w ramach dalszego testowania, replikujemy tę bazę lokalnie.

Samą replikację możemy wyklikać w zakładce Replication *Futona*:

    :::json
    {"source":"http://couch.inf.ug.edu.pl/ls","target":"ls","create_target":true}

albo możemy wykonać za pomocą programu *curl*:

    :::bash
    curl -X POST http://127.0.0.1:5984/_replicate -H 'Content-Type: application/json' \
       -d '{"source":"http://couch.inf.ug.edu.pl/ls","target":"ls","create_target":true}'


## Gdzie są moje bazy danych?

Domyślnie, skompilowany CouchDB będzie zapisywał rekordy
do baz w katalogu *$HOME/.nosql/var/lib/couchdb/*.

My zmieniliśmy tę lokalizację na:

    :::bash
    $HOME/.data/var/lib/couchdb

Kilka baz z serwera *Tao*:

    ls -l ~/.data/var/lib/couchdb
    razem 4047240
    -rw-rw-r--. 1 wbzyl wbzyl 2629685354  apache-time-logs.couch
    -rw-rw-r--. 1 wbzyl wbzyl  376643684  nosql.couch
    -rw-rw-r--. 1 wbzyl wbzyl   48316516  gutenberg.couch
    -rw-rw-r--. 1 wbzyl wbzyl    6512740  chromium.couch
    -rw-rw-r--. 1 wbzyl wbzyl    1577060  imdb.couch
    ...

Pierwsza baza zajmuje 2.5GB! Hmm… Dlaczego?


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

Sprawdamy jak to będzie działać:

    logrotate -d /etc/logrotate.d/couchdb

      reading config file /etc/logrotate.d/couchdb
      reading config info for /home/wbzyl/.data/var/log/couchdb/*.log

      Handling 1 logs

      rotating pattern: /home/wbzyl/.nosql/couchdb/build/var/log/couchdb/*.log  weekly (10 rotations)
      empty log files are not rotated, old logs are removed
      considering log /home/wbzyl/.nosql/couchdb/build/var/log/couchdb/couch.log
        log does not need rotating


I to wszystko. Na koniec polecam lekturę
[Rotating Linux Log Files – Part 2: logrotate](http://www.ducea.com/2006/06/06/rotating-linux-log-files-part-2-logrotate/).


## Instalujemy rozszerzenie GeoCouch

Wersja działająca: couchdb1.2.0. Wersja couchdb1.3.x nie działa.

Zaczynamy od *cd* do katalogu repozytorium:

    :::bash
    cd geocouch
    git checkout --track origin/couchdb1.3.x

Następnie ustawiamy wartość zmiennej *COUCH_SRC*, tak aby wskazywała
na katalog z zainstalowanym plikiem nagłówkowym *couch_db.hrl*.
i uruchamiamy *make*:

    :::bash
    export COUCH_SRC=$HOME/.nosql/lib/couchdb/erlang/lib/couch-1.3.0a-98988dd-git/include
    make

Ponieważ nazwa tego katalogu, zależy od sumy SHA gałęzi, trzeba to
wcześniej sprawdzić.

<!--
    git log --graph --decorate --pretty=oneline --abbrev-commit | head -1
    * 384a75b (HEAD, origin/1.2.x, 1.2.x) fix show/list/external requested_path for rewrites
-->

Kończymy instalację kopiując skompilowane pliki oraz plik konfiguracyjny GeoCouch
do odpowiednich katalogów:

    cp $HOME/.nosql/geocouch/etc/couchdb/default.d/geocouch.ini $HOME/.nosql/etc/couchdb/default.d/
    cp $HOME/.nosql/geocouch/build/* /home/wbzyl/.nosql/lib/couchdb/erlang/lib/couch-1.3.0a-98988dd-git/ebin/

Na koniec sprawdzamy czy geolokacja działa.
W tym celu restartujemy serwer *couchdb* i przeklikowujemy na konsolę
polecenia z sekcji *Using GeoCouch* pliku
[README.md](https://github.com/couchbase/geocouch).

Więcej informacji o *Geocouch*:

* [Welcome to the world of GeoCouch](https://github.com/couchbase/geocouch)
* [GeoCouch Utils](https://github.com/maxogden/geocouch-utils)
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
* [CouchDB Implementation](http://horicky.blogspot.com/2008/10/couchdb-implementation.html)
* CouchDB korzysta z [CommonJS Spec Wiki](http://wiki.commonjs.org/wiki/CommonJS),
  [Modules/1.0](http://wiki.commonjs.org/wiki/Modules/1.0);
  przykładowa implementacja – D. Flanagan,
  [A module loader with simple dependency management](http://www.davidflanagan.com/2009/11/a-module-loader.html)
* [GeoCouch: The future is now](http://vmx.cx/cgi-bin/blog/index.cgi/geocouch-the-future-is-now:2010-05-03:en,CouchDB,Python,Erlang,geo)
* [What’s wrong with Ruby libraries for CouchDB?](http://gist.github.com/503660)
* [CouchApp](http://github.com/couchapp/couchapp) –
  utilities to make standalone CouchDB application development simple
* [Google Group](http://groups.google.com/group/couchapp) –
  standalone CouchDB application development made simple


# MongoDB

Z serwera *github.com* klonujemy repozytorium:

    :::bash
    git clone git://github.com/mongodb/mongo.git

Następnie w katalogu *mongo* wykonujemy kolejno polecenia:

    :::bash
    cd mongo
    git checkout r2.3.2
    scons all                            # build all binaries with v8
    scons --prefix=$HOME/.nosql install
    git checkout master

**Uwaga:** Od wersji 2.3.1 MongoDB korzysta z silnika JavaScript „V8” (Chrome).
Wcześniejsze wersje korzystały ze „Spider Monkey” (Firefox). Zobacz też
[ECMA 5 Mozilla Features Implemented in V8](https://github.com/joyent/node/wiki/ECMA-5-Mozilla-Features-Implemented-in-V8).


### Instalacja na skróty

Pobieramy paczkę dla naszego systemu ze strony
[MongoDB Downloads](http://www.mongodb.org/downloads). Przykładowo:

    :::bash
    wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-latest.tgz

Odpakowujemy archiwum:

    tar zxvf mongodb-linux-x86_64-latest.tgz

Kopiujemy pliki wykonywalne do odpowiednich katalogów:

    mv mongodb-linux-x86_64-2.0.2/bin $HOME/.nosql/bin

I już!


## Testujemy instalację

Tworzymy katalogi na swoje bazy i na plik *mongodb.pid*:

    :::bash
    mkdir $HOME/.data/var/lib/mongodb -p
    mkdir $HOME/.data/var/run

Dopiero teraz uruchamiamy demona *mongod* (poniżej wpisuję domyślny port):

    :::bash
    mongod --dbpath=$HOME/.data/var/lib/mongodb --port=27017
      Mon Jan  7 21:34:41.812 [initandlisten] MongoDB starting : pid=16536 port=27017 ..
      Mon Jan  7 21:34:41.813 [initandlisten] 
      Mon Jan  7 21:34:41.813 [initandlisten] ** NOTE: This is a development version (2.3.2-pre-) of MongoDB.
      Mon Jan  7 21:34:41.813 [initandlisten] **       Not recommended for production.
      Mon Jan  7 21:34:41.813 [initandlisten] 
      Mon Jan  7 21:34:41.813 [initandlisten] db version v2.3.2-pre-, pdfile version 4.5
      Mon Jan  7 21:34:41.813 [initandlisten] git version: be56edc259bb5c0e3bb862c69a6303705ef453f4
      Mon Jan  7 21:34:41.813 [initandlisten] build info: Linux ip-10-2-29-40 2.6.21.7-2.ec2.v1.2.fc8xen ..
      Mon Jan  7 21:34:41.813 [initandlisten] allocator: tcmalloc
      Mon Jan  7 21:34:41.813 [initandlisten] options: { dbpath: "/home/wbzyl/.data/var/lib/mongodb", port: 27017 }
      Mon Jan  7 21:34:41.895 [initandlisten] journal dir=/home/wbzyl/.data/var/lib/mongodb/journal
      Mon Jan  7 21:34:41.927 [initandlisten] recover : no journal files present, no recovery needed
      Mon Jan  7 21:34:44.092 [initandlisten] preallocateIsFaster=true 25.74
      Mon Jan  7 21:34:46.198 [initandlisten] preallocateIsFaster=true 24.46
      Mon Jan  7 21:34:49.403 [initandlisten] preallocateIsFaster=true 26.52
      Mon Jan  7 21:34:49.403 [initandlisten] preallocateIsFaster check took 7.476 secs
      Mon Jan  7 21:34:49.403 [initandlisten] preallocating a journal file..
      Mon Jan  7 21:34:52.020 [initandlisten]     File Preallocator Progress: 870318080/1073741824  81%
      Mon Jan  7 21:35:00.285 [initandlisten] preallocating a journal file..
      Mon Jan  7 21:35:03.073 [initandlisten]     File Preallocator Progress: 870318080/1073741824  81%
      Mon Jan  7 21:35:10.966 [initandlisten] preallocating a journal file..
      Mon Jan  7 21:35:13.129 [initandlisten]     File Preallocator Progress: 796917760/1073741824  74%
      Mon Jan  7 21:35:22.214 [FileAllocator] allocating new datafile..
      Mon Jan  7 21:35:22.214 [FileAllocator] creating directory /home/wbzyl/.data/var/lib/mongodb/_tmp
      Mon Jan  7 21:35:22.340 [FileAllocator] done allocating datafile ..
      Mon Jan  7 21:35:22.341 [FileAllocator] allocating new datafile ..
      Mon Jan  7 21:35:23.848 [FileAllocator] done allocating datafile ..
      Mon Jan  7 21:35:23.885 [initandlisten] command local.$cmd command: ..
      Mon Jan  7 21:35:23.886 [websvr] admin web console waiting for connections on port 28017
      Mon Jan  7 21:35:23.951 [initandlisten] waiting for connections on port 27017


Uruchamiamy powłokę *mongo*:

    :::bash
    mongo --port 27017
      MongoDB shell version: 2.3.2-pre-
      connecting to: 127.0.0.1:27017/test
      Server has startup warnings: 
      Mon Jan  7 21:34:41.813 [initandlisten] 
      Mon Jan  7 21:34:41.813 [initandlisten] ** NOTE: This is a development version (2.3.2-pre-) of MongoDB.
      Mon Jan  7 21:34:41.813 [initandlisten] **       Not recommended for production.
      Mon Jan  7 21:34:41.813 [initandlisten] 
      localhost(mongod-2.3.2-pre-) test> 

W powłoce wpisujemy i wykonujemy kilka poleceń:

    :::text
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

Teraz możemy przećwiczyć więcej prostych przykładów:

* [Example showing that MongoDB uses native units for regular 2d queries, and radians for spherical 2d queries](https://gist.github.com/964262)
* [The MongoDB Collection](http://mongly.com/):
  - [The MongoDB Interactive Tutorial](http://tutorial.mongly.com/tutorial/index)
  - [Geospatial Interactive Tutorial](http://tutorial.mongly.com/geo/index)


## Gdzie są moje bazy?

Podobnie, jak to zrobiliśmy dla CouchDB, przeniesiemy bazy MongoDB
na swoje konto, na przykład do katalogu *$HOME/.data/var/lib/mongodb*:

    mkdir $HOME/.data/var/lib/mongodb -p

Teraz przy każdym uruchomieniu *mongod* musimy podać ten katalog.
Nie jest to wygodne. Pozbędziemy się tego kłopotu uruchamiając demona
*mongod* za pomocą prostego skryptu
[mongod.sh](https://gist.github.com/1967489).


## Logrotate

Journal i bazy MongoDB zajmują sporo miejsca na dysku (3 GB!):

    ls -l ~/.data/var/lib/mongodb/journal/
      -rw-------. 1 wbzyl wbzyl 1073741824 01-07 21:35 j._0
      -rw-------. 1 wbzyl wbzyl 1073741824 01-07 21:35 prealloc.1
      -rw-------. 1 wbzyl wbzyl 1073741824 01-07 21:35 prealloc.2

Logi z czasem też. Dlatego od czasu do czasu ręcznie rotujemy logi:

    :::bash
    mongo
    use admin
    db.runCommand("logRotate");

Ale wygodniej jest rotować pliki log za pomocą *logrotate*.
W tym celu w katalogu */etc/logrotate.d/*
umieszczamy plik *mongodb* o następującej zawartości:

    /home/wbzyl/.data/var/log/mongodb/*.log {
      su wbzyl wbzyl
      daily
      rotate 4
      copytruncate
      delaycompress
      compress
      notifempty
      missingok
      postrotate
        /bin/kill -USR1 `cat /home/wbzyl/.data/var/run/mongodb.pid 2>/dev/null` 2> /dev/null || true
      endscript
    }

Oczywiście powyżej w dyrektywie `su` wpisujemy **swoje** dane.
Sprawdzamy jak to działa:

    :::bash
    logrotate -d /etc/logrotate.d/mongodb

I to wszystko!


## Linki

* [MongoDB](http://www.mongodb.org/)
* [MongoDB DOCS](http://www.mongodb.org/display/DOCS/Home)
* [MongoDB Blog] [mongodb-blog]

MongoDB & Ruby:

* [Mongoid](http://mongoid.org/) –
  provides an elegant way to persist and query Ruby objects to documents in MongoDB
* [Ruby driver for MongoDB](http://github.com/mongodb/mongo-ruby-driver)
* Daniel Wertheim.
  - [Simple-MongoDB – Part 1, Getting started](http://daniel.wertheim.se/2010/04/12/simple-mongodb-part-1-getting-started/)
  - [Simple-MongoDB – Part 2, Anonymous types, JSON, Embedded entities
  and references](http://daniel.wertheim.se/2010/04/21/simple-mongodb-part-2-anonymous-types-json-embedded-entities-and-references/)
* [What If A Key/Value Store Mated With A Relational Database System?](http://railstips.org/2009/6/3/what-if-a-key-value-store-mated-with-a-relational-database-system)


# Redis

Z serwera *github.com* klonujemy repozytorium:

    :::text
    git clone git://github.com/antirez/redis.git

Następnie przechodzimy do katalogu *redis*, gdzie wykonujemy polecenia:

    :::text
    cd redis
    git checkout 2.4.2
    make
    make PREFIX=$HOME/.nosql install
    make test                          # nie działa na Sigmie (brak tclsh8.5)

Na koniec edytujemy plik *redis.conf*, gdzie wpisujemy swoje dane i zmieniamy
adres dla *bind*:

    :::plain  ~/.data/etc/redis.conf
    port 6379
    #
    pidfile /home/wbzyl/.data/var/run/redis.pid   # mkdir -p ~/.data/var/run/
    #
    bind 0.0.0.0
    #
    # The filename where to dump the DB
    dbfilename dump.rdb
    #
    # The DB will be written inside this directory, with the filename specified
    # above using the 'dbfilename' configuration directive.
    #
    # Also the Append Only File will be created inside this directory.
    #
    dir /home/wbzyl/.data/var/lib/redis  # mkdir -p ~/.data/var/lib/redis
    #
    # Specify the log file name. Also 'stdout' can be used to force
    # Redis to log on the standard output. Note that if you use standard
    # output for logging but daemonize, logs will be sent to /dev/null
    #
    logfile /home/wbzyl/.data/var/log/redis/redis.log  # mkdir -p ~/.data/var/log/redis


## Testujemy instalację

Uruchamiamy serwer, korzystając ze skryptu *redis.sh*:

    :::bash
    redis.sh
        [26787] 28 Dec ... * Server started, Redis version 2.1.8
        [26787] 28 Dec ... * The server is now ready to accept connections on port 6379
        [26787] 28 Dec ... - 0 clients connected (0 slaves), 790448 bytes in use

W innym terminalu wpisujemy:

    :::bash
    redis-cli -p 6379  set mykey "hello world"
        OK
    redis-cli -p 6379 get mykey
        hello world

Albo przechodzimy bezpośrednio do powłoki (klienta) wykonując polecenie:

    :::bash
    redis-cli
      set mykey "hello world"
      get mykey

Więcej poleceń jest opisanych
w [﻿A fifteen minutes introduction to Redis data types](http://redis.io/topics/data-types-intro).

Przykład K. Minarika [Redis Twitter example](https://github.com/karmi/redis_twitter_example) –
an executable tutorial showcasing Twitter „lookalike” in Redis.


## Gdzie są moje bazy?

Określamy te miejsca w pliku konfiguracyjnym.
Domyślne ustawienia są takie:

    ./dump.rb

Moje ustawienia są takie:

    :::bash
    # The filename where to dump the DB
    dbfilename dump.rdb

    # The working directory.
    #
    # The DB will be written inside this directory, with the filename specified
    # above using the 'dbfilename' configuration directive.
    #
    # Also the Append Only File will be created inside this directory.
    #
    # Note that you must specify a directory here, not a file name.
    # dir ./
    dir /home/wbzyl/.data/var/lib/redis

## TODO: Coś do */etc/init.d*

Skrypt *redis* do poprawki:

    #! /bin/sh
    ### BEGIN INIT INFO
    # Provides:		redis-server
    # Required-Start:	$syslog
    # Required-Stop:	$syslog
    # Should-Start:		$local_fs
    # Should-Stop:		$local_fs
    # Default-Start:	2 3 4 5
    # Default-Stop:		0 1 6
    # Short-Description:	redis-server - Persistent key-value db
    # Description:		redis-server - Persistent key-value db
    ### END INIT INFO


    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    DAEMON=/usr/local/bin/redis-server
    DAEMON_ARGS=/etc/redis.conf
    NAME=redis-server
    DESC=redis-server
    PIDFILE=/var/run/redis.pid

    test -x $DAEMON || exit 0
    test -x $DAEMONBOOTSTRAP || exit 0

    set -e

    case "$1" in
      start)
            echo -n "Starting $DESC: "
            touch $PIDFILE
            chown redis:redis $PIDFILE
            if start-stop-daemon --start --quiet --umask 007 --pidfile $PIDFILE --chuid redis:redis --exec $DAEMON -- $DAEMON_ARGS
            then
                    echo "$NAME."
            else
                    echo "failed"
            fi
            ;;
      stop)
            echo -n "Stopping $DESC: "
            if start-stop-daemon --stop --retry 10 --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON
            then
                    echo "$NAME."
            else
                    echo "failed"
            fi
            rm -f $PIDFILE
            ;;

      restart|force-reload)
            ${0} stop
            ${0} start
            ;;
      *)
            echo "Usage: /etc/init.d/$NAME {start|stop|restart|force-reload}" >&2
            exit 1
            ;;
    esac

    exit 0


## TODO: Logrotate

*redis.conf*:

    # Specify the log file name. Also 'stdout' can be used to force
    # Redis to log on the standard output. Note that if you use standard
    # output for logging but daemonize, logs will be sent to /dev/null
    # logfile /var/log/redis/redis.log
    logfile /home/wbzyl/.data/var/log/redis/redis.log

Czy coś takiego wystarczy?

    /home/wbzyl/.data/var/log/redis/*.log {
        weekly
        rotate 10
        copytruncate
        delaycompress
        compress
        notifempty
        missingok
    }

## Linki

* [Redis IO](http://redis.io/)
* [Try Redis](http://try.redis-db.com/)
* Karl Seguin. *Redis: Zero to Master in 30 minutes*,
  [Part 1](http://openmymind.net/2011/11/8/Redis-Zero-To-Master-In-30-Minutes-Part-1/),
  [Part 2](http://openmymind.net/2011/11/8/Redis-Zero-To-Master-In-30-Minutes-Part-2/)
* [Redis Clients](http://redis.io/clients)
* [Ohm] [ohm]
* [The Redis Cookbook](http://rediscookbook.org/)
* Simon Willison,
  [Redis tutorial, April 2010](http://simonwillison.net/static/2010/redis-tutorial/)
* [Real-time Collaborative Editing with Web Sockets,
  Node.js & Redis](http://nosql.mypopescu.com/post/653065773/redis-pub-sub-used-for-real-time-collaborative-web)
* [To Redis or Not To Redis?] [redis-or-not]


# ElasticSearch

Najpierw instalujemy Javę. Na przykład, w Fedorze robimy to tak:

    sudo yum install java-1.6.0-openjdk

Prosta instalacja dla trybu **development**. Dlaczego taka
instalacja: *w roku 2011 było ok. trzydziestu wydań ElasticSearch*.

Uwagi o instalacji w trybie **produkcyjnym**:

* [ElasticSearch pre-flight checklist](http://asquera.de/opensource/2012/11/25/elasticsearch-pre-flight-checklist/)
  by skade

[Pobieramy ostatnią wersję](https://github.com/elasticsearch/elasticsearch/downloads)
(ok. 16 MB) i rozpakowujemy ją w katalogu. Na przykład w *$HOME/.nosql/elasticsearch*:

    :::bash
    mkdir $HOME/.nosql/elasticsearch
    cd $HOME/.nosql/elasticsearch
    wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.18.7.zip
    unzip -a elasticsearch-0.18.7.zip
    rm -f elasticsearch
    ln -s elasticsearch-0.18.7 elasticsearch

Następnie tworzymy katalogi na logi, indeksy (bazę danych) i pliki
konfiguracyjne:

    :::bash
    mkdir -p $HOME/.data/var/log/elasticsearch  # logi
    mkdir -p $HOME/.data/var/lib/elasticsearch  # indeksy
    mkdir -p $HOME/.data/etc                    # plik konfiguracyjny

Sam program, będziemy uruchamiać za pomocą skryptu *elasticsearch.sh*

    :::bash elasticsearch.sh
    #! /bin/bash
    progname=$(basename $0 .sh)
    config=$HOME/.data/etc/elasticsearch.yml

    echo ""
    echo "---- $config"
    cat $config
    echo "-----------------------------------------------------------------------"
    echo ""

    $HOME/.nosql/elasticsearch/$progname/bin/elasticsearch -f -Des.config=$config

W skrypcie wpisałem ścieżkę do swojego pliku konfiguracyjnego
*elasticsearch.yml*. Oto jego zawartość:

    :::yaml HOME/.data/etc/elasticsearch.yml
    cluster.name: wlodek
    # indeksy: http://localhost:9200/<index name>/_status – sprawdzanie statusu
    index.number_of_shards: 1
    index.number_of_replicas: 0
    # ścieżki
    path.data: /home/wbzyl/.data/var/lib/elasticsearch
    path.logs: /home/wbzyl/.data/var/log/elasticsearch

**Uwaga** na ścieżki wpisane powyżej. *HOME* to niekoniecznie */home/wbzyl*.
Na przykład na Sigmie to katalog */home/inf/wbzyl*.


## Gdzie są moje indeksy

W katalogu *$HOME/.data/var/lib/elasticsearch/wlodek*.


## Running ElasticSearch as a non-root-user

* Clinton Gormley.
  [Running ElasticSearch as a non-root-user ](http://www.elasticsearch.org/tutorials/2011/02/22/running-elasticsearch-as-a-non-root-user.html)


## Testowanie instalacji

Wszystko działa? ElasticSearch nasłuchuje na porcie 9200. Sprawdźmy to:

    :::bash
    xdg-open http://localhost:9200

Zapiszmy coś w indeksach. Przeszukajmy to co zastało zapisane.
Na koniec usuńmy wszystkie wszystkie dane.

**TODO**

Możemy postąpić też tak. Instalujemy przeglądarkę webową
[elasticsearch-head](http://mobz.github.com/elasticsearch-head/),
i otwieramy ją w domyślnej przeglądarce:

    :::bash
    cd $HOME/.nosql
    git clone git://github.com/Aconex/elasticsearch-head.git
    xdg-open $HOME/.nosql/elasticsearch-head/index.html

Albo instalujemy przeglądarkę webową jako wtyczkę do Elasticsearch.

    :::bash
    elasticsearch/bin/plugin -install Aconex/elasticsearch-head
    xdg-open http://localhost:9200/_plugin/head/

Instalacja w systemie:

    :::bash
    sudo -u elasticsearch /usr/local/share/elasticsearch/bin/elasticsearch \
      -Des.config=/etc/elasticsearch/elasticsearch.yml -p /var/run/elasticsearch/es-wlodek.pid

Plik konfiguracyjny:

    :::yaml /etc/elasticsearch/elasticsearch.yml
    cluster:
      name: wlodek

      routing:
        allocation:
          concurrent_recoveries: 1

    # indeksy: http://localhost:9200/<index name>/_status – sprawdzanie statusu

    index:
      number_of_shards: 1
      number_of_replicas: 0

    # ścieżki

    path:
      home: /usr/local/share/elasticsearch
      conf: /etc/elasticsearch
      data: /var/lib/elasticsearch
      logs: /var/log/elasticsearch

    rootLogger: DEBUG, console, file

    logger:
      # log action execution errors for easier debugging
      action :      DEBUG

      index:
        shard:
          recovery: DEBUG
        store:      INFO
        gateway:    DEBUG
        engine:     DEBUG
        merge:      DEBUG
        translog:   DEBUG
      cluster:
        service:    DEBUG
        action:
          shard:    DEBUG
      gateway:      DEBUG
      discovery:    DEBUG
      jmx:          DEBUG
      httpclient:   INFO
      node:         DEBUG
      plugins:      DEBUG

    appender:
      console:
        type: console
        layout:
          type: consolePattern
          conversionPattern: "[%d{ABSOLUTE}][%-5p][%-25c] %m%n"

      file:
        type: dailyRollingFile
        file: ${path.logs}/${cluster.name}.log
        datePattern: "'.'yyyy-MM-dd"
        layout:
          type: pattern
          conversionPattern: "[%d{ABSOLUTE}][%-5p][%-25c] %m%n"

(pozostałe szczegóły [Data Recipes](http://thedatachef.blogspot.com/2011/01/bulk-indexing-with-elasticsearch-and.html))


## ICU Analysis for ElasticSearch

**TODO:** Dodać opis instalacji
[ICU Analysis plugin for ElasticSearch](https://github.com/elasticsearch/elasticsearch-analysis-icu).

Czy są **collation rules for the Polish language**?

ICU User Guide, [Collation Customization](http://userguide.icu-project.org/collation/customization)


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