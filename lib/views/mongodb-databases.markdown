#### {% title "Bazy danych dla MongoDB" %}

Poniżej umieściłem opisy jak zapisać w MongoDB dane pobrane z internetu.

**TODO:** MongoDB ⇔ CouchDB ⇔ Redis


## TODO:  Twitter Tracking & Ruby

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

Inne rozwiązanie zaimplementowałem tutaj:
{%= link_to "save_jsons_stream_to_couchdb.rb", "/ruby/json/save_jsons_stream_to_couchdb.rb" %}.
Przed zapisaniem w bazie danych z Twittera, zmieniamy troszkę oryginalne JSON-y:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K twitter.conf |
      ruby save_jsons_stream_to_couchdb.rb nosql
