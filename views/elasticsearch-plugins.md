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

URL. Those can be added even after the process has started.”

Pierwszą wtyczkę nazwiemy *hello-elasticsearch*. Będzie to tzw. „site plugin”,
prosta aplikacja HTML korzystająca z jQuery.
Autorem wtyczki jest Karel Minarik.

Zaczniemy od wtyczki o nazwie *hello-elasticsearch*. Po instalacji
**wtyczko-aplikacja** jest dostępna z takiego url:

    http://localhost:9200/_plugin/hello-elasticsearch/

Instalacja z repozytorium *wbzyl/hello-elasticsearch* na Github:

    :::bash
    sudo /usr/share/elasticsearch/bin/plugin --install wbzyl/hello-elasticsearch
