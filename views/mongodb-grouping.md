#### {% title "MongoDB – proste grupowania" %}

Powtórka:

* [Querying](https://docs.mongodb.com/manual/tutorial/query-documents/)
* [Data Model Examples and Patterns](https://docs.mongodb.com/manual/applications/data-models/)

Nowe:

* [Aggregation Commands](https://docs.mongodb.com/master/reference/command/nav-aggregation/):
  *aggregate*, *count*, *distinct*, *group*, *mapReduce*.


       ☀☀☀


Zaczniemy od przygotowania kolekcji, której dokumentów użyjemy w przykładach poniżej.

W kolekcji zapiszemy dokumenty w formacie:

    :::js
    {
      "_id" : ObjectId("4f2e956fe138237e61000079")
      "word": "morning",
      "para": 4.                                // numer akapitu ze słowem "morning"
      "letters": ["g", "i", "m", "n", "o", "r"] // litery "morning" w kolejności alfabetycznej, bez powtórzeń
    }

Dokumenty te wygenerujemy korzystając z angielskiej wersji tekstu powieści
*Idiota* Fiodora Dostojewskiego. Tekst pobrano
z serwisu [Free eBooks by Project Gutenberg](http://www.gutenberg.org/ebooks/2638).

Kolekcję nazwiemy *dostojewski*.
Do zapisania danych w kolekcji użyjemy prostego skryptu Ruby
{%= link_to "dostojewski.rb", "db/mongodb/dostojewski.rb" %}.

    :::bash terminal
    ruby dostojewski.rb
    I, [2013-10-22T14:04:06.654823 #1509]  INFO -- : liczba wczytanych stopwords: 742
    I, [2013-10-22T14:04:06.766109 #1509]  INFO -- : liczba wczytanych akapitów: 5260
    I, [2013-10-22T14:04:56.038536 #1509]  INFO -- : MongoDB:
    I, [2013-10-22T14:04:56.038645 #1509]  INFO -- :      database: test
    I, [2013-10-22T14:04:56.038708 #1509]  INFO -- :    collection: dostojewski
    I, [2013-10-22T14:04:56.039258 #1509]  INFO -- :         count: 80346

Na koniec dodamy index:

    :::js
    db.dostojewski.createIndex({'word': 1})
    db.dostojewski.find({word: /^x/}, {_id: 0}).explain()

*Uwaga:* Skrypt korzysta z pliku *stopwords.en* zwierającego
najczęściej występujące słowa, które nie niosą żadnej treści.
Każde [stop word](http://pl.wikipedia.org/wiki/Wikipedia:Stopwords)
jest zapisane w osobnym wierszu.<br>
Plik ze *stop words* pobieramy z repozytorium Gnome:

    :::bash
    git clone git://git.gnome.org/tracker
    ls -l tracker/data/language/stopwords.en

Program *wc* pokazuje, że w książce jest 244575 słów.
Zatem liczba „stopwords” to ok. 66%.


## Przykładowe zapytania

Przechodzimy na konsolę Mongo:

    :::bash
    mongo gutenberg

Zapytania z *count* i *distinct*:

    :::js
    db.dostojewski.count()                     // 80_346
    db.dostojewski.distinct("word").length     //  9_857
    db.dostojewski.distinct("letters").sort()
    db.dostojewski.distinct("letters").length  //     39

Proste zapytania z rzutowaniem i sortowaniem:

    :::js
    db.dostojewski.find({}, {word: 1, _id: 0}).sort({word: 1}).limit(10)
    db.dostojewski.find({}, {_id: 0}).sort({word: -1}).skip(32060).limit(10)
    db.dostojewski.find({word: /^x/}, {_id: 0}).sort({word: -1}).limit(20)
    db.dostojewski.find({letters: "x"}, {_id: 0})     // it – iterate over result set

Wyszukiwanie w tablicach:

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
