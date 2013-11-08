#### {% title "Wtyczki Elasticsearch" %}

* [Dokumentacja](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-plugins.html)
* Karel Minarik:
  - [JavaScript Web Applications and Elasticsearch](http://www.elasticsearch.org/tutorials/javascript-web-applications-and-elasticsearch/)
  - [World's Smallest Application Hosted in Elasticsearch](https://gist.github.com/karmi/3381710/)
* Lukáš Vlček:
  - [BigDesk](https://github.com/lukas-vlcek/bigdesk), [demo](http://bigdesk.org/)
  - [ElasticSearch Javascript client](https://github.com/lukas-vlcek/elasticsearch-js)

Co to są **site plugins**:

„Plugins can have »sites« in them, any plugin that exists under the
*plugins* directory with a *_site* directory, its content will be
statically served when hitting
    /_plugin/[plugin_name]/
url. Those can be added even after the process has started.”

Pierwszą wtyczkę nazwiemy *hello_es*. Będzie to tzw. „site plugin”,
prosta aplikacja HTML korzystająca z jQuery.

Zaczniemy od wtyczki o nazwie *hello-elasticsearch*. Po instalacji
**wtyczko-aplikacja** jest dostepna z takiego url:

    http://localhost:9200/_plugin/hello-elasticsearch/index.html

Instalacja 1:

    :::bash
    sudo /usr/share/elasticsearch/bin/plugin -install hello-elasticsearch \
      -url https://gist.github.com/karmi/3381710/raw/6d980c1e2f99321a382c59ef649902a0d60ea3f1/hello-elasticsearch.zip

Instalacja 2:

    :::bash
    mkdir -p /tmp/hello-elasticsearch
    cd /tmp
    curl -s -L -k https://gist.github.com/gists/dc733632435da2149963/download | \
      tar xv --strip=1 -C /tmp/hello-elasticsearch
    zip -mj hello-elasticsearch.zip /tmp/hello-elasticsearch/*
    plugin -install hello-elasticsearch -url file:///tmp/hello-elasticsearch.zip

Instalacja 3 z repozytorium *wbzyl/hello-elasticsearch* na Github:

    :::bash
    sudo /usr/share/elasticsearch/bin/plugin -install wbzyl/hello-elasticsearch



## Imieniny – prosta aplikacja w formie „site plugin”

Eksport danych z MongoDB, konwersja na format wymagany przez ElasticSearch
bulk API:

    :::
    mongoexport

Przykładowy „przeplatany” JSON:

    :::json
    ???

Format danych dla bulk import, dla *kiedy*:

    :::json
    { "index": { "_type": "kiedy" } }
    { "day" : 28, "month" : 1, "names" : [ "Walerego", "Radomira", "Tomasza" ] }

dla *kto*:

    :::bash
    { "index": { "_type": "kto" } }
    { "name": "Walerego", "day" : 28, "month" : 1 }

Porządki i import danych do ElasticSearch:

    :::bash
    curl -X DELETE localhost:9200/imieniny
    curl -X POST   localhost:9200/imieniny/_bulk' --data-binary @imieniny.bulk
    curl -X POST   localhost:9200/_refresh
