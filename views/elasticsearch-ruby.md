#### {% title "ElasticSearch & Ruby" %}

<blockquote>
 {%= image_tag "/images/daniel_kahneman.jpg", :alt => "[Daniel Kahneman]" %}
 <p><b>The hallo effect</b> helps keep explanatory narratives
  simple and coherent by exaggerating the consistency
  of evaluations: good people do only good things
  and bad people are all bad.
 </p>
 <p class="author">— Daniel Kahneman</p>
</blockquote>

Do eksperymentów poniżej użyjemy rzeczywistych danych.
Będziemy zbierać statusy z Twittera.
Nie będziemy zbierać ich „jak leci”, tylko
te które zawierają interesujące nas słowa kluczowe.

Do filtrowania statusów skorzystamy
z [stream API](https://dev.twitter.com/docs/streaming-api):

* [public streams](https://dev.twitter.com/docs/streaming-apis/streams/public)
* [POST statuses/filter](https://dev.twitter.com/docs/api/1.1/post/statuses/filter) –
  tutaj należy skorzystać z **Oauth tool** za pomocą którego
  generujemy przykładowe zapytanie dla programu *curl*

W pliku *tracking* wpisujemy tę linijkę:

    :::ruby
    track=mongodb,elasticsearch,neo4j,redis

**Uwaga:** Jeśli do listy dopiszemy słowo **wow**, wpisywane w wielu
statusach, zostaniemy zalani tweetami – **wow!**

Jak widać statusy zawierają wiele pól i tylko kilka z nich zawiera
interesujące dane. Niestety, na konsoli trudno jest czytać interesujące nas fragmenty.
Są one wymieszane z jakimiś technicznymi rzeczami, np.
*profile_sidebar_fill_color*, *profile_use_background_image* itp.

Dlatego, przed wypisaniem statusu na ekran, powinniśmy go „oczyścić”
ze zbędnych rzeczy. Zrobimy to za pomocą skryptu w Ruby.

Poniżej będziemy korzystać z następujących gemów:

    gem install elasticsearch twitter rainbow awesome_print

{%= image_tag "/images/twitter_elasticsearch.jpeg", :alt => "[Twitter -> ElasticSearch]" %}

<blockquote>
<p>
  <h3>Access Rate Limiting</h3>
  <p>Each account may create only one standing connection to the
  Streaming API. Subsequent connections from the same account may
  cause previously established connections to be
  disconnected. Excessive connection attempts, regardless of success,
  will result in an automatic ban of the client's IP
  address. Continually failing connections will result in your IP
  address being blacklisted from all Twitter access.
</p>
  <p class="author"><a href="https://dev.twitter.com/docs/rate-limiting/1.1">…more on rate limiting</a></p>
</blockquote>

Zaczniemy od skryptu działającego podobnie do polecenia z *curl*:

* {%= link_to "fetch-tweets-simple.rb", "/elasticsearch/tweets/fetch-tweets-simple.rb" %}.

Streaming API Twittera wymaga uwierzytelnienia.
Klucze wpisujemy w pliku YAML z *credentials* wg schematu:

    :::yaml
    login: LLLLLL
    password: PPPPPP
    consumer_key: AAAAAAAAAAAAAAAAAAAAA
    consumer_secret: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    access_token: CCCCCCCC-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
    access_token_secret: DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

Skrypt ten uruchamiamy na konsoli w następujący sposób:

    :::bash
    ruby fetch-tweets-simple.rb ~/twitter_credentials.yml


## Twitter Stream ⟿ ElasticSearch

Do pobierania statusów i zapisywania ich w bazie wykorzystamy skrypt

* {%= link_to "fetch-tweets.rb", "/elasticsearch/tweets/fetch-tweets.rb" %}

<blockquote>
<p>
  <h3>Co to jest <i>mapping<i>?</h3>
  <p>Mapping is the process of defining how a document should be mapped to
  the Search Engine, including its searchable characteristics such as
  which fields are searchable and if/how they are tokenized.
  </p>
</blockquote>

Przed zapisaniem w bazie JSON-a ze statusem, skrypt
usuwa z niego niepotrzebne nam pola i spłaszcza jego strukturę.

Zanim zaczniemy zapisywać statusy w bazie, zdefinujemy i zapiszemy
w bazie ElasticSearch *mapping* dla statusów.

**TODO:** Update the mapping below to Elasticsearch v5.2.

    :::ruby create-mapping.rb
    mapping = {
      _ttl:            { enabled: true,  default: '16w'                              },
      properties: {
        language:      { type: 'keyword'                                             },
        created_at:    { type: 'date',    format: 'YYYY-MM-dd HH:mm:ss Z'            },
        text:          { type: 'text',    index:  'analyzed',    analyzer: 'english' },
        screen_name:   { type: 'keyword', index:  'not_analyzed'                     },
        hashtags:      { type: 'keyword', index:  'not_analyzed'                     },
        urls:          { type: 'keyword', index:  'not_analyzed'                     },
        user_mentions: { type: 'keyword', index:  'not_analyzed'                     }
      }
    }

Teraz uruchamiamy skrypt *create-index.rb* i po chwili sprawdzamy
czy *mapping* zostało zapisane w elasticsearch.

Jeśli nie było problemów, to uruchamiamy skrypt *fetch-tweets.rb*:

    :::bash
    ruby create-mapping.rb
    curl 'http://localhost:9200/tweets/_mapping?pretty'
    ruby fetch-tweets.rb ~/twitter_credentials.yml

Czekamy aż kilka statusów zostanie zapisanych w bazie
i wykonujemy na konsoli kilka prostych zapytań:

    :::bash
    curl -s 'localhost:9200/tweets/_count'
    curl -s 'localhost:9200/tweets/_search?q=*&size=2&pretty'
    curl -s 'localhost:9200/tweets/_search?size=2&pretty'
    curl -s 'localhost:9200/tweets/_search?from=10&size=2&pretty'

### TODO

Do wygodnego przeglądania statusów możemy użyć aplikacji
[tweets-elasticsearch](https://github.com/wbzyl/tweets-elasticsearch)
(tzw. *site plugin*).




<!--

## Faceted search, czyli wyszukiwanie fasetowe

[Co to są fasety?](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-facets.html)
„Facets provide aggregated data based on a search query. In the
simplest case, a terms facet can return facet counts for various facet
values for a specific field. ElasticSearch supports more facet
implementations, such as statistical or date histogram facets.”

**Uwaga:** Pole wykorzystywane do obliczeń fasetowych musi być typu:

* *numeric*
* *date* lub *time*
* *be analyzed as a single token*

Od prostych zapytań do zapytań z fasetami:

    :::bash
    curl -s 'localhost:9200/tweets/_count?q=redis&pretty'
    curl -s 'localhost:9200/tweets/_search?q=redis&pretty'

    curl -s 'localhost:9200/tweets/_search?pretty' -d '
    {
      "query": { "query_string": {"query": "redis"} },
      "sort": { "created_at": { "order": "desc" } }
    }'
    curl -s 'localhost:9200/tweets/_search?pretty' -d '
    {
      "query": { "query_string": {"query": "redis"} },
      "sort": { "created_at": { "order": "desc" } },
      "facets": { "hashtags": { "terms":  { "field": "hashtags" } } }
    }'
    curl -s 'localhost:9200/tweets/_search?pretty' -d '
    {
      "query": { "match_all": {} },
      "sort": { "created_at": { "order": "desc" } },
      "facets": { "hashtags": { "terms":  { "field": "hashtags" } } }
    }'
    curl -s 'localhost:9200/tweets/_search?size=0&pretty' -d '
    {
      "facets": { "hashtags": { "terms":  { "field": "hashtags" } } }
    }'

A tak wygląda „fasetowy” JSON:

    :::json
    { ... cut ...
      "facets" : {
         "hashtags" : {
            "_type" : "terms",
            "missing" : 167,
            "total" : 198,
            "other" : 127,
            "terms" : [
               { "term" : "dbts2013", "count" : 13 },
               { "term" : "nosql", "count" : 9 },
               { "term" : "couchdb", "count" : 9 },
               { "term" : "mongodb", "count" : 7 },
               { "term" : "Rails", "count" : 7 },
               { "term" : "cassandra", "count" : 6 },
               { "term" : "redis", "count" : 5 },
               { "term" : "rails", "count" : 5 },
               { "term" : "jobs", "count" : 5 },
               { "term" : "d3js", "count" : 5 }
            ]
          }
        }
      }

[Search API – Facets](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-facets.html):

* `missing` : the number of documents which have no value for the faceted field
* `total` : the total number of terms in the facet
* `other` : the number of terms not included in the returned facet

Effectively `other = total – terms`.

I jeszcze jedno wyszukiwanie facetowe:

    :::bash
    curl -s 'localhost:9200/tweets/_search?pretty' -d '
    {
      "query": { "query_string": {"query": "redis"} },
      "sort": { "created_at": { "order": "desc" } },
      "facets": { "hashtags": { "terms":  { "field": "hashtags", size: 4 }, "global": true } }
    }'

A teraz zupełnie inny facet,
[date histogram facet](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-facets-date-histogram-facet.html):

    :::bash
    curl -s 'localhost:9200/tweets/_search?pretty' -d '
    {
      "query": { "match_all": {} },
      "sort": { "created_at": { "order": "desc" } },
      "facets": {
         "statuses_per_day": {
            "date_histogram":  { "field": "created_at", "interval": "30m" }
         }
      }
    }'

Oto wynik wyszukiwania z *date histogram*:

    :::json
    "facets" : {
      "statuses_per_day" : {
        "_type" : "date_histogram",
        "entries" : [
          { "time" : 1384497000000, "count" : 45 },
          { "time" : 1384498800000, "count" : 81 },
          { "time" : 1384500600000, "count" : 98 },
          { "time" : 1384502400000, "count" : 95 },
          { "time" : 1384504200000, "count" : 95 },
          ...
        ]
      }
    }

Co to są za liczby przy *time*:

    :::js
    new Date(1332201600000);                  // Tue, 20 Mar 2012 00:00:00 GMT
    new Date(1332288000000);                  // Wed, 21 Mar 2012 00:00:00 GMT
    (new Date(1332288000000)).getFullYear();  // 2012

-->

<!--

# Rivers allows to index streams

Instalacja wtyczek *rivers* jest prosta:

    bin/plugin -install river-couchdb
      -> Installing river-couchdb...
      Trying ...
    bin/plugin -install river-wikipedia
      -> Installing river-wikipedia...
      Trying ...

Repozytoria z kodem wtyczek są na Githubie [tutaj](https://github.com/elasticsearch).

MongoDB River Plugin for ElasticSearch:

* [elasticsearch-river-mongodb](https://github.com/richardwilly98/elasticsearch-river-mongodb)


### Zadania

1\. Zainstalować wtyczkę *Wikipedia River*. Wyszukiwanie?

2\. Przeczytać [Creating a pluggable REST endpoint](http://www.elasticsearch.org/tutorials/2011/09/14/creating-pluggable-rest-endpoints.html).

5\. [Filename search with ElasticSearch](http://stackoverflow.com/questions/9421358/filename-search-with-elasticsearch).


# JSON dump indeksu tweets

…czyli zrzut indeksu tweets do pliku w formacie JSON:

* [scroll](http://www.elasticsearch.org/guide/reference/api/search/scroll.html)
* [scan](http://www.elasticsearch.org/guide/reference/api/search/search-type.html)

Ściąga:

* a search request can be scrolled by specifying the *scroll* parameter;
  `scroll=4m` indicates for how long (*co to oznacza? 4 minuty czy 4 milisekundy*)
  the nodes that participate in the search will maintain relevant resources
  in order to continue and support it
* the *scroll_id* should be used when scrolling
  (along with the scroll parameter, to stop the scroll from expiring);
  the *scroll_id* **changes for each scroll request**
  and only the most recent one should be used
* the “breaking” condition out of a scroll is when no hits has been returned;
  the *hits.total* will be maintained between scroll requests

Przykład pokazujący jak to działa:

    :::bash
    curl -s 'localhost:9200/tweets/_search?search_type=scan&scroll=10m&size=4&pretty'

Opcjonalnie możemy dopisać kryteria wyszukiwania. Na przykład,
wyszukujemy wszystko:

    :::json
    {
       "query": {
         "match_all": {}
       }
    }

albo cokolwiek:

    :::json
    {
       "query": {
          "query_string": {
             "query": "cokolwiek"
          }
       }
    }

Wtedy zmieniamy wywołanie *curl* na:

    :::bash
    curl -s 'localhost:9200/tweets/_search?search_type=scan&scroll=10m&size=4&pretty' -d '
    {
       "query": {
         "match_all": {}
       }
    }'

Wynik wykonania tego polecenia, to przykładowo:

    :::json
    {
      "_scroll_id": "c2NhbjsxOzE6Q29xZ01qdkJTZHVRdTA1Ow=",
      "took": 10,
      "timed_out": false,
      "_shards": {
        "total": 1,
        "successful": 1,
        "failed": 0
      },
      "hits": {
        "total": 105,
        "max_score": 0.0,
        "hits": [ ]
      }
    }

Teraz wykonujemy tyle razy polecenie:

    :::bash
    curl -s 'localhost:9200/_search/scroll?scroll=10m&pretty' \
      -d 'przeklikujemy ostatnią wersję _scroll_id'

aż otrzymamy pustą tablicę *hits.hits*:

    :::json
    {
      "_scroll_id": "c2lZ1UTsxO3RvdGFsX2hpdHM6MTM5Ow=",
      "took": 128,
      "timed_out": false,
      "_shards": {
        "total": 1,
        "successful": 1,
        "failed": 0
      },
      "hits": {
        "total": 2024,
        "max_score": 0.0,
        "hits": [ ]
        ...

Przykładowa implementacja tego algorytmu w NodeJS (v0.10.22)
+ moduł [Restler](https://github.com/danwrong/restler) (v2.0.1):

    :::js dump-tweets.js
    var rest = require('restler');

    var iterate = function(data) {  // funkcja rekurencyjna
      rest.get('http://localhost:9200/_search/scroll?scroll=10m', { data: data._scroll_id } )
        .on('success', function(data, response) {
          if (data.hits.hits.length != 0) {
            data.hits.hits.forEach(function(tweet) {
              console.log(JSON.stringify(tweet)); // wypisz JSONa w jednym wierszu
            });
            iterate(data);
          };
        });
    };

    rest.get('http://localhost:9200/tweets/_search?search_type=scan&scroll=10m&size=32')
      .on('success', function(data, response) {
        iterate(data);
    });

Skrypt ten uruchamiamy tak:

    :::bash
    node dump-tweets.js

**Uwaga 1:** Moduł ma „buga“. Przed uruchomieniem skryptu należy
załatać plik *restler.js*. Łata jest w katalogu
*pp/elasticsearch/dump* z repozytorium z notatkami do wykładu.

**Uwaga 2:** Korzystając z tego skryptu, możemy łatwo przenieść
dane z Elasticsearch do MongoDB:

    :::bash
    node dump-tweets.js | mongoimport --upsert -d test -c tweets --type json

-->

# Krótka ściąga z obiektu Date

Inicjalizacja:

    :::javascript
    new Date();
    new Date(milliseconds);
    new Date(dateString);
    new Date(year, month, day, hours, minutes, seconds, milliseconds);
    // parsing
    ms = Date.parse('2011-01-31T12:00:00.016');
    new Date(ms); // Mon, 31 Jan 2011 12:00:00 GMT

Metody:

    :::js
    d = new Date(1332288000000);
    d.getTime();         // 1332288000000
    d.getFullYear();     // 2011
    d.getMonth();        //    0    (0-11)
    d.getDate();         //   31    zwraca dzień miesiąca!
    d.getHours();
    d.getMinutes();
    d.getSeconds();
    d.getMilliseconds();

Konwersja na napis:

    d.toString();        // 'Mon Jan 31 2011 01:00:00 GMT+0100 (CET)'
    d.toLocaleString();  // 'Wed Mar 21 2012 01:00:00 GMT+0100 (CET)'
    d.toGMTString();     // 'Wed, 21 Mar 2012 00:00:00 GMT'

Zobacz też [Epoch & Unix Timestamp Conversion Tools](http://www.epochconverter.com/).
