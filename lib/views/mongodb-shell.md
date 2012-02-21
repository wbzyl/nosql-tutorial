#### {% title "MongoDB shell" %}

<blockquote>
 {%= image_tag "/images/mongo-tree.jpg", :alt => "[Mongo tree]" %}
 <p class="author">mongo tree (orzech czarny)</p>
</blockquote>

Zanim uruchomimy powłokę, musimy uruchomić serwer:

    mongo.sh server 27017
    mongo.sh shell 27017
      MongoDB shell version: 1.9.0
      connecting to: 127.0.0.1:27017/test
    >

Powyżej serwer nasłuchuje na domyślnym porcie 27017.
Oczywiście możemy wybrać inny port.

Połoka MongoDB jest interpreterem języka Javascript:

    > 2+2
    4
    > x = 1024
    1024
    > x/2
    512
    >

Możemy napisać funkcję i ją wykonać:

    > function factorial(n) {
    ... if (n <= 1) return 1;
    ... return n * factorial(n - 1);
    ... }
    >

(wielokropek `...` jest wypisywany przez powłokę)

    > factorial(10)
    3628800

Pomoc możemy uzyskać na kilka sposobów. Na początek
wpiszemy `help`:

    > help
	db.help()                    help on db methods
	db.mycoll.help()             help on collection methods
	rs.help()                    help on replica set methods
	help admin                   administrative help
	help connect                 connecting to a db help
	help keys                    key shortcuts
	help misc                    misc things to know
	help mr                      mapreduce

	show dbs                     show database names
	show collections             show collections in current database
	show users                   show users in current database
	show profile                 show most recent system.profile entries with time >= 1ms
	use <db_name>                set current database
	db.foo.find()                list objects in collection foo
	db.foo.find({ a : 1 })       list objects in foo where a == 1
	it                           result of the last line evaluated; use to further iterate
	DBQuery.shellBatchSize = x   set default number of items to display on shell
	exit                         quit the mongo shell

Na razie jesteśmy podłączeni do bazy *test*.
Oznacza to, że zmienna *db* wskazuje na bazę *test*.

Tak jak to jest wypisane powyżej do innej bazy się podłączamy tak:

    > use foo
    switched to db foo
    > db
    foo

Jaka jest różnica w wykonaniu poniższych dwóch poleceń:

    > db.getLastError()
    > db.getLastError


## Operacje CRUD

Uwaga: w przykładach poniżej pomijam znak zachęty `>`.

**Create:**

    :::javascript
    contact = { "name": "Burek", "email": "burasek@psy.pl", "dob": new Date(2000,0,31,1) }
    contact.name
    contact.dob
    contact.dob.valueOf()
    db.dogs.insert(contact)

*Uwaga:* Bez *1* w dacie funkcja *Date* wylicza błędnie daty (MongoDB, v1.9.0).

**Find:**

    :::javascript
    db.dogs.findOne()
    db.dogs.find()
    db.dogs.find( {name: "Burek"} )

**Update:**

    :::javascript
    contact.name = "Batman"
    delete contact.email
    contact.emails = ["burek@psy.pl", "batman@dogs.pl"]
    db.dog.update( {name: "Batman"}, contact )  // raczej replace

Do update korzystamy z tzw. *modifiers*:

    db.dogs.update( {name: "Batman"}, { $set: {favorite_language: "Ruby"} } )
    db.dogs.update( {name: "Batman"}, { $unset: {favorite_language: "Ruby"} } )
    db.dogs.update( {name: "Batman"}, { $addToSet: {emails: "janosik@psy.pl"} } )
    db.dogs.update( {name: "Batman"}, { $addToSet: {emails: "janosik@psy.pl"} } )  // jeszcze raz to samo

*Uwaga:* Tak wykonujemy *update*:

    :::javascript
    var x = db.dogs.findOne()
    x.name = "Janosik"
    db.dogs.update( { "_id": x._id }, x )

Ostatni wiersz możemy uprościć, korzystajac z funkcji pomocniczej *save*:

    db.dogs.save( x )

**Delete:**

    :::javascript
    db.dogs.remove( {name: "Batman"} )
    db.dogs.find()
    db.dogs.drop()


## Kolekcja *Animals*

Tworzymy przykładową kolekcję *animals*. W pliku *animals.json*
wpisujemy obiekty, **po jednym w wierszu**:

    :::javascript animals.json
    { "name": "Burek",    "email": "burasek@psy.pl",     "dob": { "$date": 949276800000  } }
    { "name": "Maksiu",   "email": "maxymilian@psy.pl",  "dob": { "$date": 949276800000  } }
    { "name": "Szef",     "email": "general@psy.pl",     "dob": { "$date": 1301439600000 } }
    { "name": "Cwaniak",  "email": "scooby@dogs.com",    "dob": { "$date": 1149548400000 } }
    { "name": "Bazylek",  "email": "bazyl@koty.pl",      "dob": { "$date": 1119567600000 } }
    { "name": "Benek",    "email": "benus@koty.pl",      "dob": { "$date": 1149548400000 } }
    { "name": "Behemoth", "email": "behemotek@cats.com", "dob": { "$date": 1220223600000 } }
    { "name": "Profesor", "email": "profi@cats.com",     "dob": { "$date": 1220223600000 } }

Importujemy JSON-y do bazy:

    mongoimport --host localhost --db test --collection animals --type json --file animals.json --

Sprawdzamy w powłoce co się zaimportowało:

    $ mongo.sh shell 27017
    db.animals.find()
    { "_id" : ObjectId("4dc2a101a558cc3ecba98584"), "name" : "Maksiu", "email" : "maxymilian@psy.pl", "dob" : ISODate("2000-01-31T00:00:00Z") }
    { "_id" : ObjectId("4dc2a3f4a558cc3ecba98588"), "name" : "Cwaniak", "email" : "scooby@dogs.com", "dob" : ISODate("2006-06-05T23:00:00Z") }
    ...
    db.animals.find({name: "Benek"})
    db.animals.find( {name: /^B/, email: /cats|koty/} )
    date = new Date(2005,0,1,1)
    db.animals.find( {dob: {$lt: date}} )

Jakieś uwagi? Link do dokumentacji [JSON](http://www.json.org/json-pl.html).

Jeszcze kilka przykładów z *find*:

    :::javascript
    db.animals.find( {emails: /dogs/} )
    db.animals.find( {"emails.1": "batman@dogs.com"} )

I przykład z tzw. *upsert*:

    :::javascript
    db.animals.update( {name: /^B/}, {"$inc": {total_emails: 1}}, true )

Trzeci argument ustawiony na *true* zmienia „update” na „upsert”.
Jeśli ustawimy też czwarty argument na true:

    :::javascript
    db.animals.update( {name: /^B/}, {"$inc": {total_emails: 1}}, true )

to jak się zmieni kolekcja *animals*? Wskazówka:

    db.animals.update


## Zrób to sam

Pobrać ze strony [MongoDB Quick Reference Cards](http://www.10gen.com/reference)
„Quick Reference Card: Queries”.

1\. Na przykładzie przykładowej kolekcji *Animals* przerobić polecenia z tej ściągi.

2\. Wejść na stronę [Handy resources for learning MongoDB](http://mongly.com).
Kliknąć w „The MongoDB Interactive Tutorial”. Przejść cały samouczek.

3\. Cursors. Queries, limits, skips. Przejrzeć [dokumentację](http://www.mongodb.org/display/DOCS/Home).
Przeczytać [samouczek](http://www.mongodb.org/display/DOCS/Tutorial).


## Typy danych

Dokumenty MongoDB są „JSON-like”. Oznacza to, że oprócz sześciu typów
JSON, MongoDB dodaje kilka swoich typów. Oto cała lista:

* *null* (JSON)
* *boolean*  (JSON)
* liczby całkowite 32-bitowe
* liczby całkowite 64-bitowe
* liczby zmiennopozycyjne 64-bitowe  (JSON, numeric)
* napisy (JSON)
* symbol(?)
* object id
* data
* wyrażenie regularne
* kod javascript
* binary data
* maximum value
* minimum value
* *undefined*
* tablice (JSON)
* embedded document (JSON)

Dokumentacja: [MongoDB Javascript API](http://api.mongodb.org/js/current/),
[ECMA-262, Edition 5](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-262.pdf).
