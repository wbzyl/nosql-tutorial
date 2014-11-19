#### {% title "mongod – starting/stopping/profiling" %}

… z linii poleceń Bash.

*Uwaga:* Niektóre opcje zmieniały nazwy lub występowały tylko
w pewnych wersjach *mongod*. Poniżej korzystamy z opcji
dla wersji **2.8.8-rc0**.

## Uruchamianie

Zamiast wypisywać wszystkie opcje w linii poleceń prościej jest
wpisać część opcji w pliku konfiguracyjnym *mongod.conf*
i uruchomić mongo w taki sposób:

    :::bash
    mongod --config mongod.conf --bind_ip 127.0.0.1
    ps ux | grep mongod
    tail -f …scieżka do pliku log…

A to fragment (z opcjami dla *standalone server*) pliku konfiguracyjnego:

    #   Where to log
    logpath=/var/log/mongodb/mongod.log
    logappend=true
    #   Verbose logging output.
    verbose=true
    #   Fork and run in background
    fork=true
    #   Location of database
    dbpath=/var/lib/mongo
    #   Location of pidfile
    pidfilepath=/var/run/mongodb/mongod.pid
    #   Enables periodic logging of CPU utilization and I/O wait
    cpu=true
    #   Comma separated list of IP addresses to listen on.
    # bind_ip=127.0.0.1
    #   Specify port number to listen on.
    # port=27017

Powyższe ścieżki są przykładowe. Należy wstawić swoje.

Czasami w logach zapisywane jest za dużo danych.
Możemy to zmienić to na konsoli *mongo*:

    :::json
    db.getLogComponents()
    {
      "verbosity": 1,
      "accessControl": {
        "verbosity": -1
      },
      "commands": {
        "verbosity": -1
      },
      "control": {
        "verbosity": -1
      },
      "geo": {
        "verbosity": -1
      },
      "indexing": {
        "verbosity": -1
      },
      "networking": {
        "verbosity": -1
      },
      "query": {
        "verbosity": -1
      },
      "storage": {
        "verbosity": -1,
        "journaling": {
          "verbosity": -1
        }
      },
      "writes": {
        "verbosity": -1
      }
    }

Kilka przykładów:

    db.setLogLevel(2)                    // results in massive output
    db.setLogLevel(1)                    // set to the default value
    db.setLogLevel(1, "networking")
    db.getLogComponents().networking

Profiling (też ważne):

    db.getProfilingStatus()
    {
      "was": 0,
      "slowms": 100
    }
    db.setProfilingLevel(level, slowms)


## Zatrzymywanie

Te trzy linijki, należy zamienić na prosty skrypt Bash:

    :::bash
    ps ux | grep mongod
    kill -1 NUMER_PROCESU
    ps ux | grep mongod
