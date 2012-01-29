#### {% title "Instalacja & Konfiguracja" %}

<blockquote>
 {%= image_tag "/images/cv.jpg", :alt => "[How to write a CV]" %}
</blockquote>

W Google pod hasłem **NoSQL** znajdziemy linki do nowych
technologii będących alternatywą dla relacyjnych baz danych
takich jak PostgreSQL czy MySQL. Na wykładach zostaną
przedstawione bazy:

* ElasticSearch – wyszukiwarka
* MongoDB – baza dokumentowa
* CouchDB – baza dokumentowa

oraz bazy:

* Neo4j – baza grafowa
* Redis – baza klucz–wartość

Przed instalacją systemów baz danych powinniśmy sprawdzić, czy mamy
wystarczająco dużo miejsca na swoim koncie na *Sigmie*. W tym celu
logujemy się na *Sigmie*, gdzie wykonujemy polecenie:

    quota

Polecenie to wypisze nasze limity dyskowe.
Jeśli mamy mniej niż ok. 200 MB do dyspozycji, to musimy
zacząć od usunięcia zbędnych rzeczy.
Tutaj może być pomocne wykonanie polecenia,
wypisującego dziesięć katalogów zajmujących najwięcej miejsca:

    du -m ~ | sort -k1nr | head

**Zależności:**

Instalujemy silniki JavaScript: *js* i *v8*.
W Fedorze ściągamy paczki ze źródłami:

    wget ftp://fr2.rpmfind.net/linux/fedora/linux/development/rawhide/source/SRPMS/v/v8-3.3.10-4.fc17.src.rpm
    ftp://fr2.rpmfind.net/linux/fedora/linux/development/rawhide/source/SRPMS/j/js-1.8.5-9.fc17.src.rpm

i budujemy pakiety:

    rpmbuild --rebuild v8-3.3.10-4.fc17.src.rpm
    rpmbuild --rebuild js-1.8.5-9.fc17.src.rpm

(Ostatnie wersje ze stycznia 2012.)

Być może trzeba będzie zainstalować jeszcze zależności, np.

    sudo yum install autoconf213

**Post Installation.** Całą instalację zakończymy dodając
do ścieżek wyszukiwania *PATH* ścieżki do zainstalowanych programów
oraz skryptów.
W tym celu dopiszemy w pliku *~/.bashrc*:

    :::text
    export PATH=$HOME/.nosql/bin:$PATH

Teraz wypadałoby wczytać nowe ustawienia.
Dlatego przelogowujemy się (zalecane podejście) albo wykonujemy polecenie:

    source ~/.bashrc

Same bazy powinniśmy trzymać poza katalogami, które zostały utworzone
w czasie instalacji (dlaczego?).

Ja trzymam wszystkie swoje bazy w katalogu *$HOME/.data*.
Domyślne ustawienia są inne, dlatego demony baz danych
uruchamiam ze skryptów w których podaję odpowiednie ścieżki.
Same skrypty są tutaj:

* [MongoDB](xxx) – TODO: uaktualnić
* [ElasticSearch](https://gist.github.com/1687963)

<!--
* [Redisa](https://gist.github.com/1374681)
-->


## Uwagi o instalacji programów na *Sigmie*

1\. \[Rails] W laboratoriach na komputerach lokalnych w trakcie konfiguracji nie
są tworzone dowiązania symboliczne do plików poza katalogiem */home*.
Powoduje to masę problemów z instalacją gemów.

Przed zalogowaniem się na Sigmę:

    rpm -qa | grep sqlite3
    sqlite3-3.7.3-1.i686

Po zalogowaniu:

    ssh sigma
    rpm -qa | grep sqlite3
    sqlite3-3.7.3-1.i686
    sqlite3-devel-3.7.3-1.i686

Z tego wynika, że instalacja lokalna gemu *sqlite3* się nie powiedzie.

2\. \[CouchDB] Program konfigurujący *bootstrap* nie sprawdza,
czy linki symboliczne zostały poprawnie utworzone.

Na przykład, w trakcie konfiguracji CouchDB *bootstrap*
próbuje utworzyć linki symboliczne do katalogu */usr*. Dlatego
kompilacja zakończy się błędem albo po instalacji, programy nie będą
działać.

**Dlatego, najpierw logujemy się na *Sigmę*, a dopiero potem
wykonujemy wszystkie opisane poniżej polecenia.**


<blockquote>
 {%= image_tag "/images/benjamin_franklin.jpg", :alt => "[Benjamin Franklin]" %}
 <p>
   Ktoś mnie zapytał: „Jaki może być pożytek z balonu?”
   Odpowiedziałem: A jaki jest pożytek z nowo narodzonego dziecka?
 </p>
 <p class="author">— Benjamin Franklin (1706–1790)</p>
</blockquote>

# Każdy leży na swojej CouchDB

Będziemy instalować system CouchDB z rozszerzeniem GeoCouch.

Zaczynamy od sklonowania repozytoriów:

    :::bash
    git clone http://git-wip-us.apache.org/repos/asf/couchdb.git
    git clone git://github.com/couchbase/geocouch.git

Tak jak to opisano w GeoCouch README przechodzimy na gałąź 1.2.x:

    :::text
    cd couchdb
    git branch -a
    git checkout --track origin/1.2.x
    ./bootstrap
    ./configure --prefix=$HOME/.nosql
    make
    make install

*Uwaga:* Na Fedorze 64-bitowej, konfiguracja przebiega inaczej, musimy
podać ścieżkę do plików nagłówkowych:

    ./configure --prefix=$HOME/.nosql --with-erlang=/usr/lib64/erlang/usr/include

Zob. też [Road Map](https://issues.apache.org/jira/browse/COUCHDB).


## Post-install

Kończymy instalację tworząc nowy plik *sigma.ini* i wpisując do niego
następujące rzeczy:

    :::plain ~/.nosql/etc/couchdb/local.d/sigma.ini
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
    mkdir $HOME/.data/var/log/couchdb/

**Dwie uwagi**

1. Powyżej zamiast domyślnego numeru portu *5984* wpisujemy numer przydzielony na zajęciach.

2. Oczywiście zamiast */home/wbzyl/* wstawiamy ścieżkę do swojego katalogu domowego
(albo jakąś inną).

Hostami wirtualnymi zajmiemy się później:

    :::plain ~/.nosql/etc/couchdb/local.d/sigma.ini
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

3. Ja uruchamiam server CouchDB, korzystając ze skryptu
o takiej zawartości:

    :::bash
    #! /bin/bash
    couchdb -A $HOME/.data/etc/couchdb/local.d

a plik *sigma.ini* umieszczam w powyższym katalogu.
Dlaczego tak postępuję?


## Testujemy instalację

Uruchamiamy serwer:

    couchdb
      Apache CouchDB 1.1.1 (LogLevel=info) is starting.
      Apache CouchDB has started. Time to relax.
      [info] [<0.31.0>] Apache CouchDB has started on http://127.0.0.1:5984/

Sprawdzamy, czy instalacja przebiegła bez błędów:

    :::text
    curl http://127.0.0.1:5984
      {"couchdb":"Welcome","version":"1.1.2"}

Następnie wchodzimy na stronę:

    http://127.0.0.1:5984/_utils/

gdzie dostępny jest *Futon*, czyli narzędzie do administracji bazami
danych zarządzanymi przez CouchDB.

Informacje o bazach i serwerze można uzyskać kilkając w odpowiednie zakładki
*Futona*, albo korzystając programu *curl*:

    :::text
    curl -X GET http://127.0.0.1:5984/_all_dbs
    curl -X GET http://127.0.0.1:5984/_config

W odpowiedzi na każde żądanie HTTP (*request*), dostajemy
odpowiedź HTTP (*response*) w formacie [JSON][json].

Jeśli skorzystamy z opcji *-v*, to *curl* wypisze szczegóły tego co robi:

    curl -vX GET http://127.0.0.1:5984/_config

Chociaż teraz widzimy, że **Content-Type** jest ustawiony na
**text/plain;charset=utf-8**.  Dlaczego?

Często się zdarzało, że nie działał replikator.
Spróbujmy zreplikować jakąś bazę z serwera *Tao*, na przykład

    http://tao.inf.ug.edu.pl:5984/rock

Następnie replikujemy tę bazę lokalnie.

Replikację możemy wyklikać w *Futonie*, albo użyć programu *curl*:

    :::bash
    # {"source":"http://tao.inf.ug.edu.pl:5984/ls","target":"ls","create_target":true}
    curl -X POST http://127.0.0.1:5984/_replicate -H 'Content-Type: application/json' \
       -d '{"source":"http://tao.inf.ug.edu.pl:5984/ls","target":"ls","create_target":true}'

Uruchamiamy CouchDB via skrypt *couchdb*:

    cd ../etc/rc.d/
    ./couchdb help

Wcześniej w kodzie skryptu wykomentowujemy kilka wierszy:

    :::bash
    run_command () {
        command="$1"
        if test -n "$COUCHDB_OPTIONS"; then
            command="$command $COUCHDB_OPTIONS"
        fi
        # if test -n "$COUCHDB_USER"; then
        #     if su $COUCHDB_USER -c "$command"; then
        #         return $SCRIPT_OK
        #     else
        #         return $SCRIPT_ERROR
        #     fi
        # else
            if $command; then
                return $SCRIPT_OK
            else
                return $SCRIPT_ERROR
            fi
        # fi
    }

Czy można się obejść bez tych zmian?


## Gdzie są moje bazy?

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

Zaczynamy od *cd* do katalogu repozytorium:

    :::bash
    cd geocouch
    git checkout --track origin/couchdb1.2.x

Następnie ustawiamy wartość zmiennej *COUCH_SRC*, tak aby wskazywała
na katalog z zainstalowanym plikiem nagłówkowym *couch_db.hrl*.
i uruchamiamy *make*:

    :::text
    export COUCH_SRC=$HOME/.nosql/lib/couchdb/erlang/lib/couch-1.2.0a-384a75b-git/include
    make

Ponieważ nazwa tego katalogu, zależy od sumy SHA gałęzi, trzeba to
wcześniej sprawdzić, przykładowo:

    git log --graph --decorate --pretty=oneline --abbrev-commit | head -1
    * 384a75b (HEAD, origin/1.2.x, 1.2.x) fix show/list/external requested_path for rewrites

Kończymy instalację kopiując skompilowane pliki oraz plik konfiguracyjny GeoCouch
do odpowiednich katalogów:

    cp $HOME/.nosql/geocouch/etc/couchdb/default.d/geocouch.ini $HOME/.nosql/etc/couchdb/default.d/
    cp $HOME/.nosql/geocouch/build/*  $HOME/.nosql/lib/couchdb/erlang/lib/couch-1.2.0a-384a75b-git/ebin/

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



# MongoDB

Z serwera *github.com* klonujemy repozytorium:

    :::bash
    git clone git://github.com/mongodb/mongo.git

Następnie w katalogu *mongo* wykonujemy kolejno polecenia:

    :::bash
    cd mongo
    git checkout r2.0.2
    scons --usev8 all                            # build all binaries with v8
    scons --usev8 --prefix=$HOME/.nosql install
    git checkout master

Zamiast domyślnej maszyny Javascript o nazwie „Spider Monkey” (Firefox)
użyjemy – „V8” (Chrome).

Zakładam, że biblioteka V8 jest zainstalowana w systemie.

Fedora – kompilujemy pakiety *v8* i *v8-devel*. Zaczynamy od pobrania źródeł:

    :::bash
    wget ftp://fr2.rpmfind.net/linux/fedora/linux/development/rawhide/source/SRPMS/v/v8-3.3.10-4.fc17.src.rpm

**Uwaga:** Niestety na *Sigmie* powyższa procedura nie działa,
ponieważ nie jest zainstalowana biblioteka *Boost*.


### Instalacja na skróty

Pobieramy paczkę dla naszego systemu ze strony
[MongoDB Downloads](http://www.mongodb.org/downloads). Przykładowo:

    :::bash
    wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.0.2.tgz

Odpakowujemy archiwum:

    tar zxvf mongodb-linux-x86_64-2.0.2.tgz

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
      Tue Dec 28 ... MongoDB starting : pid=25909 port=27017  ...
      Tue Dec 28 ... git version: 3b7152d81bc6b30fa15bfd301d28924a33ac5dfe
      Tue Dec 28 ... sys info: Linux localhost.localdomain ...
      Tue Dec 28 ... [initandlisten] waiting for connections on port 27017
      Tue Dec 28 ... [websvr] web admin interface listening on port 27017+1000

Uruchamiamy powłokę *mongo*:

    :::bash
    mongo --port 27017
      MongoDB shell version: 1.9.1
      connecting to: 127.0.0.1:27017/test

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
[mongod.sh](https://gist.github.com/1662651).

W skrypcie wpiszemy ścieżkę do pliku konfiguracyjnego *mongodb.conf*,
w którym dostosujemy opcje do swoich potrzeb:

    :::plain ~/.data/etc/mongodb.conf
    journal=true            # wymaga ok. 0.5 GB miejsca na dysku
    rest=true
    cpu=true
    directoryperdb=true
    jsonp=true
    nssize=2
    smallfiles=true
    objcheck=true
    syncdelay=4
    logpath=/home/wbzyl/.nosql/var/log/mongodb/mongo.log
    pidfilepath=/home/wbzyl/.data/var/run/mongodb.pid

Oczywiście powyżej wpisujemy **swoje** ścieżki.

Teraz demona uruchamiamy w taki sposób:

    :::bash mongod.sh
    mongod.sh         # użyj domyślnego portu
    mongod.sh 16000   # użyj podanego portu


## Logrotate

Journal i bazy MongoDB zajmują sporo miejsca na dysku:

    ls -l ~/.data/var/lib/mongodb/journal/
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 12:36 prealloc.0
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 11:56 prealloc.1
    -rw-------. 1 wbzyl wbzyl 134217728 05-10 11:56 prealloc.2
    ls -l ~/.data/var/lib/mongodb/twitter/
    drwxrwxr-x. 2 wbzyl wbzyl     4096 05-10 12:01 _tmp
    -rw-------. 1 wbzyl wbzyl 16777216 05-10 12:36 twitter.0
    -rw-------. 1 wbzyl wbzyl 33554432 05-10 12:01 twitter.1
    -rw-------. 1 wbzyl wbzyl  2097152 05-10 12:36 twitter.ns
    ...

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
    pidfile /home/wbzyl/.data/var/run/redis.pid   # mkdir -p ~/.nosql/var/run/
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
    dir /home/wbzyl/.data/var/lib/redis
    #
    # Specify the log file name. Also 'stdout' can be used to force
    # Redis to log on the standard output. Note that if you use standard
    # output for logging but daemonize, logs will be sent to /dev/null
    logfile /home/wbzyl/.data/var/log/redis/redis.log


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
