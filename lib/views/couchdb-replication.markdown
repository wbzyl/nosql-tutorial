#### {% title "Replikacja – jakie to proste!" %}

Replikujemy bazę *lz*:

    :::shell-unix-generic
    curl -X POST http://127.0.0.1:4000/_replicate -H "Content-Type: text/html" \
      --data '{"source":"lz","target":"lz2-replica","create_target":true}'

    {"ok":true,"session_id":"1410...","source_last_seq":16,"history":
       [{"session_id":"1410...",
         "start_time":"Thu,...","end_time":"Thu,...",
         "start_last_seq":0,"end_last_seq":16,
         "recorded_seq":16,"missing_checked":0,"missing_found":5,
         "docs_read":5,"docs_written":5,"doc_write_failures":0}]}

A teraz replikujemy – między sobą – swoje bazy danych.
Na razie do replikacji wykorzystamy Futona.
