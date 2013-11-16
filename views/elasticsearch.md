#### {% title "Wyszukiwanie z ElasticSearch" %}

<blockquote>
 {%= image_tag "/images/john_cage.jpg", :alt => "[John Cage]" %}
 <p>I can't understand why people are frightened of new ideas.
    I'm frightened of the old ones.
 </p>
 <p class="author">— John Cage (1912–1992)</p>
</blockquote>

Zaczynamy od lektury [What's Wrong with SQL search](http://philip.greenspun.com/seia/search).

Podręczne linki do [ElasticSearch](https://github.com/elasticsearch):

* [You know, for Search](http://www.elasticsearch.org/)
* [JSON specification for the Elasticsearch's REST API](https://github.com/elasticsearch/elasticsearch-rest-api-spec)
* [Guides](http://www.elasticsearch.org/guide/):
  - [Setup](http://www.elasticsearch.org/guide/reference/setup/)
  - [API](http://www.elasticsearch.org/guide/reference/api/)
  - [Query](http://www.elasticsearch.org/guide/reference/query-dsl/)
  - [Mapping](http://www.elasticsearch.org/guide/reference/mapping/)
  - [Facets](http://www.elasticsearch.org/guide/reference/api/search/facets/index.html)
  - [Plugins](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-plugins.html)
* [es2unix](https://github.com/elasticsearch/es2unix) – Elasticsearch API consumable by the command line
* [stream2es](https://github.com/elasticsearch/stream2es) –
  stream data into ES (Wikipedia, Twitter, stdin, or other ESes)


[Pobieramy ostatnią stabilną wersję](http://www.elasticsearch.org/download/) Elasticsearch
i [instalujemy ją na swoim komputerze](http://www.elasticsearch.org/guide/reference/setup/installation.html).

Doinstalowujemy wtyczkę *ElasticSearch-Head* (a web front end for an ElasticSearch cluster):

    /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head  # ścieżka dla wersji 0.90

i wchodzimy na stronę *ElasticSearch-Head*:

    xdg-open http://localhost:9200/_plugin/head/

Więcej informacji o tej wtyczce [What is this?](http://mobz.github.com/elasticsearch-head/).

ElasticSearch driver dla języka Ruby:

* Karel Minarik:
  - [What is Elasticsearch?](http://www.slideshare.net/karmi/elasticsearch-rubyshift-2013)
  - [Elasticsearch-Ruby](https://github.com/elasticsearch/elasticsearch-ruby) –
    a rich Ruby API and DSL for the ElasticSearch search engine/database:
    * [elasticsearch](http://rubydoc.info/gems/elasticsearch) (v0.4.1)
    * [elasticsearch-transport](http://rubydoc.info/gems/elasticsearch-transport) (v0.4.1)
    * [elasticsearch-api](http://rubydoc.info/gems/elasticsearch-api) (v0.4.1)
  - **retired** [Tire](https://github.com/karmi/tire)

Gem elasticsearch korzysta z gemu [faraday](http://rubydoc.info/gems/faraday/).


Różne:

* Karel Minarik
  - [Data Visualization with ElasticSearch and Protovis](http://www.elasticsearch.org/blog/2011/05/13/data-visualization-with-elasticsearch-and-protovis.html)
  - [Your Data, Your Search, ElasticSearch (EURUKO 2011)](http://www.slideshare.net/karmi/your-data-your-search-elasticsearch-euruko-2011)
  - [Reversed or “Real Time” Search in ElasticSearch](http://karmi.github.com/tire/play/percolated-twitter.html) –
  czyli „percolated twitter”
  - [Route requests to ElasticSearch to authenticated user's own index](https://gist.github.com/986390) (wersja dla Nginx)
* Clinton Gormley.
  [Terms of endearment – the ElasticSearch Query DSL explained](http://www.elasticsearch.org/tutorials/2011/08/28/query-dsl-explained.html)
  [Real time analytics of big data with Elasticsearch](http://www.slideshare.net/karmi/realtime-analytic-with-elasticsearch-new-media-inspiration-2013)
  ([Designing Dashboards & Data Visualisations in Web Apps ](http://www.slideshare.net/destraynor/designing-dashboards-data-visualisations-in-web-apps))

Przykładowe aplikacje:

* Karel Minarik.
  - [JavaScript Web Applications and elasticsearch ](http://www.elasticsearch.org/tutorials/2012/08/22/javascript-web-applications-and-elasticsearch.html) (plugin)
  - [Paramedic](https://github.com/karmi/elasticsearch-paramedic);
  [demo](http://karmi.github.com/elasticsearch-paramedic/)
  - [Search Your Gmail Messages with ElasticSearch and Ruby](http://ephemera.karmi.cz/) (Sinatra)

* [Seemespeak](https://github.com/seemespeak/seemespeak) –
  [Rails 4.0.1 app](http://rumble.seemespeak.org/)


## Przykładowa instalacja ze źródeł

Rozpakowujemy archiwum z ostatnią wersją
[ElasticSearch](http://www.elasticsearch.org/download/) (ok. 16 MB):

    :::bash
    tar xvf elasticsearch-0.90.6.tar.gz

A tak uruchamiamy *elasticsearch*:

    :::bash
    elasticsearch-0.90.6/bin/elasticsearch -f

I już! Domyślnie ElasticSearch nasłuchuje na porcie 9200:

    :::bash
    xdg-open http://localhost:9200

ElasticSearch zwraca wynik wyszukiwania w formacie JSON.
Jeśli preferujemy pracę w przeglądarce, to użyteczny
może być dodatek do Firefoks o nazwie
[JSONView](http://jsonview.com/) – that helps you view JSON documents
in the browser.

## Ściąga z Elasticsearch-Head

W zakładce *Structured Query* warto wstawić „✔” przy *Show query source*,
a w zakładce *Any Request* zmieniamy **POST** na **GET**.

Następnie dopisujemy do *Query* ścieżkę *_search*:

    http://localhost:9200/_search

W okienku *Validate JSON* wpisujemy, na przykład:

    :::json
    {"query":{"query_string":{"query":"mongo*"}}}

W *Result Transformer*, podmieniamy instrukcję z *return*
na przykład na:

    :::js
    return root.hits.hits;


<blockquote>
 <p>The usual purpose of a full-text search engine is to return
  <b>a small number</b> of documents matching your query.
</blockquote>

# Your data, Your search

…czyli kilka przykładów ze strony
[Your Data, Your Search](http://www.elasticsearch.org/blog/2010/02/12/yourdatayoursearch.html).

Podstawowe terminy to: **index** i **type** indeksu.

**Interpretacja URI w zapytaniach kierowanych do ElasticSearch:**

<pre>http://localhost:9200/<b>⟨index⟩</b>/<b>⟨type⟩</b>/...
</pre>

Częścią Elasticsearch jest wyszukiwarka [Apache Lucene](http://lucene.apache.org/).
Składnia zapytań Lucene jest opisana w dokumencie
[Query Parser Syntax](http://lucene.apache.org/core/old_versioned_docs/versions/3_5_0/queryparsersyntax.html).


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
