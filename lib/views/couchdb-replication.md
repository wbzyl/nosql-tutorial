#### {% title "Replikacja – jakie to proste!" %}

Replikujemy bazę *ls*:

    :::bash
    curl -X POST http://127.0.0.1:5984/_replicate -H "Content-Type: application/json" \
      -d '{"source":"http://wbzyl.inf.ug.edu.pl:5984/ls","target":"ls","create_target":true}'
    {"ok":true,"session_id":"fb84...",
     "source_last_seq":5,
     "history":[{"session_id":"fb84...",
        "start_time":"Mon, 07 Mar 2011 19:08:14 GMT",
        "end_time":"Mon, 07 Mar 2011 19:08:16 GMT",
        "start_last_seq":0,
        "end_last_seq":5,
        "recorded_seq":5,
        "missing_checked":0,
        "missing_found":5,
        "docs_read":5,
        "docs_written":5,
        "doc_write_failures":0}]}

A teraz replikujemy – między sobą – swoje bazy danych.

W tym celu, w Futonie, klikamy w zakładkę (po prawej stronie) *Replicator*.


## Replikujemy bazy z CouchDB na Sigmie

Zaczynamy od pobrania listy z nazwami baz:

    curl http://sigma.ug.edu.pl:5984/_all_dbs

i wybieramy bazy, które nas interesują, na przykład:

    gutenberg ksiazki ls

Oczywiście do replikacji użyjemy prostego skryptu *couchdb-replicate-from-tau.sh*:

    :::bash couchdb-replicate-from-tau.sh
    #!/bin/bash
    for i in "$@"
    do
      tau=http://couch.inf.ug.edu.pl/$i
      echo "replicate: $tau -> $i"
      curl -X POST http://127.0.0.1:5984/_replicate -H "Content-Type: application/json" \
        -d "{\"source\":\"$tau\",\"target\":\"$i\",\"create_target\":true}"
    done

Teraz aby skopiować bazy na swój komputer wystarczy wykonać:

    :::bash
    ./couchdb-replicate-from-tau.sh gutenberg plugin ls
