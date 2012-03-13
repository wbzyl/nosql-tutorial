#### {% title "MongoDB – grupowanie" %}

Dane grupujemy za pomocą funkcji agregujących (podsumowujących, grupujących):

* [Aggregation](http://www.mongodb.org/display/DOCS/Aggregation)
* [Aggregation Framework](http://www.mongodb.org/display/DOCS/Aggregation+Framework)


## Zadania na grupowanie

W każdym zadaniu ograniczamy się do wszystkich słów, ale bez
„stopwords”, z książki „Idiota” F. Dostojewskiego.

Zadanie 1. Ile jest słów zawierających daną literę?

Zadanie 2. Ile jest akapitów zawierających daną literę?

Zadanie 3. Ile jest akapitów zawierających dane słowo?

Zadanie 4. Dla danego zestawu liter, ile słów można z nich utworzyć.

Zadanie 5. W języku angielskim jest pięć samogłosek: a, e, i, o, u.
Wobec tego jest 32 podzbiorów samogłosek (włączając podzbiór pusty).
Ile jest słów zawierających wszystkie samogłoski, ile – bez
samogłosek, itd.

Dla przypomnienia przykładowy dokument z kolekcji *dostojewski*:

    :::json
    {
      "_id" : ObjectId("4f2e956fe138237e61000079"),
      "word": "morning",
      "para": 4,                                     # numer akapitu ze słowem "morning"
      "letters": ["g", "i", "m", "n", "o", "r"]      # posortowane i unikalne
    }


## Funkcja agregująca *group*

Jak działa funkcja *group* wyjaśnimy na trzech prostych przykładach.

Grupowanie po atrybucie *para*: dla każdego akapitu, liczba słów,
liczba liter oraz średnia długość słowa dla słów tego akapitu.

    :::js
    db.dostojewski.group({
      cond: {"para": {$gte: 1022, $lt: 1024}}
      , key: {para: true}                            // grupujemy po atrybucie para
      , initial: {word_count: 0, total_words_len: 0} // początkowy dokument dla funkcji reduce
      , reduce: function(doc, out) { out.word_count++; out.total_words_len += doc.word.length; }
      , finalize: function(out) { out.avg_word_len = out.total_words_len / out.word_count; }
    } );
    [
      {
          "para" : 1022,
          "word_count" : 24,
          "total_words_len" : 150,
          "avg_word_len" : 6.25
      },
      {
          "para" : 1023,
          "word_count" : 14,
          "total_words_len" : 83,
          "avg_word_len" : 5.928571428571429
      }
    ]

Grupowanie po atrybucie *word*: dla każdego słowa, jego licznik wystąpień

    :::js
    TODO:

Grupowanie po atrybucie *letters*: dla każdego zestawu liter,
jego licznik wystąpień

    :::js group.js
    var res = db.dostojewski.group({
      key: {letters: true}
      , initial: {count: 0}
      , reduce: function(doc, out){ out.count++; }
    } );

    // var totals = res.map(function(x) { return x.count });
    // print("Max frequency: " + Math.max.apply(null, totals));

    var numeric = function(a, b){ return (b - a); };
    var top10 = totals.sort(numeric).slice(0, 9);
    print("Top 10 frequencies: " + top10);
    // Top 10: 1786,512,499,462,454,447,438,374,361

    db.results.drop();

    // There is no bulk insertion for the MongoDB shell versions prior to 2.1.0
    // res.forEach(function(obj) { db.results.insert(obj) });

    db.results.insert(res);

    var obj = db.results.findOne({ count: 512 });
    db.dostojewski.find({ letters: obj.letters });

Skrypt *group.js* uruchamiamy w następujący sposób:

    :::bash
    mongo --shell gutenberg group.js

albo tak:

    :::bash
    mongo --shell gutenberg
    > load('group.js')


W pliku *src/mongo/shell/utils.js* zdefiniowano
wiele użytecznych funkcji, na przykład:

    :::js
    Array.unique([1, 4, 2, 1, 4]);  //=> [1, 4, 2]
    Array.contains([1, 4, 2], 2);   //=> true
    Array.sum([1, 1, 2]);           //=> 4
    printjson({a: 1, b: "x"});
    db.results.find({count: {$gt: 300}}).forEach(function(o) { printjson(o.letters); });


## Zadanie 1, 2, 3, 4

**TODO**


## Zadanie 5

Przykład z keyf?

*keyf* – a JavaScript function that, when applied to a document, generates a key
for that document. This is useful when the key for grouping needs to be calculated.
Use this instead of key to specify a key that is not a single/multiple existing fields.

For instance if you wanted to group a result set by the day of the week
each document was created on but didn’t actually store that value, then you
could use a key function to generate the key:

    :::js
    function(doc) {
      return {day: doc.created_at.getDay();
    }

This function will generate keys like this one:

    :::json
    {day: 1}

Przyda się? Do generowania *keyf*?

    :::js
    word.split("").filter(function(c) { return /[aeiou]/.test(c); })
