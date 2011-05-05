#### {% title "Bazy danych dla MongoDB" %}

Poniżej umieściłem opisy jak zapisać w MongoDB dane pobrane z CouchDB
i Twittera..

**TODO:** Dodać przykład z bazą Redis oraz skrypty dla: MongoDB ⇔ CouchDB ⇔ Redis


## Kopiowanie bazy z CouchDB do MongoDB

Korzystamy ze skryptu *couch2mongo.rb* (katalog *lib/x* w repozytorium):

    ruby couch2mongo.rb --help
    ruby couch2mongo.rb -p 5984 -o 27017 -d gutenberg -m test -c gutenberg

Uruchamiamy powłokę MongoDB i sprawdzamy co się skopiowało:

    :::javascript
    use test
    show collections
    db.gutenberg.find().skip(1024).limit(4)
    { "_id" : "60b5c8ce26b23f05912fd458e20e2166", "title" : "the idiot", "text" : "He had gone to the front door..." }
    db.gutenberg.stats()
    {
        "ns" : "test.gutenberg",
        "count" : 22513,
        "size" : 9778056,
        "avgObjSize" : 434.32932083684983,
        "storageSize" : 11449600,
        "numExtents" : 6,
        "nindexes" : 1,
        "lastExtentSize" : 5426176,
        "paddingFactor" : 1,
        "flags" : 1,
        "totalIndexSize" : 1589248,
        "indexSizes" : {
           "_id_" : 1589248
        },
        "ok" : 1
    }

Albo, prostsze rozwiązanie:

    :::ruby twitter2mongo.rb
    # -*- coding: utf-8 -*-
    require 'rubygems'
    require 'yajl/http_stream'
    require 'mongo'

    unless keyword = ARGV[0]
      puts "\nUsage: ruby #{$0} KEYWORD\n\n"
      exit(0)
    end

    # zakładamy domyślny port na którym jest uruchomiony server mongod
    db = Mongo::Connection.new("localhost", 27017).db("twitter")
    coll = db.collection(keyword)

    hash = Yajl::HttpStream.get("http://search.twitter.com/search.json?&lang=en&rpp=100&q=#{keyword}")

    # tablica ze statusami jest zapisana w hash["results"]
    # można się o tym przekonać wykonując polecenie:
    #   curl 'http://search.twitter.com/search.json?&rpp=2&q=mongo'
    # zapisujemy hurtem w kolekcji elementy tej tablicy
    coll.insert(hash["results"])

    puts "Liczba rekordów zapisanych w bazie 'twitter' w kolekcji '#{keyword}': #{coll.count()}"

Uruchamiamy skrypt:

    ruby twitter2mongo mongodb

Sprawdzamy na konsoli co ciekawego zaimportowaliśmy:

    use twitter
    db.mongodb.find( {}, {_id: 0, text: 1} )



## Korzystamy ze strumieniowego API Twittera

Większe ilości danych pobieramy z Twitera korzystając
ze strumieniowego API.

Oto przykład pokazujący jak to zrobić:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -uUser:Password | \
      mongoimport --port 27017 --db twitter --collection nosql

gdzie plik *tracking* zawiera jedną linię w formacie:

    track=couchdb,mongodb,redis,nosql,nodejs,html5,jquery

Albo wpisujemy swoje „credentials” do pliku np. *twitter.conf*:

    user = wbzyl:sekret

i wywołujemy program *curl* tak:

    curl -d @tracking http://stream.twitter.com/1/statuses/filter.json -K twitter.conf | \
      mongoimport --port 27017 --db twitter --collection nosql

Sprawdzamy co się zaimportowało na konsoli:

    :::javascript
    use nosql
    db.getLastError()  # flush records?
    db.nosql.find({}, {_id: 0, text: 1}).limit(8)
