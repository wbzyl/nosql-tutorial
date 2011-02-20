#### {% title "Bazy danych dla CouchDB" %}

Poniżej umieściłem opisy jak zapisać w CouchDB dane pobrane z internetu.

**TODO:** MongoDB ⇔ CouchDB ⇔ Redis


## Twitter Tracking & Ruby

Wymagania:

* Twitter – konto na *twitter.com*
* Ruby – gemy *yajl-ruby*, *couchrest*

W skrypcie pobierającym dane z Twittera,
{%= link_to 'read_stream_from_twitter.rb', '/db/couchdb/read_stream_from_twitter.rb' %},
użyto [Streaming API](http://dev.twitter.com/pages/streaming_api_methods).

Przykład użycia skryptu:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser | \
      ./read_stream_from_twitter.rb 4000 nosql"

i wpisujemy swoje hasło Twitterze.

Albo uruchamiamy skrypt tak:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K credentials | \
      ./read_stream_from_twitter.rb 4000 nosql"

gdzie plik *tracking* zawiera jeden wiersz zawierający oddzielone
przecinkami słowa poprzedzone tekstem `track=`, na przykład:

    track=html5,jquery,couchdb,mongodb,redis

Tym razem nasze dane program pobierze z pliku *credentials*, który
powinien zawierać jeden wiersz w formacie:

    user = User:Password

Skrypt dodaje pole *_id* i ustawia jego wartość na *id_str*.
Następnie usuwa z pobranych dokumentów pola: *id_str*, *id*,
oraz dodaje pole *created_on* zawierające datę w formacie:

    :::ruby
    "#{date.year}-#{date.month}-#{date.day}-#{date.hour}-#{date.minute}-#{date.second}"

Przykładowy dokument po zamianie na hasz:

    :::ruby
    {:contributors=>nil,
     :user=>
      {:listed_count=>14,
       :contributors_enabled=>false,
       :verified=>false,
       :profile_sidebar_border_color=>"9b9d9e",
       :notifications=>nil,
       :profile_use_background_image=>true,
       :favourites_count=>0,
       :created_at=>"Sat Mar 21 15:25:20 +0000 2009",
       :friends_count=>429,
       :profile_background_color=>"8f8b8f",
       :location=>"Washington, DC",
       :profile_background_image_url=>
        "http://a1.twimg.com/profile_background_images/163929800/architecture-washington-dc-metro2.jpg",
       :followers_count=>342,
       :profile_image_url=>
        "http://a2.twimg.com/profile_images/1237694976/td_painting3_normal.png",
       :description=>
        "Graphic designer, artist, voice of a cartoon character, musically obsessed.",
       :show_all_inline_media=>false,
       :geo_enabled=>false,
       :time_zone=>"Eastern Time (US & Canada)",
       :profile_text_color=>"1e1d1f",
       :screen_name=>"rtisticgirlDC",
       :follow_request_sent=>nil,
       :statuses_count=>4365,
       :profile_sidebar_fill_color=>"cbcecf",
       :protected=>false,
       :url=>nil,
       :id_str=>"25685218",
       :is_translator=>false,
       :profile_background_tile=>false,
       :name=>"rtisticgirlDC",
       :lang=>"en",
       :id=>25685218,
       :following=>nil,
       :utc_offset=>-18000,
       :profile_link_color=>"cc0052"},
     :retweeted=>false,
     :in_reply_to_user_id_str=>nil,
     :geo=>nil,
     :in_reply_to_status_id=>nil,
     :text=>
      "i'm a graphic designer damn it! *cries in a corner under a pile of #jquery & #css*",
     :created_at=>"Tue Feb 15 20:12:41 +0000 2011",
     :source=>
      "<a href=\"http://www.hootsuite.com\" rel=\"nofollow\">HootSuite</a>",
     :in_reply_to_user_id=>nil,
     :truncated=>false,
     :entities=>
      {:user_mentions=>[],
       :urls=>[],
       :hashtags=>
        [{:indices=>[67, 74], :text=>"jquery"},
         {:indices=>[77, 81], :text=>"css"}]},
     :coordinates=>nil,
     :place=>nil,
     :favorited=>false,
     :id_str=>"37605234549194752",
     :retweet_count=>0,
     :in_reply_to_screen_name=>nil,
     :id=>37605234549194752,
     :in_reply_to_status_id_str=>nil}


## TODO: Word Count

* {%= link_to 'gutenberg-couchdb.rb', '/couch/word-count/gutenberg-couchdb.rb' %}
* zapełniamy bazę akapitami z książek A. C. Doyla
* instalujemy gem [couch_docs](https://github.com/eee-c/couch_docs)
* wykonujemy *rake*
