#### {% title "Tworzymy kolekcje MongoDB" %}

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
    # fsync before returning, or wait for journal commit if running with --journal
    db.getLastError({ fsync:true })
    db.nosql.find({}, {_id: 0, text: 1}).limit(8)


## Baza z pliku CSV

CSV, *Comma Separated Values* –  wartości rozdzielone przecinkami,
to format przechowywania danych. Zawartość takiego pliku łatwo
jest przenieść do MongoDB.

W pliku {%= link_to 'goog.csv', '/doc/data/goog.csv' %} są dane
akcji GOOG:

    :::csv
    Date,Open,High,Low,Close,Volume,Adj Close
    2010-05-05,500.98,515.72,500.47,509.76,4566900,509.76
    2010-05-04,526.52,526.74,504.21,506.37,6076300,506.37
    ... + 1435 wierszy ...
    2004-08-19,100.00,104.06,95.96,100.34,22351900,100.34

Umieścimy te dane w bazie *stock* w kolekcji *goog* za pomocą
programu *mongoimport*:

    mongoimport --db stock --collection goog --type csv --file goog.csv --headerline

Wadą tego rozwiązania jest to daty zostają zapisane
jako napisy. Dlaczego to jest wada?

Napis na datę zamienimy korzystając z prostego skryptu:

    :::javascript goog_fix_Date.js
    var cursor = db.goog.find( {$query: {}, $snapshot: true} )
    while (cursor.hasNext()) {
      var doc = cursor.next();
      var ms = Date.parse(ISODate(doc.Date));
      doc.Date = new Date(ms);
      db.goog.save(doc);
    }

Po uruchomieniu tego skryptu w powłoce *mongo*:

    mongo goog_fix_Date.js

zapytania z datą powinny zwracać poprawne odpowiedzi:

    :::javascript
    start = new Date(2008, 1, 31)
    db.goog.find({Date: {$gt: start}}).sort({Date: 1})


### Korzystamy z gemu *mongo*

Zamiast poprawiać dane w bazie, możemy od razu umieścić je
w poprawnym formacie w bazie:

    :::ruby csv2mongo.rb
    require 'csv'
    require 'mongo'
    require 'time'

    quotes  = CSV.read "goog.csv"

    # Date,Open,High,Low,Close,Volume,Adj Close
    # 2010-05-05,500.98,515.72,500.47,509.76,4566900,509.76

    header = quotes.shift
    h = header.map &:downcase

    coll = Mongo::Connection.new("localhost", 27017).db("stock").collection("goog")

    quotes.each do |row|
      d = Time.utc *row.shift.split("-").map(&:to_i)  # na razie, zamiast Date, musi być UTC Time
      r = row.map &:to_f                              # skonwertuj strings na floats
      r.unshift d
      doc = Hash[ [h, r].transpose ]
      coll.insert doc
    end
