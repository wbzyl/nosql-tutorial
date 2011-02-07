#### {% title "ElasticSearch" %}

* [You know, for Search](http://www.elasticsearch.org/)


## Pierwszy przykład

Instalujemy wtyczkę *river-couchdb*:

    bin/plugin -install river-couchdb

Uruchamiamy *elasticsearch*:

    bin/elasticsearch -f

Podłączamy się do **działającego** serwera *couchdb*:

    curl -XPUT 'localhost:9200/_river/nosql/_meta' -d @couchdb.json

gdzie plik *couchdb.json* zawiera:

    :::json
    {
        "type" : "couchdb",
        "couchdb" : {
            "host" : "localhost",
            "port" : 4000,
            "db" : "nosql",
            "filter" : null
        },
        "index" : {
            "index" : "nosql",
            "type" : "tweet",
            "bulk_size" : "100",
            "bulk_timeout" : "10ms"
        }
    }


Wyszukiwanie, odpytujemy *elasticsearch*:

    curl -XGET 'http://localhost:9200/nosql/tweet/_search?q=text:jquery&pretty=true'

Szukamy w polu *text*. W tym polu Twitter zapisuje to co wpisał w tweet
użytkownik.
