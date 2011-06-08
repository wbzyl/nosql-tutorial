#### {% title "ElasticSearch – odjazdowy „sweet spot”" %}

<blockquote>
 {%= image_tag "/images/john_cage.jpg", :alt => "[John Cage]" %}
 <p>I can't understand why people are frightened of new ideas.
    I'm frightened of the old ones.
 </p>
 <p class="author">— John Cage (1912–1992)</p>
</blockquote>

* [You know, for Search](http://www.elasticsearch.org/)
* [Elasticsearch Guide](http://www.elasticsearch.org/guide/): Setup, API, Query, Mapping…
* [Searchable CouchDB](http://www.elasticsearch.com/blog/2010/09/28/the_river_searchable_couchdb.html)
* [CouchDB River](http://www.elasticsearch.org/guide/reference/river/couchdb.html)
* [Data Visualization with ElasticSearch and Protovis](http://www.elasticsearch.org/blog/2011/05/13/data-visualization-with-elasticsearch-and-protovis.html)
* [Tire](https://github.com/karmi/tire) – a rich Ruby API and DSL for the ElasticSearch search engine/database
* [Your Data, Your Search, ElasticSearch](http://www.slideshare.net/karmi/your-data-your-search-elasticsearch-euruko-2011) (Euruko 2011),
([Template for generating a no-frills Rails application with support for ElasticSearch full-text search via the Tire gem](https://gist.github.com/951343))

## Instalacja

Rozpakowujemy archiwum z ostatnią wersją *elasticsearch*:

    unzip elasticsearch-0.16.1.zip

Instalujemy wtyczkę *river-couchdb:*

    cd elasticsearch-0.16.1
    bin/plugin -install river-couchdb

Uruchamiamy *elasticsearch* (korzystamy z domyślnych ustawień – *localhost:9200*):

    bin/elasticsearch -f


## Podłączamy Elasticsearch do CouchDB

Następnie podłączamy *elasticsearch* do *change notification* CouchDB dla bazy
*nosql* umieszczonej na działającym serwerze CouchDB –
*http://localhost:5984/nosql/_changes*:

    curl -XPUT 'http://localhost:9200/_river/statuses_internal/_meta' -d @couchdb_nosql.json
    {"ok":true,"_index":"_river","_type":"statuses_internal","_id":"_meta","_version":1}

gdzie powyżej użyto pliku z następującą zawartością:

    :::json couchdb_nosql.json
    {
        "type" : "couchdb",
        "couchdb" : {
            "host" : "localhost",
            "port" : 5984,
            "db" : "nosql",
            "filter" : null
        },
        "index" : {
            "index" : "nosql_timeline",
            "type" : "twitter",
            "bulk_size" : "100",
            "bulk_timeout" : "10ms"
        }
    }

Składnia zapytań:

<pre>http://localhost:9200/<b> index </b>/<b> type </b>/_search?...
</pre>


## Wyszukiwanie – pierwsze koty za płoty

Odpytujemy *elasticsearch*:

    curl -XGET 'http://localhost:9200/nosql_timeline/twitter/_search?q=text:jquery&pretty=true'
    curl -XGET 'http://localhost:9200/nosql_timeline/twitter/_search?q=user.name:Darcy&pretty=true'

Ale tak, jest dużo lepiej:

    curl -XGET 'http://localhost:9200/nosql_timeline/twitter/_search?q=text:redis&fields=user.name,text&pretty=true'
    curl -XGET 'http://localhost:9200/nosql_timeline/twitter/_search?q=text:redis&fields=user.name,text,retweet_count&pretty=true'

<blockquote>
 {%= image_tag "/images/elasticsearch.png", :alt => "[Elasticsearch]" %}
</blockquote>

Szukamy w polu *text*. W tym polu Twitter zapisuje to co wpisał w tweet
użytkownik. Oto przykładowy tweet, po konwersji na Ruby hasz,
przed umieszczeniem w bazie *nosql*:

    :::ruby
    {:_id=>"34374127649296384",
     :_rev=>"1-8d9399d71067563285793e6d6bccbf67",
     :user=>
      {:profile_link_color=>"0000ff",
       :listed_count=>1,
       :profile_sidebar_border_color=>"87bc44",
       :followers_count=>39,
       :show_all_inline_media=>false,
       :geo_enabled=>false,
       :friends_count=>55,
       :statuses_count=>706,
       :profile_use_background_image=>false,
       :created_at=>"Thu May 01 19:45:24 +0000 2008",
       :location=>"",
       :profile_background_color=>"9ae4e8",
       :profile_background_image_url=>
        "http://a2.twimg.com/profile_background_images/2479026/2008-04-08_Smallmouth_4-08_2_Small.jpg",
       :description=>"",
       :contributors_enabled=>false,
       :favourites_count=>19,
       :verified=>false,
       :time_zone=>"Eastern Time (US & Canada)",
       :profile_text_color=>"000000",
       :protected=>false,
       :url=>nil,
       :profile_image_url=>
        "http://a1.twimg.com/profile_images/53621580/2008-04-08_Smallmouth_4-08_2_Small_normal.jpg",
       :follow_request_sent=>nil,
       :notifications=>nil,
       :profile_sidebar_fill_color=>"e0ff92",
       :name=>"Dennis Kozora",
       :id_str=>"14618654",
       :is_translator=>false,
       :lang=>"en",
       :profile_background_tile=>false,
       :screen_name=>"djkozora",
       :id=>14618654,
       :following=>nil,
       :utc_offset=>-18000},
     :coordinates=>nil,
     :retweet_count=>1,
     :truncated=>true,
     :text=>
      "RT @Codebetter: New Blog Post A thought on Hard vs Soft: \n
         With the move from RDBMS to NoSQL are we seeing the same shift that we... http ...",
     :favorited=>false,
     :created_at=>"Sun Feb 06 22:13:25 +0000 2011",
     :in_reply_to_user_id=>nil,
     :in_reply_to_status_id=>nil,
     :source=>
      "<a href=\"http://www.tweetdeck.com\" rel=\"nofollow\">TweetDeck</a>",
     :in_reply_to_screen_name=>nil,
     :in_reply_to_status_id_str=>nil,
     :entities=>
      {:hashtags=>[],
       :user_mentions=>
        [{:indices=>[3, 14],
          :name=>"Codebetter",
          :screen_name=>"Codebetter",
          :id_str=>"12686382",
          :id=>12686382}],
       :urls=>[]},
     :contributors=>nil,
     :place=>nil,
     :geo=>nil,
     :retweeted=>false,
     :in_reply_to_user_id_str=>nil,
     :retweeted_status=>
      {:user=>
        {:profile_link_color=>"0084B4",
         :listed_count=>540,
         :profile_sidebar_border_color=>"C0DEED",
         :followers_count=>5210,
         :show_all_inline_media=>false,
         :geo_enabled=>false,
         :friends_count=>2,
         :statuses_count=>1291,
         :profile_use_background_image=>true,
         :created_at=>"Fri Jan 25 15:38:16 +0000 2008",
         :location=>nil,
         :profile_background_color=>"C0DEED",
         :profile_background_image_url=>
          "http://a3.twimg.com/a/1296072137/images/themes/theme1/bg.png",
         :description=>nil,
         :contributors_enabled=>false,
         :favourites_count=>0,
         :verified=>false,
         :time_zone=>"Central Time (US & Canada)",
         :profile_text_color=>"333333",
         :protected=>false,
         :url=>nil,
         :profile_image_url=>
          "http://a1.twimg.com/profile_images/51507866/logo_normal.jpg",
         :follow_request_sent=>nil,
         :notifications=>nil,
         :profile_sidebar_fill_color=>"DDEEF6",
         :name=>"Codebetter",
         :id_str=>"12686382",
         :is_translator=>false,
         :lang=>"en",
         :profile_background_tile=>false,
         :screen_name=>"Codebetter",
         :id=>12686382,
         :following=>nil,
         :utc_offset=>-21600},
       :coordinates=>nil,
       :retweet_count=>1,
       :truncated=>false,
       :text=>
        "New Blog Post A thought on Hard vs Soft: \n
           With the move from RDBMS to NoSQL are we seeing the same shift that we... http://bit.ly/e0dilm",
       :favorited=>false,
       :created_at=>"Sun Feb 06 17:39:52 +0000 2011",
       :in_reply_to_user_id=>nil,
       :in_reply_to_status_id=>nil,
       :source=>
        "<a href=\"http://twitterfeed.com\" rel=\"nofollow\">twitterfeed</a>",
       :in_reply_to_screen_name=>nil,
       :in_reply_to_status_id_str=>nil,
       :entities=>
        {:hashtags=>[],
         :user_mentions=>[],
         :urls=>
          [{:indices=>[116, 136],
            :url=>"http://bit.ly/e0dilm",
            :expanded_url=>nil}]},
       :contributors=>nil,
       :place=>nil,
       :geo=>nil,
       :retweeted=>false,
       :in_reply_to_user_id_str=>nil,
       :id_str=>"34305287204638720",
       :id=>34305287204638720},
     :year=>2011,
     :month=>2,
     :day=>6,
     :hour=>22,
     :minute=>13,
     :second=>25}


## CouchDB _changes

[Changes API](http://wiki.apache.org/couchdb/HTTP_database_API#Changes):
A list of changes made to documents in the database, in the order they
were made, can be obtained from the database's *_changes* resource
via GET request:

* `since=seqnum` (*default=0*).
  Start the results from the change
  immediately after the given sequence number.
* `feed=normal|longpoll|continuous` (*default=normal*).
  Select the type of feed.
* `heartbeat=time` *(milliseconds, default=60000)*.
  Period in milliseconds after which a empty line is sent in the results.
  Only applicable for longpoll or continuous feeds. Overrides any timeout.
* `timeout=time` (*milliseconds, default=60000*).
  Maximum period in milliseconds to wait for a change before
  the response is sent, even if there are no results.
  Only applicable for longpoll or continuous feeds.
* `filter=designdoc/filtername`.
  Reference a filter function from a design document to selectively get updates.
  See the section in the book for more information.
* `include_docs=true|false` (*default=false*).
  Include the associated document with each result. (New in version 0.11)

By default all changes are immediately returned as a JSON object:

    curl -X GET http://localhost:5984/nazwa-bazy-danych/_changes

Zobacz też
[Database Information](http://wiki.apache.org/couchdb/HTTP_database_API#Database_Information):

    curl -X GET http://localhost:5984/nazwa-bazy-danych
    {
      "compact_running": false,
      "db_name": "dj",
      "disk_format_version": 5,
      "disk_size": 12377,
      "doc_count": 1,
      "doc_del_count": 1,
      "instance_start_time": "1267612389906234",
      "purge_seq": 0,
      "update_seq": 4
   }


# Linki

* Wyszukiwanie tekstowe z Lucene (starsze rozwiązanie):
  [Enables full-text searching of CouchDB documents using
  Lucene](http://github.com/rnewson/couchdb-lucene) plus opis na
  [wiki](http://wiki.github.com/couchrest/couchrest/couchdb-lucene-support)
* Karel Minarik, [slingshot](https://github.com/karmi/slingshot) –
  a rich Ruby API and DSL for the ElasticSearch search engine/database
* [Toast](http://github.com/jchris/toast), gałąź **chip**
