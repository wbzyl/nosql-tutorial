#### {% title "Wyszukiwanie z ElasticSearch" %}

<blockquote>
 {%= image_tag "/images/john_cage.jpg", :alt => "[John Cage]" %}
 <p>I can't understand why people are frightened of new ideas.
    I'm frightened of the old ones.
 </p>
 <p class="author">— John Cage (1912–1992)</p>
</blockquote>

Zaczynamy od lektury [What's Wrong with SQL search](http://philip.greenspun.com/seia/search).

Książka:

* [Elasticsearch – The Definitive Guide](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html)

Podręczne linki do [ElasticSearch](https://github.com/elasticsearch):

* [You know, for Search](http://www.elasticsearch.org/)
* [Stempel (Polish) Analysis for ElasticSearch](https://github.com/elasticsearch/elasticsearch-analysis-stempel) –
  this plugin includes the **polish** analyzer and **polish_stem** token filter.
* [JSON specification for the Elasticsearch's REST API](https://github.com/elasticsearch/elasticsearch/tree/master/rest-api-spec)
* [Guides](http://www.elasticsearch.org/guide/)
* [References](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/index.html):
  - [setup](http://www.elasticsearch.org/guide/reference/setup/)
  - [search API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search.html)
    - [aggregations](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations.html)
  - [query dsl](http://www.elasticsearch.org/guide/reference/query-dsl/)
  - [mapping](http://www.elasticsearch.org/guide/reference/mapping/)
  - [analysis](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis.html)
* [Modules](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules.html):
  - [plugins](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-plugins.html)
  - [text scoring in scripts](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-advanced-scripting.html) –
  df, tf, ttf

Misc tools:

* [es2unix](https://github.com/elasticsearch/es2unix) – Elasticsearch API consumable by the command line
* [stream2es](https://github.com/elasticsearch/stream2es) –
  stream data into ES (Wikipedia, Twitter, stdin, or other ESes)
* [elasticdump](https://github.com/taskrabbit/elasticsearch-dump) – import and export tools for Elasticsearch

[Pobieramy ostatnią stabilną wersję](http://www.elasticsearch.org/download/) Elasticsearch
i [instalujemy ją na swoim komputerze](http://www.elasticsearch.org/guide/reference/setup/installation.html).

[ElasticSearch driver dla języka Ruby](https://github.com/elasticsearch/elasticsearch-ruby), v1.0.6:

* [elasticsearch](http://rubydoc.info/gems/elasticsearch)
* [elasticsearch-transport](http://rubydoc.info/gems/elasticsearch-transport)
* [elasticsearch-api](http://rubydoc.info/gems/elasticsearch-api)

Gem *elasticsearch-transport* korzysta z gemu [faraday](http://rubydoc.info/gems/faraday/).


## Przykładowa instalacja z paczki

Pobieramy ostatnie wersje ElasticSearch i Kibana ze strony
[Get Started…](https://www.elastic.co/start)
i postępujemy według instrukcji.

W katalogu *config* podmieniamy node name, np. na:

    :::yaml elasticsearch.yml
    node.name: "John Cage"

I uruchamiamy *elasticsearch*.

Domyślnie ElasticSearch nasłuchuje na porcie 9200, a Kibana na 5601:

    :::bash
    http://localhost:9200/?pretty
    http://localhost:5601 # przechodzimy do Console w zakładce DevTools

ElasticSearch zwraca wynik wyszukiwania w formacie JSON.
Dlatego wygodnie jest już teraz zainstalować
dodatek do Firefoks o nazwie [JSONView](http://jsonview.com/).

<!--

## Instalujemy wtyczki Stempel, Head i Marvel

Każdą wtyczkę instalujemy korzystając z programu *plugin*:

    :::bash
    bin/plugin -install elasticsearch/elasticsearch-analysis-stempel/2.4.1

Wersja 2.4.1 działa z wersjami 1.4 *elasticsearch*.

Wtyczka Head to „a web front end for an ElasticSearch cluster”:

    bin/plugin -install mobz/elasticsearch-head

i wchodzimy na stronę wtyczki Head:

    xdg-open http://localhost:9200/_plugin/head/

Więcej informacji – [What is elasticsearch-head?](http://mobz.github.com/elasticsearch-head/).

[Marvel is a management and monitoring tool for Elasticsearch](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_installing_elasticsearch.html),
which is free for development use. It comes with an interactive
console called **Sense**, which makes it easy to talk to Elasticsearch
directly from your browser:

    bin/plugin -i elasticsearch/marvel/latest

You probably don’t want Marvel to monitor your local cluster, so you
can disable data collection with this command:

    echo 'marvel.agent.enabled: false' >> config/elasticsearch.yml

i wchodzimy na stronę wtyczki Marvel:

    xdg-open http://localhost:9200/_plugin/marvel/sense

-->

<blockquote>
 <p>The usual purpose of a full-text search engine is to return
  <b>a small number</b> of documents matching your query.
</blockquote>

# Your data, Your search

…czyli kilka przykładów ze strony
[Your Data, Your Search](http://www.elasticsearch.org/blog/2010/02/12/yourdatayoursearch.html).

Podstawowe terminy to: **index** i **type**.

**Interpretacja URI w zapytaniach kierowanych do ElasticSearch:**

<pre>http://localhost:9200/<b>⟨index⟩</b>/<b>⟨type⟩</b>/...
</pre>

Częścią Elasticsearch jest wyszukiwarka [Apache Lucene](http://lucene.apache.org/).
Składnia zapytań Lucene jest opisana w dokumencie
[Query Parser Syntax](http://lucene.apache.org/core/old_versioned_docs/versions/3_5_0/queryparsersyntax.html).

Tworzenie i usuwanie indeksu o nazwie *tweets*:

    :::bash
    curl -XPUT localhost:9200/tweets
    curl -XDELETE localhost:9200/tweets


<blockquote>
 <p>Field names with the <b>same name</b> across types are highly
 recommended to have the <b>same type</b> and same mapping characteristics
 (analysis settings for example).
</blockquote>

## index & type w przykładach

Przykładowy dokument:

    :::json book.json
    {
      "isbn": "0812504321",
      "name": "Call of the Wild",
      "author": {
         "first_name": "Jack",
         "last_name": "London"
       },
       "pages": 128,
       "tags": ["fiction", "children"]
    }

Dodajemy ten dokument do */amazon/books* (**/index/type**):

    :::bash
    curl -XPUT http://localhost:9200/amazon/books/0812504321 -d @book.json
      {"ok":true,"_index":"amazon","_type":"books","_id":"0812504321","_version":1}

Przykładowe zapytanie (w **query string**):

    :::bash
    curl -s 'http://localhost:9200/amazon/books/_search?pretty=true&q=author.first_name:Jack'

Jeszcze jeden dokument:

    :::json cd.json
    {
       "asin": "B00192IV0O",
       "name": "THE E.N.D. (Energy Never Dies)",
       "artist": "Black Eyed Peas",
       "label": "Interscope",
       "release_date": "2009-06-09",
       "tags": ["hip-hop", "pop-rap"]
    }

Ten dokument dodajemy do */amazon/cds* (**/index/type**):

    :::bash
    curl -XPUT http://localhost:9200/amazon/cds/B00192IV0O -d @cd.json
      {"ok":true,"_index":"amazon","_type":"cds","_id":"B00192IV0O","_version":1}

Przykładowe zapytanie:

    :::bash
    curl -s 'http://localhost:9200/_search?pretty=true&q=label:Interscope'

albo, korzystając z programu [jq](http://stedolan.github.io/jq/):

    :::bash
    curl -s 'http://localhost:9200/_search?q=label:Interscope' | jq .

Wyszukiwanie po wszystkich typach w indeksie */amazon*:

    :::bash
    curl -s 'http://localhost:9200/amazon/_search?q=name:energy' | jq .

Wyszukiwanie w indeksie */amazon* po kilku typach:

    :::bash
    curl -s 'http://localhost:9200/amazon/books,cds/_search&q=name:energy' | jq .

Na koniec posprzątamy po sobie, czyli usuniemy oba
dodane dokumenty. W tym celu wystarczy usunąć indeks **/amazon**:

    :::bash
    curl -XDELETE 'http://localhost:9200/amazon'

Można też usunąć wszystkie dokumenty (zalecana jest ostrożność):

    :::bash
    curl -XDELETE 'http://localhost:9200/_all'

Na koniec zapytamy klaster ElasticSearch o zdrowie:

    :::bash
    curl -s 'http://localhost:9200/_cluster/health' | jq .
    curl -s 'http://localhost:9200/_cluster/health?format=yaml'  # YAML, v1.4+

Czy Elasticsearch ma REST API?

* [REST API & JSON & Elasticsearch](http://www.elasticsearch.org/guide/reference/api/).


## Korzystamy z JSON Query Language

Najpierw zapiszemy te dokumenty w ElasticSearch:

    :::bash
    curl -XPUT 'http://localhost:9200/twitter/users/kimchy' -d '
    {
       "name": "Shay Banon"
    }'

    curl -XPUT 'http://localhost:9200/twitter/tweets/1' -d '
    {
       "user": "kimchy",
       "postDate": "2009-11-15T13:12:00",
       "message": "Trying out Elastic Search, so far so good?"
    }'

    curl -XPUT 'http://localhost:9200/twitter/tweets/2' -d '
    {
       "user": "kimchy",
       "postDate": "2009-11-15T14:12:12",
       "message": "Another tweet, will it be indexed?"
    }'

Sprawdzamy, co zostało dodane:

    :::bash
    curl 'http://localhost:9200/twitter/users/kimchy?pretty=true'
    curl 'http://localhost:9200/twitter/tweets/1?pretty=true'
    curl 'http://localhost:9200/twitter/tweets/2?pretty=true'

Teraz możemy odpytywać indeks */twitter* korzystając *JSON query language*:

    :::bash
    curl 'http://localhost:9200/twitter/tweets/_search?pretty=true' -d '
    {
      "query": {
        "match": { "user": "kimchy" }
      }
    }'
    curl 'http://localhost:9200/twitter/tweets/_search?pretty=true' -d '
    {
       "query": {
         "term": { "user": "kimchy" }
       }
    }'

Jaka jest różnica między wyszukiwaniem z **match**
(w poprzednich wersjach zamiast *match* używano *text*) a z **term**?

Sprawdzamy ile jest dokumentów w indeksie *twitter*:

    :::bash
    curl http://localhost:9200/twitter/_count

Wyciągamy wszystkie dokumenty z indeksu *twitter*:

    :::bash
    curl 'http://localhost:9200/twitter/_search?pretty=true' -d '
    {
        "query": {
            "matchAll": {}
        }
    }'

Albo – dokumenty typu *users* z indeksu *twitter*:

    :::bash
    curl -XGET 'http://localhost:9200/twitter/users/_search?pretty=true' -d '
    {
      "query": {
        "matchAll": {}
      }
    }'


## Indeksy *Multi Tenant*

*Tenant* to najemca, dzierżawca, a *Multi Tenant* to…?

Czy poniższy przykład pozwala zrozumieć sens *multi tenancy*?

    :::bash
    curl -XPUT 'http://localhost:9200/bilbo/info/1' -d '{ "name": "Bilbo Baggins" }'
    curl -XPUT 'http://localhost:9200/frodo/info/1' -d '{ "name": "Frodo Baggins" }'

    curl -XPUT 'http://localhost:9200/bilbo/tweets/1' -d '
    {
        "user": "bilbo",
        "postDate": "2009-11-15T13:12:00",
        "message": "Trying out Elastic Search, so far so good?"
    }'
    curl -XPUT 'http://localhost:9200/frodo/tweets/1' -d '
    {
        "user": "frodo",
        "postDate": "2009-11-15T14:12:12",
        "message": "Another tweet, will it be indexed?"
    }'

Wyszukiwanie „multi”, po kilku indeksach:

    :::bash
    curl -XGET 'http://localhost:9200/bilbo,frodo/_search?pretty=true' -d '
    {
        "query": {
            "matchAll": {}
        }
    }'


## ES cluster health

Od czasu do czasu powinniśmy zapytać się ES o zdrowie:

    curl -s http://localhost:9200/_cluster/health

Dlaczego?
