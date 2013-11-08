#### {% title "Hurtowy import danych do Elasticsearch" %}

Dokumentacja:

* [bulk API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/docs-bulk.html)
* [bulk UDP API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/docs-bulk-udp.html)
* [jq](http://stedolan.github.io/jq/) – a lightweight and flexible command-line JSON processor
* cytaty wybrano z tej strony [Stanisław Jerzy Lec, Cytaty](http://cytaty.eu/autor/stanislawjerzylec.html)

The Elasticsearch REST API expects the following JSON structure:

    :::json
    { "index" : { "_index" : "db", "_type" : "collection", "_id" : "id" } } ← action and meta data
    ... JSON to be imported into Elasticsearch ...

Depending on the usage some fields are optional.


## Generujemy „przeplatane” JSON-y

Zwykle dane mamy w pliku *ideas.json*, po jednym JSON-ie w wierszu,
na przykład:

    :::json
    { "quote": "By dojść do źródła, trzeba płynąć pod prąd.", "tags": ["idea"] }

Aby zaimportować do Elasticsearch dane hurtem, musimy każdy JSON
poprzedzić JSONE-em z „action and metadata”, przykładowo takim:

    :::json
    { "index": { "_type": "lec" } }
    { "quote": "By dojść do źródła, trzeba płynąć pod prąd.", "tags": ["idea"] }

Jak to zrobić? Skorzystamy z narzędzia [jq](https://github.com/stedolan/jq):

    :::bash
    cat concepts.js | \
      jq --compact-output '{ "index": { "_type": "lec" } }, .' > concepts.bulk

Zanim zapiszemy dane w bazie, usuniemy indeks *concepts*:

    :::bash
    curl -s -XDELETE localhost:9200/concepts ; echo  # add newline
    curl -s -XPOST   localhost:9200/concepts/_bulk --data-binary @concepts.bulk ; echo


## CRUD

Delete, *delete-lec-ideas.bulk*:

    :::json
    { "delete" : { "_index" : "ideas", "_type" : "lec", "_id" : "1" } }
    { "delete" : { "_index" : "ideas", "_type" : "lec", "_id" : "2" } }

Przykład:

    :::bash
    curl -s -XPOST localhost:9200/_bulk --data-binary @delete-lec-ideas.bulk ; echo

Create or ‘put-if-absent’, *create-ideas.bulk*:

    :::json
    { "create": { "_index": "ideas", "_type": "lec", "_id": 1 } }
    { "quote": "Czas robi swoje. A ty człowieku?", "tags": ["man", "time"] }
    { "create": { "_index": "ideas", "_type": "lec", "_id": 4 } }
    { "quote": "Bądź realistą: nie mów prawdy.", "tags": ["idea", "truth"] }

Przykład:

    :::bash
    curl -s -XPOST localhost:9200/_bulk --data-binary @create-ideas.bulk ; echo


## Przykłady

Więcej przykładów umieściłem w katalogu *pp/elasticsearch/bulk*.


## Mappings

**TODO** przykład z tweets!


## Bulk UDP

> The idea is to provide a low latency UDP service
> that allows to easily index data
> that **is not of critical nature**.

Konfiguracja, */etc/elasticsearch/elasticsearch.yml*:

    :::json
    bulk.udp.enabled: true

*szymborska.bulk*:

    :::json
    { "index": { "_index": "ideas", "_type": "szymborska", "_id": 1 } }
    { "quote": "Tyle wiemy o sobie, ile nas sprawdzono.", "tags": ["idea", "lechery"] }
    { "index": { "_index": "ideas", "_type": "szymborska", "_id": 2 } }
    { "quote": "Kto patrzy z góry, ten najłatwiej się myli.", "tags": ["above", "mistake"] }
    { "index": { "_index": "ideas", "_type": "szymborska", "_id": 3 } }
    { "quote": "Żyjemy dłużej, ale mniej dokładnie i krótszymi zdaniami.", "tags": ["life"] }
    { "index": { "_index": "ideas", "_type": "szymborska", "_id": 4 } }
    { "quote": "Cud pierwszy lepszy: krowy są krowami.", "tags": ["miracle", "cow"] }

Przykład (korzystamy z narzędzia *netcat*):

    :::bash
    cat szymborska.bulk | nc -w 0 -u localhost 9700

Użyteczne opcje programu *nc*: *-w* – timeout, *-u* – use UDP.



## TODO? przenieść do wykładu z ES plugins

    :::bash
    curl -X DELETE localhost:9200/imieniny
    curl -X POST   localhost:9200/imieniny/_bulk' --data-binary @imieniny.bulk
    curl -X POST   localhost:9200/_refresh

Sample JSON:

Format danych dla bulk import, dla *kiedy*:

    :::json
    { "index": { "_type": "kiedy" } }
    { "day" : 28, "month" : 1, "names" : [ "Walerego", "Radomira", "Tomasza" ] }

dla *kto*:

    :::bash
    { "index": { "_type": "kto" } }
    { "name": "Walerego", "day" : 28, "month" : 1 }
