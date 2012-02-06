#### {% title "MongoDB – język zapytań" %}

* [Querying](http://www.mongodb.org/display/DOCS/Querying)
* [Advanced Queries](http://www.mongodb.org/display/DOCS/Advanced+Queries)

Zaczniemy od przygotowania kolekcji.
W kolekcji zapiszemy dokumenty:

    :::json
    {
      "_id" : ObjectId("4f2e956fe138237e61000079")
      "word": "morning",
      "para": 4.                                    # paragraph no with "morning"
      "letters": ["g", "i", "m", "n", "o", "r"]     # sorted and unique
    }

Dokumenty te utworzymy z angielskiej wersji tekstu powieści
*Idiota* Fiodora Dostojewskiego. Tekst pobrałem
z serwisu [Free eBooks by Project Gutenberg](http://www.gutenberg.org/ebooks/2638).

Kolekcję nazwiemy *dostojewski*.
Do zapisania danych w kolekcji użyjemy prostego skryptu w Ruby
{%= link_to "aggregation.rb", "db/mongodb/aggregation.rb" %}.

    :::bash terminal
    ruby aggregation.rb
      I, [2012-02-06T15:52:48.870545 #11067]  INFO -- : wczytano akapitów: 5261
      I, [2012-02-06T15:53:40.449740 #11067]  INFO -- : MongoDB:
      I, [2012-02-06T15:53:40.449854 #11067]  INFO -- : 	  database: gutenberg
      I, [2012-02-06T15:53:40.449919 #11067]  INFO -- : 	collection: dostojewski
      I, [2012-02-06T15:53:40.450483 #11067]  INFO -- : 	     count: 243731


## Język zapytań MongoDB

Przechodzimy na konsolę Mongo:

    :::bash terminal
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
    db.dostojewski.find({letters: "x"}, {_id: 0})     # it – iterate over result set
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
    db.dostojewski.find({ letters: {$exists: false} })  # dokumenty bez atrybutu letters

JavaScript:

    :::js
    db.dostojewski.find({ $where: "(this.word.length >= 12) && (this.word.length <= 15)" })

albo równoważnie:

    :::js
    db.dostojewski.find({ $where: "function() {return (this.word.length >= 12) && (this.word.length <= 15)}" })

Indeksy:

    :::js
    db.dostojewski.ensureIndex({'word': 1})  # ?
    db.dostojewski.find({word: /^x/}, {_id: 0}).explain()


## Wyszukiwanie w sub-dokumentach

**TODO** – nowy rozdział?
