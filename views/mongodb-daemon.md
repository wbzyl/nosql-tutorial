#### {% title "mongod – starting/stopping/profiling" %}

… na konsoli Bash.

*Uwaga:* Niektóre opcje zmieniały nazwy lub występowały tylko
w pewnych wersjach *mongod*. Poniżej korzystamy z opcji
dla wersji [2.8.0](http://docs.mongodb.org/manual/release-notes/2.8/);
zobacz też [Configuration File Options](http://docs.mongodb.org/manual/reference/configuration-options/).


## Uruchamianie

Zamiast wypisywać wszystkie opcje w linii poleceń prościej jest
wpisać część opcji w pliku konfiguracyjnym *mongod.conf*
i uruchomić mongo w taki sposób:

    :::bash
    mongod --config mongod.conf.yml
    ps ux | grep mongod
    tail -f …scieżka do pliku log…

A to fragment (z opcjami dla *standalone server*) pliku konfiguracyjnego:

    :::yaml mongod.conf.yml
    # new format for versions 2.6+
    # http://docs.mongodb.org/manual/reference/configuration-options/

    storage:
      dbPath: "/var/lib/mongodb"
      journal:
        enabled: true

    net:
      bindIp: 127.0.0.1
      port: 27017

    # systemLog:
    #   destination: file
    #   path: "/var/log/mongod/mongod.log"
    #   logAppend: true
    #   timeStampFormat: "iso8601-utc"

    # processManagement:
    #   fork: true
    #   pidFilePath: "/var/run/mongod/mongod.pid"

Powyższe ścieżki są przykładowe. Należy wstawić swoje.

Czasami w logach zapisywane jest za dużo danych.
Możemy to zmienić to na konsoli *mongo*:

    :::json
    db.getLogComponents()
    {
      "verbosity": 1,

      "writes":        { "verbosity": -1 },
      "accessControl": { "verbosity": -1 },
      "commands":      { "verbosity": -1 },
      "control":       { "verbosity": -1 },
      "geo":           { "verbosity": -1 },
      "indexing":      { "verbosity": -1 },
      "networking":    { "verbosity": -1 },
      "query":         { "verbosity": -1 },
      "storage": {
        "verbosity": -1,
        "journaling": { "verbosity": -1 }
      }
    }

Kilka przykładów:

    db.setLogLevel(2)                    // results in massive output
    db.setLogLevel(1)                    // set to the default value
    db.setLogLevel(1, "networking")
    db.getLogComponents().networking

Logowanie informacji *ProfilingStatus* też jest ważne:

    db.getProfilingStatus()
    {
      "was": 0,
      "slowms": 100
    }
    db.setProfilingLevel(level, slowms)


## Zatrzymywanie

Z konsoli *mongo*:

    :::js
    use admin
    db.shutdownServer()

albo z konsoli Bash:

    :::bash
    # NUMER_PROCESU odczytujemy z pliku z PID
    kill  -2 NUMER_PROCESU      # SIGINT
    kill -15 NUMER_PROCESU      # SIGTERM
    ps ux | grep mongod

(Oczywiście, zamiast wpisywania takich rzeczy należy przygotować
sobie prosty skrypt, który to za nas zrobi.)


## Kompresja danych z WiredTiger, *v2.8.0-rc1*

Zaczynamy od uruchomienia *mongod + WiredTiger* wpisując na konsoli
wymagane opcje i kilka innych, które wydają się nam interesujące,
zob. [index and collection-level options](http://source.wiredtiger.com/2.4.1/struct_w_t___s_e_s_s_i_o_n.html#a358ca4141d59c345f401c58501276bbb),
[storage engine options](http://source.wiredtiger.com/2.4.1/group__wt.html#ga9e6adae3fc6964ef837a62795c7840ed):

    :::sh
    mongod --dbpath /ssd/db/mongodb  --storageEngine wiredTiger \
      --wiredTigerCollectionConfig "block_compressor=bzip2" \
      --wiredTigerEngineConfig "async=(enabled=true,threads=4),statistics=(fast),create=true" \
      --bind_ip 0.0.0.0

Jeśli nie ma błędów, to przygotowujemy plik konfiguracyjny
*mongod.conf.yml* w formacie YAML:

    :::yaml mongod.conf.yml
    storage:
      dbPath: "/ssd/db/mongodb"
      engine: "wiredtiger"
      wiredTiger:
       collectionConfig: "block_compressor=bzip2"
       engineConfig: "statistics=(fast),checkpoint=(wait=120,log_size=1GB)"

    net:
      bindIp: 127.0.0.1
      port: 27017

    # systemLog:
    #   destination: file
    #   path: "/home/wbzyl/.data/var/log/mongod/mongod.log"
    #   timeStampFormat: "iso8601-utc"
    #   logAppend: true

    # processManagement:
    #   fork: true
    #   pidFilePath: "/home/wbzyl/.data/var/run/mongod/mongod.pid"

Teraz, aby uruchomić *mongod+WT* wystarczy wpisać na konsoli:

    :::sh
    mongod -f mongod.conf.yml
1
Zobacz [MongoDB 2.8 – New WiredTiger Storage Engine Adds Compression](http://comerford.cc/wordpress/2014/11/12/mongodb-2-8-new-wiredtiger-storage-engine-adds-compression/).
