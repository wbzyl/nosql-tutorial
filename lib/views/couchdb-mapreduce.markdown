#### {% title "Map ⇒ Reduce → Rereduce" %}

Nieco DOC z Mongo:

* [Translate SQL to MongoDB MapReduce](http://nosql.mypopescu.com/post/392418792/translate-sql-to-mongodb-mapreduce)
* [NoSQL Data Modeling](http://nosql.mypopescu.com/post/451094148/nosql-data-modeling)
* [MongoDB Tutorial: MapReduce](http://nosql.mypopescu.com/post/394779847/mongodb-tutorial-mapreduce)

CouchDB stuff:

* [Interactive CouchDB](http://labs.mudynamics.com/wp-content/uploads/2009/04/icouch.html)
* [Introduction to CouchDB Views](http://wiki.apache.org/couchdb/Introduction_to_CouchDB_views)


## Design documents & MapReduce

W bazie zapiszemy dokumenty z info o fotografiach:

    ::json pictures.json
    [
      {"_id":"1","name":"fish.jpg","created_at":"Fri, 31 Dec 2010 14:50:03 GMT",
       "user":"bob","type":"jpeg","camera":"nikon",
       "info":{"width":100,"height":200,"size":12345},"tags":["tuna","shark"]},
      {"_id":"2","name":"trees.jpg","created_at":"Fri, 31 Dec 2010 14:46:47 GMT",
       "user":"john","type":"jpeg","camera":"canon",
       "info":{"width":30,"height":250,"size":32091},"tags":["oak"]},
      {"_id":"3","name":"snow.png","created_at":"Fri, 31 Dec 2010 14:59:13 GMT",
       "user":"john","type":"png","camera":"canon",
       "info":{"width":64,"height":64,"size":1253},"tags":["tahoe","powder"]},
      {"_id":"4","name":"hawaii.png","created_at":"Fri, 31 Dec 2010 15:05:49 GMT",
       "user":"john","type":"png","camera":"nikon",
       "info":{"width":128,"height":64,"size":92834},"tags":["maui","tuna"]},
      {"_id":"5","name":"hawaii.gif","created_at":"Fri, 31 Dec 2010 15:09:55 GMT",
       "user":"bob","type":"gif","camera":"canon",
       "info":{"width":320,"height":128,"size":49287},"tags":["maui"]},
      {"_id":"6","name":"island.gif","created_at":"Fri, 31 Dec 2010 14:58:35 GMT",
       "user":"zztop","type":"gif","camera":"nikon",
       "info":{"width":640,"height":480,"size":50398},"tags":["maui"]}
    ]

Skrypt zapisujący dokumenty w bazie. Dokumenty zapiujemy hurtem:

    :::ruby pictures.rb
    require 'yajl'
    require 'couchrest'

    json = File.new('pictures.json', 'r')
    parser = Yajl::Parser.new
    list = parser.parse(json)

    db = CouchRest.database!("http://127.0.0.1:4000/pictures")

    db.bulk_save(list)
    db.documents

Link do [CouchDB Querying Options](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options).

Przykłady Map & Reduce:

    :::javascript
    function(doc) {
      emit(doc.user, 1);
    }
    function(keys, values, rereduce) {
      log(keys);
      log(values);
      sum(values);
    }

Unique cameras per user:

    :::javascript
    function(doc) {
      emit([doc.user, doc.camera], 1);
    }
    function(keys, values, rereduce) {
      sum(values);
    }
