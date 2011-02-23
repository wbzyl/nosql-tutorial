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

Kilka eksperymentów na konsoli języka Ruby.


### *CouchRest::Database*

Tworzymy bazę tak:

    :::ruby
    require 'couchrest'
    db = CouchRest.database("http://localhost:4000/cr")
    # db = CouchRest.database("http://User:Pass@localhost:4000/cr")
    db.create!

albo, krócej, tak:

    :::ruby
    db = CouchRest.database!("http://localhost:4000/cr")

Polecenie z *!* powyżej nic nie robi jeśli baza już istnieje.

Pobieranie info o bazie:

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
