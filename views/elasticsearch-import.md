#### {% title "Hurtowy import danych do Elasticsearch" %}

Dokumentacja:

* [bulk API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/docs-bulk.html)
* cytaty wybrano z tej strony [Stanisław Jerzy Lec, Cytaty](http://cytaty.eu/autor/stanislawjerzylec.html)

The Elasticsearch REST API expects the following JSON structure:

    :::json
    { "index" : { "_index" : "db", "_type" : "collection", "_id" : "id" } } ← action and meta data
    ... JSON to be imported into Elasticsearch ...

Depending on the usage some fields are optional.


## Generujemy „przeplatane” JSON-y

Zwykle dane mamy w pliku *authors.json*, po jednym JSON-ie w wierszu, przykładowo

    :::json
    { "aphorism": "By dojść do źródła, trzeba płynąć pod prąd.", "tags": ["idea"] }

Aby zaimportować do Elasticsearch dane hurtem, musimy każdy JSON
poprzedzić JSONE-em z „action and metadata”, przykładowo takim:

    :::json
    { "index": { "_type": "lec" } }
    { "aphorism": "By dojść do źródła, trzeba płynąć pod prąd.", "tags": ["idea"] }

Jak to zrobić? Skorzystamy z narzędzia [jq](https://github.com/stedolan/jq):

    :::bash
    cat aphorisms.json | \
      jq --compact-output '{ "index": { "_type": "lec" } }, .' > aphorisms.bulk

To samo co powyżej, ale bez polecenia *cat*:

    :::bash
    < aphorisms.js jq --compact-output '{ "index": { "_type": "lec" } }, .' > aphorisms.bulk

JSON-y zapiszemy w authors/lec. Przed zapisaniem danych w elasticsearch,
usuniemy index *authors* (dlaczego?):

    :::bash
    curl -s -XDELETE localhost:9200/authors
    curl -s -XPOST   localhost:9200/authors/_bulk --data-binary @aphorisms.bulk


## CRUD

Delete, *delete-lec-authors.bulk*:

    :::json
    { "delete" : { "_index" : "authors", "_type" : "lec", "_id" : "1" } }
    { "delete" : { "_index" : "authors", "_type" : "lec", "_id" : "2" } }

Przykład:

    :::bash
    curl -s -XPOST localhost:9200/_bulk --data-binary @delete-lec-authors.bulk

Create or ‘put-if-absent’, *create-authors.bulk*:

    :::json
    { "create": { "_index": "authors", "_type": "lec", "_id": 1 } }
    { "aphorism": "Czas robi swoje. A ty człowieku?", "tags": ["man", "time"] }
    { "create": { "_index": "authors", "_type": "lec", "_id": 4 } }
    { "aphorism": "Bądź realistą: nie mów prawdy.", "tags": ["idea", "truth"] }

Przykład:

    :::bash
    curl -s -XPOST localhost:9200/_bulk --data-binary @create-authors.bulk
