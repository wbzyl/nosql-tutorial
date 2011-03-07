#### {% title "Replikacja – jakie to proste!" %}

Replikujemy bazę *lz*:

    :::shell-unix-generic
    curl -X POST http://127.0.0.1:5984/_replicate -H "Content-Type: application/json" \
      -d '{"source":"http://sigma.ug.edu.pl:5984/lz","target":"lz","create_target":true}'
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
Na razie do replikacji wykorzystamy Futona.

Teraz kolej na lekturę [New Features in Replication](http://blog.couchone.com/post/468392274):

* [Change Notifications](http://guide.couchdb.org/draft/notifications.html)
* Filters


## Replikujemy bazy z CouchDB na Sigmie

Zaczynamy od pobrania listy z nazwami baz:

    curl http://sigma.ug.edu.pl:5984/_all_dbs

i wybieramy bazy, które nas interesują:

    gutenberg ksiazki ls movies nosql nyt-obama rock

Piszemy prosty skrypt w bashu replikujące te bazy:

    :::shell-unix-generic
    #!/bin/bash
    for i in "$@" 
    do 
      sigma=http://sigma.ug.edu.pl:5984/$i
      echo "replicate: $sigma -> $i"
      curl -X POST http://127.0.0.1:5984/_replicate -H "Content-Type: application/json" \
        -d "{\"source\":\"$sigma\",\"target\":\"$i\",\"create_target\":true}"
    done
