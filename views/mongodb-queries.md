#### {% title "MongoDB – język zapytań" %}

* [Querying](http://docs.mongodb.org/manual/tutorial/query-documents/)
* [Data Model Examples and Patterns](http://docs.mongodb.org/manual/applications/data-models/)

Transakcje w MongoDB:

* [Perform Two Phase Commits](http://docs.mongodb.org/manual/tutorial/perform-two-phase-commits/)

Zaczniemy od przygotowania kolekcji.
W kolekcji zapiszemy dokumenty:

    :::js
    {
      "_id" : ObjectId("4f2e956fe138237e61000079")
      "word": "morning",
      "para": 4.                                // numer akapitu ze słowem "morning"
      "letters": ["g", "i", "m", "n", "o", "r"] // litery "morning" w kolejności alfabetycznej, bez powtórzeń
    }

Dokumenty te utworzymy z angielskiej wersji tekstu powieści
*Idiota* Fiodora Dostojewskiego. Tekst pobrałem
z serwisu [Free eBooks by Project Gutenberg](http://www.gutenberg.org/ebooks/2638).

Kolekcję nazwiemy *dostojewski*.
Do zapisania danych w kolekcji użyjemy prostego skryptu Ruby
{%= link_to "dostojewski.rb", "db/mongodb/dostojewski.rb" %}.

    :::bash terminal
    ruby dostojewski.rb
      I, [2012-02-06T20:34:56.602793 #32687]  INFO -- : liczba wczytanych stopwords: 742
      I, [2012-02-06T20:34:56.620884 #32687]  INFO -- : liczba wczytanych akapitów: 5260
      I, [2012-02-06T20:35:25.147644 #32687]  INFO -- : MongoDB:
      I, [2012-02-06T20:35:25.147754 #32687]  INFO -- : 	  database: gutenberg
      I, [2012-02-06T20:35:25.147812 #32687]  INFO -- : 	collection: dostojewski
      I, [2012-02-06T20:35:25.148334 #32687]  INFO -- : 	     count: 81865

Program *wc* pokazuje, że w książce jest 244575 słów.
Zatem liczba „stopwords” to ok. 66%.


## Przykładowe zapytania

Przechodzimy na konsolę Mongo:

    :::bash
    mongo gutenberg

Zliczanie z *count* i *distinct*:

    :::js
    db.dostojewski.count()
    db.dostojewski.distinct("word").sort()
    db.dostojewski.distinct("letters").sort()


Proste zapytania z rzutowaniem i sortowaniem:

    :::js
    db.dostojewski.find({}, {word: 1, _id: 0}).sort({word: 1}).limit(20)
    db.dostojewski.find({}, {_id: 0}).sort({word: -1}).skip(32060).limit(10)
    db.dostojewski.find({word: /^x/}, {_id: 0}).sort({word: -1}).limit(20)
    db.dostojewski.find({letters: "x"}, {_id: 0})     // it – iterate over result set
    db.dostojewski.find({"letters.2": "x"}, {_id: 0})

Tablice:

    :::js
    db.dostojewski.find( {"letters.2": "x"}, {_id: 0} )
    db.dostojewski.find( { letters : { $size: 15 } } )

Zakresy: $gt, $gte, $lt, $lte – porównywanie liczb, napisów, dat.

    :::js
    db.dostojewski.find({para: { $gte: 1024 }})
    db.dostojewski.find({para: { $gte: 1024, $lt: 1026 }})

Operatory na zbiorach: $in, $nin, $all:

    :::js
    db.dostojewski.find({para: {$in: [1024, 2048]}}, {_id: 0})
    db.dostojewski.find({word: {$in: ["petersburg", "russia"]}}, {_id: 0})
    db.dostojewski.find({letters: {$all: ["a", "e", "i", "o", "u"]}}, {_id: 0})

Operatory boolowskie: $ne, $not, $or, $and, $exists:

    :::js
    db.dostojewski.find({word: {$not: /[a-z]/}}, {_id: 0})
    db.dostojewski.find({$or: [{word: "petersburg"}, {word: "russia"}]}
    db.dostojewski.find({ $and: [{letters: {$in: ['a', 'e', 'i']}}, {letters: {$in: ['i', 'o', 'u']}}] })
    db.dostojewski.find({ letters: {$exists: false} })  // dokumenty bez atrybutu letters

JavaScript:

    :::js
    db.dostojewski.find({ $where: "(this.word.length >= 12) && (this.word.length <= 15)" })

albo równoważnie:

    :::js
    db.dostojewski.find({ $where: "function() {return (this.word.length >= 12) && (this.word.length <= 15)}" })

Indeksy:

    :::js
    db.dostojewski.ensureIndex({'word': 1})  // ?
    db.dostojewski.find({word: /^x/}, {_id: 0}).explain()


## Wyszukiwanie w sub-dokumentach

* [Dot Notation (Reaching into Objects)](http://www.mongodb.org/display/DOCS/Dot+Notation+%28Reaching+into+Objects%29)
* [Multikeys](http://www.mongodb.org/display/DOCS/Multikeys)


## The wonderful world of GEO spatial indexes in MongoDB

Przykłady dla Node.js + sterownik node-mongodb-native:

* [The wonderful world of GEO spatial indexes in MongoDB](http://christiankvalheim.com/post/35293863731/the-wonderful-world-of-geo-spatial-indexes-in-mongodb)

Najpierw instalujemy moduł:

    npm install mongodb

Dokumentacja sterownika [mongodb](https://github.com/mongodb/node-mongodb-native).
