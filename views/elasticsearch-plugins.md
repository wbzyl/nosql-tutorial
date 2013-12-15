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

Pierwszą wtyczkę site plugin, którą będziemy instalować będzie
*hello-elasticsearch*. Wtyczka ta to prosta aplikacja HTML
korzystająca z jQuery. Autorem jej jest Karel Minarik.

Instalacja jest prosta dla wtyczek z repozytoriów
na serwerze *github.com*.

Dla wtyczki z repozytorium *wbzyl/hello-elasticsearch* wykonujemy na terminalu:

    :::bash
    sudo /usr/share/elasticsearch/bin/plugin --install wbzyl/hello-elasticsearch

Po instalacji aplikacja będzie dostępna z tego url:

    http://localhost:9200/_plugin/hello-elasticsearch/


### Wtyczka wbzyl/tweets-elasticsearch

Prezentacja statusów zebranych przez skrypt *fetch-tweets.rb*.
