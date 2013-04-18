#### {% title "Replikacja – jakie to proste!" %}

Bazy możemy replikować za pomocą programu *curl*:

    :::bash
    curl -X POST http://127.0.0.1:5984/_replicate \
        -H "Content-Type: application/json" \
        -d '{"source":"http://couch.inf.ug.edu.pl/ls","target":"ls","create_target":true}'

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

lub możemy wkorzystać w tym celu Futona – zakładka *Replicator*.

Wklepywanie danych nie hańbi, ale możemy sobie oszczędzić żmudnego
wklepywania korzystając z prostego skryptu. Na początek, coś takiego powinno
wystarczyć:

    :::bash couchdb-replicate-from-couch.sh
    #! /bin/bash
    for i in "$@"
    do
      couch=http://couch.inf.ug.edu.pl/$i
      echo "replicate: $couch -> $i"
      curl -X POST http://127.0.0.1:5984/_replicate -H "Content-Type: application/json" \
        -d "{\"source\":\"$couch\",\"target\":\"$i\",\"create_target\":true}"
    done

Jeśli skrypt nazwiemy *couchdb-replicate-from-couch.sh*, to
to polecenie:

    :::bash
    ./couchdb-replicate-from-couch.sh gutenberg ls

zreplikuje bazy *gutenberg* i *ls* z komputera *couch.inf.ug.edu.pl*
do naszego CouchDB.

Dla przypomnienia, listę z nazwami baz możemy pobrać tak:

    :::bash
    curl couch.inf.ug.edu.pl/_all_dbs


