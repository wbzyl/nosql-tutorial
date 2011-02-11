{% title "Dostęp do CouchDB via Ruby" %}

Praca z powłoką jest męcząca i niewygodna. Ruby z biblioteką
CouchRest, klient REST dla CouchDB, powinien to zmienić.

Linki źródła i dokumentacji:

* źródła gemu [couchrest](http://github.com/couchrest/couchrest) –
  a RESTful CouchDB client based on Heroku's RestClient and *couch.js*
* dokumentacja na [rdoc.info](http://rdoc.info/projects/couchrest/couchrest)
* linki do RestClient też mogą być przydatne:
  [rest-client](http://github.com/archiloque/rest-client) –
  A simple HTTP and REST client for Ruby, inspired by the Sinatra’s
  microframework style of specifying actions: get, put, post, delete;
  [rdoc.info](http://rdoc.info/projects/archiloque/rest-client)
* będziemy też potrebować biblioteki dla JSON, na przykład
  [yajl-ruby](https://github.com/brianmario/yajl-ruby).


## CouchRest

Zaczynamy od instalacji gemów:

    gem install couchrest yajl-ruby

Kilka eksperymentów na konsoli.


### *CouchRest::Database*

Tworzymy bazę tak:

    :::ruby
    require 'couchrest'
    db = CouchRest.database "http://localhost:4000/cr"
    db.create!

albo tak:

    :::ruby
    db = CouchRest.database!("http://localhost:4000/cr")

powyżej jeśli baza już istnieje to polecenie to nic nie robi.

Info o bazie:

    :::ruby
    db.host ; db.name ; db.root ; db.uri

A tak usuwamy i tworzymy na nowo bazę:

    :::ruby
    db.recreate!

a tak usuwamy bazę:

    :::ruby
    db.delete!

### Dokumenty

Dodajemy dokument do bazy:

    :::ruby
    db = CouchRest.database!("http://localhost:4000/cr")

    attr = {"imie" => "Włodzimierz", "login" => "matwb"}
    result = db.save_doc(attr)

    p result.class
    p result.inspect

Pobierz dokument z bazy i dodaj kilka atrybutów

    :::ruby
    doc = db.get(result['id'])
    p doc.class
    p doc.inspect

Dodajemy kilka atrybutów do dokumentu:

    :::ruby
    doc['nazwisko'] = 'Bzyl'
    doc['email'] = 'matwb@ug.edu.pl'

Zapisz nową wersję w bazie – nie musimy podawać rev !

    result = db.save_doc(doc)
    p result.class
    p result.inspect

Uwaga: tym razem argumentem jest *doc* zamiast hasza *attr*.

Na koniec usuwamy dokument z bazy i samą bazę:

    :::ruby
    doc = db.get(result['id']) # pobieramy _id i nową _rev
    db.delete_doc(doc)
    db.delete!


### *Bulk save*, czyli zapisywanie hurtem

Zapisywanie **hurtem**, czyli w dużej liczbie i razem, dokumentów w bazie:

    :::ruby
    db = CouchRest.database!("http://localhost:4000/cr")

    db.bulk_save([
      {"_id" => "chrobry",
       "imie" => "Bolesław", "nazwisko" => "Chrobry",
       "email" => "bchrobry@piast.pl"},
      {"_id" => "jagiello",
       "imie" => "Władysław", "nazwisko" => "Jagiełło",
       "email" => "wjagiello@piast.pl"}
    ])
    db.documents


### Załączniki

Dokument z załącznikiem wygląda mniej więcej tak:

    :::json
    {
       "_id": "led-zeppelin-i",
       "title": "Led Zeppelin I"
       "_attachments": {
           "index.html": {
               "content_type": "text/html",
               "revpos": 9,
               "length": 152,
               "stub": true
           },
           "robert_plant.jpg": {
               "content_type": "image/jpg",
               "revpos": 8,
               "length": 30536,
               "stub": true
           }
       }
    }

Umieszczamy go w bazie:

    :::ruby
    db = CouchRest.database "http://localhost:4000/lza"
    db.recreate!

    attr = { "_id" => "led-zeppelin-i", "title" => "Led Zeppelin I" }
    attr['_attachments'] ||= {}
    attr['_attachments']['index.html'] = {
      'content_type' => 'text/html',
      'data' => File.read('index.html')
    }
    attr['_attachments']['cover.jpg'] = {
      'content_type' => 'image/jpg',
      'data' => File.read('led-zeppelin-i.jpg')
    }
    db.save_doc(attr)

Ale wygodniej jest skorzystać z metody *put_attachment*:

    :::ruby
    doc = db.get('led-zeppelin-i')
    #                 doc,  name,       file,                          options = {}
    db.put_attachment(doc, 'plant.jpg', File.read('robert_plant.jpg'), :content_type => :jpeg)

Ale teraz dokument zapisujemy w dwóch etapach: najpier dane JSON,
a następnie załączniki.


# Przykłady

Kilka przykładów…


## Word count

TODO: Omówić przykład z katalogu *couch/word-count*.


## Sinatra & Couchrest

* [A basic CouchDB/Sinatra wiki](http://github.com/benatkin/weaky)


## *View collation* – przykład z *rest-client*

Przykład pochodzi [CouchDB Wiki](http://wiki.apache.org/couchdb/View_collation).

Instalujemy gemy:

    gem install rest-client json

Następnie za pomocą poniższego skryptu tworzymy bazę *collator* (ruby 1.9.2):

    :::ruby collseq.rb
    require 'restclient'
    require 'json'

    DB="http://127.0.0.1:4000/collator"
    RestClient.delete DB rescue nil
    RestClient.put "#{DB}",""
    (32..126).each do |c|
      RestClient.put "#{DB}/#{c.to_s(16)}", {"x"=>c.chr}.to_json
    end

    RestClient.put "#{DB}/_design/test", <<EOS
    {
      "views":{
        "one":{
          "map":"function (doc) { emit(doc.x,null); }"
        }
      }
    }
    EOS
    puts RestClient.get("#{DB}/_design/test/_view/one")

Kilka zapytań do bazy:

    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&limit=4
    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&limit=2\&descending=true
    curl -X GET http://localhost:4000/collator/_all_docs?startkey=\"64\"\&endkey=\"68\"

(W przeglądarce powyższe URL-e wpisujemy bez „cytowania“.)

Dokumentacja [rest-client](https://github.com/archiloque/rest-client) + konsola Rubiego.

    :::ruby
    DB = "http://localhost:4000/lz"
    RestClient.get DB
    response = RestClient.get "#{DB}/led-zeppelin-i"
    response.code
    response.headers
    response.cookies
