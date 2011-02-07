#### {% title "JSON" %}

Dane w formacie JSON do przykładów poniżej pobierzemy z Twittera.

Więcej info o Twitter API jest na stronie [API Documentation](http://dev.twitter.com/doc).

Pierwszy *tweet*:

    http://twitter.com/#!/jack/status/20

Dane w formacie JSON, przed umieszczeniem w bazie, będziemy przekształcać
za pomocą:

* [yajl-ruby](https://github.com/brianmario/yajl-ruby)
* [yajl-js](https://bitbucket.org/nikhilm/yajl-js/)

Gem *twitter* też może być przydatny:

* [twitter](https://github.com/jnunemaker/twitter)

Instalujemy też gem *cheat*:

    gem install cheat

Udostępnia od wiele ściągawek, np:

    cheat mongo

**TODO:** przygotować ściągawkę z CouchDB.


## JSON & CouchDB & Ruby

Najpierw pobieramy trochę przykładowych danych:

    :::shell-unix-generic
    curl 'http://search.twitter.com/search.json?q=@CouchDB&lang=en&page=1&rpp=100' > couchdb.json

Następnie instalujemy gem *yajl-ruby*:

    gem install yajl-ruby

A teraz przykład pokazujący jak przekonwertować pobrany JSON na hasz:

    :::ruby couchdb_bulk_save.rb
    require 'yajl'
    require 'pp'
    
    json = File.new('couchdb.json', 'r')
    parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)
    hash = parser.parse(json)
    puts hash
 
Na wyjściu dostajemy coś takiego:

    :::ruby
    {:results=>
      [{:from_user_id_str=>"1693850",
        :profile_image_url=>
         "http://a1.twimg.com/profile_images/1228537260/upg_normal.jpg",
        :created_at=>"Fri, 04 Feb 2011 16:57:36 +0000",
        :from_user=>"JUNOSRob",
        :id_str=>"33569874684940289",
        :metadata=>{:result_type=>"recent"},
        :to_user_id=>nil,
        :text=>
         "Really busy today but hope to dig into @couchapp 0.7.4 and @couchdb 1.0.2. Silly day job getting in the way.",
        :id=>33569874684940289,
        :from_user_id=>1693850,
        :geo=>nil,
        :iso_language_code=>"en",
        :to_user_id_str=>nil,
        :source=>
         "&lt;a href=&quot;http://www.tweetdeck.com&quot; rel=&quot;nofollow&quot;&gt;TweetDeck&lt;/a&gt;"},
       {:from_user_id_str=>"165720838",
        ...
        ...
        :source=>
         "&lt;a href=&quot;http://paper.li&quot; rel=&quot;nofollow&quot;&gt;Paper.li&lt;/a&gt;"}],
     :max_id=>33570476651454464,
     :since_id=>31048861086650368,
     :refresh_url=>"?since_id=33570476651454464&q=%40CouchDB",
     :next_page=>"?page=2&max_id=33570476651454464&rpp=2&lang=en&q=%40CouchDB",
     :results_per_page=>2,
     :page=>1,
     :completed_in=>0.069827,
     :since_id_str=>"31048861086650368",
     :max_id_str=>"33570476651454464",
     :query=>"%40CouchDB"}

Jeśli teraz zamienimy w haszu klucz **:results** na klucz **:docs**
i zamienimy z powrotem hasz na obiekt JSON, to będzie można
go umieścić w bazie CouchDB, korzystając z *bulk_save*:

    :::ruby couchdb_bulk_save.rb
    json = File.new('couchdb.json', 'r')
    parser = Yajl::Parser.new(:pretty => true)
    hash = parser.parse(json)
    hash_couchdb = {}
    hash_couchdb[:docs] = hash[:results]
    puts Yajl::Encoder.encode(hash_couchdb)

Jeśli zapiszemy przekonwerowane na JSON dane w pliku *1.json*:

    :::shell-unix-generic
    ruby couchdb_bulk_save.rb > 1.json

to, po utworzeniu bazy *twitter*, możemy je umieścić w bazie
wykonując na konsoli:

    curl -X POST -H "Content-Type: application/json" --data @1.json http://127.0.0.1:4000/twitter/_bulk_docs

Bardziej eleganckie rozwiązanie: 
{%= link_to "from_twitter_to_couchdb_bulk_save.rb", "/ruby/json/from_twitter_to_couchdb_bulk_save.rb" %}.


## JSON & MongoDB & Ruby

Najpierw pobieramy trochę przykładowych danych:

    :::shell-unix-generic
    curl 'http://search.twitter.com/search.json?q=@mongodb&lang=en&page=1&rpp=100' > monogdb.json

MongoDB wystarczy tablica jsonów:

    :::ruby mongodb_bulk_save.rb
    require 'yajl'

    json = File.new('mongodb.json', 'r')
    parser = Yajl::Parser.new(:pretty => true, :symbolize_keys => true)
    hash = parser.parse(json)

    puts Yajl::Encoder.encode(hash[:results])

Przekonwerowane dane możemy umieścić w bazie *twitter* w kolekcji
*couchdb* wykonując na konsoli polecenie:

    :::shell-unix-generic
    ruby mongodb_bulk_insert.rb | mongoimport --port 9000 --db twitter --collection mongo --jsonArray

Sprawdzamy na konsoli:

    mongo.sh shell 9000 twitter
    > show dbs
    > show collections
    > db.mongo.find().limit(2)
    > db.mongo.find({},{"text":1}).limit(4)
    > db.mongo.drop()
    > db.dropDatabase()

Instalujemy gem [mongo](http://api.mongodb.org/ruby/current/file.TUTORIAL.html) (tutorial)
oraz *bson_ext*:

    gem install mongo bson_ext
    
i piszemy „bardziej eleganckie rozwiązanie”: 
{%= link_to "from_twitter_to_mongodb_bulk_insert.rb", "/ruby/json/from_twitter_to_mongodb_bulk_insert.rb" %}.


### Twitter streaming API

Przykład z *tracking*:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser:Password | \
      mongoimport --port 9000 --db twitter --collection nosql

gdzie plik *tracking* zawiera jedną linię w formacie:

    track=couchdb,mongodb,redis,nosql,nodejs,html5,jquery

Albo wpisujemy „credentials” do pliku np. *twitter.conf*:

    user = wbzyl:sekret

i wywołujemy program *curl* tak:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K twitter.conf | \
      mongoimport --port 9000 --db twitter --collection nosql

Sprawdzamy co się zaimportowało na konsoli:

    db.nosql.find({text:/mongo/},{text:1}).limit(8)

Aby zapisać dane ze strumienia do CouchDB można skorzystać z *mongoexport*. 

Ale lepszym rozwiązaniem jest 
{%= link_to "save_jsons_stream_to_couchdb.rb", "/ruby/json/save_jsons_stream_to_couchdb.rb" %}, 
gdzie troszkę podrasowujemy JSON-y zanim zapiszemy je w bazie: 

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K twitter.conf |
      ruby save_jsons_stream_to_couchdb.rb nosql


## NodeJS

TODO:

* [Tweetstream in NodeJS](https://github.com/mikeal/tweetstream/blob/master/test/osb.js)
