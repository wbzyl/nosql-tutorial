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
      dbPath: "/data/var/lib/mongodb"
      engine: "wiredTiger"
      wiredTiger:
        collectionConfig:
          blockCompressor: zlib

    net:
      bindIp: 127.0.0.1
      port: 27017

    # systemLog:
    #   destination: file
    #   path: "/data/var/log/mongod/mongod.log"
    #   timeStampFormat: "iso8601-utc"
    #   logAppend: true

    # processManagement:
    #   fork: true
    #   pidFilePath: "/data/var/run/mongod/mongod.pid"

Powyższe ścieżki są przykładowe. Należy wstawić swoje.

Teraz, aby uruchomić *mongod+WT* wystarczy wpisać na konsoli:

    :::sh
    mongod -f mongod.conf.yml

Zobacz [MongoDB 2.8 – New WiredTiger Storage Engine Adds Compression](http://comerford.cc/wordpress/2014/11/12/mongodb-2-8-new-wiredtiger-storage-engine-adds-compression/).


## Pokaż mi swoje logi...

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
