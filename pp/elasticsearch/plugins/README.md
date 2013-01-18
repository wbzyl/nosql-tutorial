# World's Smallest Application Hosted in elasticsearch

> Plugins can have “sites” in them, any plugin that exists under the plugins directory with a `_site` directory,
> its content will be statically served when hitting `/_plugin/[plugin_name]/` url.
> Those can be added even after the process has started.

— <http://www.elasticsearch.org/guide/reference/modules/plugins.html>

## Install

Stąd jest ten przykład:

    curl -# -L -k https://gist.github.com/gists/dc733632435da2149963/download | tar xv --strip=1 -C /tmp/hello-elasticsearch

Po drobnej kosmetyce (uaktualnienie do ostatnich wersji: jQuery, …):

    zip -mj hello-elasticsearch.zip index.html
    plugin -install hello-elasticsearch -url file:///tmp/hello-elasticsearch.zip
    sudo /usr/share/java/elasticsearch/bin/plugin \
      -install hello-elasticsearch \\
      -url file:///...cała ścieżka../hello-elasticsearch.zip
    xdg-open http://localhost:9200/_plugin/hello-elasticsearch/index.html

lub

    xdg-open http://localhost:9200/_plugin/hello-elasticsearch/  #<= slash is required

Gotowe.

Usuwanie wtyczki:

    sudo /usr/share/java/elasticsearch/bin/plugin -remove hello-elasticsearch

## Więcej info o wtyczkach

* [Plugins](http://www.elasticsearch.org/guide/reference/modules/plugins.html)