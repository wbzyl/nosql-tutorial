#### {% title "ElasticSearch" %}

<blockquote>
 {%= image_tag "/images/john_cage.jpg", :alt => "[John Cage]" %}
 <p>I can't understand why people are frightened of new ideas. 
    I'm frightened of the old ones.
 </p>
 <p class="author">— John Cage (1912–1992)</p>
</blockquote>

* [You know, for Search](http://www.elasticsearch.org/)
* [CouchDB Integration](https://github.com/elasticsearch/elasticsearch/wiki/Couchdb-integration)


## Pierwsze koty za płoty

Rozpakowujemy archiwum z ostatnią wersją *elasticsearch*:

    unzip elasticsearch-0.14.4.zip

Instalujemy wtyczkę *river-couchdb*:

    cd elasticsearch-0.14.3
    bin/plugin -install river-couchdb

Uruchamiamy *elasticsearch* (korzystamy z domyślnych ustawień – *localhost:9200*):

    bin/elasticsearch -f

Następnie podłączamy *elasticsearch* do *change notification* dla bazy
*nosql* umieszczonej na działającym serwerze CouchDB –
*http://localhost:4000/nosql/_changes*:

    curl -XPUT 'http://localhost:9200/_river/statuses_internal/_meta' -d @nosql_timeline.json

gdzie plik *nosql_timeline.json* zawiera:

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
            "index" : "statuses",
            "type" : "nosql_timeline"
        }
    }

Wyszukiwanie, odpytujemy *elasticsearch*:

    curl -XGET 'http://localhost:9200/statuses/nosql_timeline/_search?q=text:jquery&pretty=true'
    curl -XGET 'http://localhost:9200/statuses/nosql_timeline/_search?q=user.name:Kozora&pretty=true'

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
