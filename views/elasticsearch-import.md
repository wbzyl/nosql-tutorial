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
    cat concepts.json | \
      jq --compact-output '{ "index": { "_type": "lec" } }, .' > concepts.bulk

To samo co powyżej, ale bez *cat*:

    :::bash
    < concepts.js jq --compact-output '{ "index": { "_type": "lec" } }, .' > concepts.bulk

Zanim zapiszemy dane w bazie, usuwamy indeks *concepts* (dlaczego?):

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
    curl -s -XPOST localhost:9200/_bulk --data-binary @create-ideas.bulk


## Przykłady

Więcej przykładów umieściłem w katalogu *pp/elasticsearch/bulk*.


<blockquote>
  <p><b>Mapping types</b> are containers for documents, in a similar way to how tables in a relational
  database are containers for rows. They are often called simply types, because you'd put
  different types of documents in different mapping types.</p>
  <p class="author"><a href="http://www.manning.com/hinman/">Elasticsearch in Action</a></p>
</blockquote>

## Mapping types

Instalujemy the [Stempel Analysis plugin](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-stempel.html):

    :::bash
    elasticsearch-plugin install analysis-stempel

It integrates Lucene’s Stempel analysis module for Polish into elasticsearch.
The plugin provides the _polish_ analyzer and _polish_stem_ token filter,
which are not configurable.

„You can think of a mapping like a schema in a relational database,
because it contains information about each field. For example,
«artist» would be a string, while «price» could be an integer.”

* [Core Simple Field Types](https://www.elastic.co/guide/en/elasticsearch/guide/master/mapping-intro.html#core-fields).

Na przykład, poniższe polecenie wypisze typy przypisane automatycznie
przez Elasticsearch dokumentom z *concepts/lec*:

    :::bash
    curl -s localhost:9200/concepts/_mapping/lec | jq .

Oto wynik:

    :::json
    {
      "concepts": {
        "mappings": {
          "lec": {
            "properties": {
              "quote": {
                "type": "text",
                "analyzer": "polish"
                "fields": {
                  "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                  }
                }
              },
              "tags": {
                "type": "text",
                "fields": {
                  "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                  }
                }}}}}}}

To better understand what is going on, you can use the analyze API
to see how text is analyzed. Porównajmy _standard_ i _polish_ analyzers:

    :::text
    GET /_analyze
    {
      "analyzer": "standard",
      "text": "Żyjemy dłużej, ale mniej dokładnie i krótszymi zdaniami."
    }
    GET /_analyze
    {
      "analyzer": "polish",
      "text": "Żyjemy dłużej, ale mniej dokładnie i krótszymi zdaniami."
    }

A tak definiujemy swoje „mapping”:

    :::bash
    curl -s -XPUT localhost:9200/concepts/lec/_mapping -d '
    {
      "lec": {
        "properties": {
          "tags": {
            "type": "string",
            "index": "not_analyzed"
          },
          "quote": {
            "type": "string",
            "analyzer": "snowball"
          }
        }
      }
    }'

Oto wynik:

    :::json
    {
      "status": 400,
      "error": "MergeMappingException[Merge failed with failures …"
    }

Niestety nie udało się uaktualnić typów. W takiej sytuacji musimy
usunąć indes *concepts*. Następnie toworzymy pusty index
w którym zapisujemy powyżej zdefiniowane mapping.
Dopiero na końcu zapisujemy dane:

    :::bash
    curl -s -XDELETE localhost:9200/concepts
    curl -s -XPOST localhost:9200/concepts
    curl -s -XPUT localhost:9200/concepts/lec/_mapping -d '
    {
      "lec": {
        "properties": {
          "tags": {
            "type": "string",
            "index": "not_analyzed"
          },
          "quote": {
            "type": "string",
            "analyzer": "snowball"
          }
        }
      }
    }'
    curl localhost:9200/concepts/_bulk --data-binary @concepts.bulk

Sprawdzamy nasze mapping:

    :::bash
    curl -s localhost:9200/concepts/lec/_mapping

Oto wynik:

    :::json
    {
      "lec": {
        "properties": {
          "tags": {
            "index_options": "docs",
            "omit_norms": true,
            "index": "not_analyzed",
            "type": "string"
          },
          "quote": {
            "analyzer": "snowball",
            "type": "string"
          }
        }
      }
    }

I mamy to o co prosiliśmy. No, prawie!

Przykładowe zapytania, w których korzystamy
z [Lucene Query Syntax](http://www.lucenetutorial.com/lucene-query-syntax.html):

    :::bash
    curl -s 'localhost:9200/concepts/lec/_search?q=kakao'         | jq '.hits.hits[]'
    curl -s 'localhost:9200/concepts/lec/_search?q=quote:kakao'   | jq '.hits.hits[]'
    curl -s 'localhost:9200/concepts/lec/_search?q=tags:kakao'    | jq '.hits.hits[]'
    curl -s 'localhost:9200/concepts/lec/_search?q=tags:krowie'   | jq '.hits.hits[]'
    curl -s 'localhost:9200/concepts/lec/_search?q=quote:chocia*' | jq '.hits.hits[]' # polskie literki… bug?

**TODO:** Zainstalować i użyć
[Morfologik (Polish) Analysis Plugin for ElasticSearch ](https://github.com/monterail/elasticsearch-analysis-morfologik)
