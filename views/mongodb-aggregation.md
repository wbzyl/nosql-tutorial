#### {% title "MongoDB – Aggregation Pipeline" %}

<blockquote>
 {%= image_tag "/images/ogilvy-david.png", :alt => "[David Ogilvy]" %}
 <p>Never write more than two pages on any subject.</p>
 <p class="author">– David Ogilvy</p>
</blockquote>

W MongoDB do [agregacji](http://docs.mongodb.org/master/aggregation/)
(grupowania) danych używamy:

1. polecenia [group](http://docs.mongodb.org/master/reference/command/group/#dbcmd.group)
2. [Aggregation Pipeline](http://docs.mongodb.org/manual/core/aggregation-pipeline/)
3. polecenia [mapReduce](http://docs.mongodb.org/master/core/map-reduce/)

Linki do przykładów korzystających z Aggregation Pipeline w:

* [JavaScript](https://github.com/nosql/aggregations-3/blob/master/Aggregations_in_JS.md)
* [Ruby](https://github.com/mongodb/mongo-ruby-driver/wiki/Aggregation-Framework-Examples)

Joins and Other Aggregation Enhancements Coming in MongoDB v3.2.0:

* [Introduction](https://www.mongodb.com/blog/post/joins-and-other-aggregation-enhancements-coming-in-mongodb-3-2-part-1-of-3-introduction)
* [Worked Examples](https://www.mongodb.com/blog/post/joins-and-other-aggregation-enhancements-coming-in-mongodb-3-2-part-2-of-3-worked-examples)
* [Adding Some Code Glue and Geolocation](https://www.mongodb.com/blog/post/joins-and-other-aggregation-enhancements-coming-in-mongodb-3-2-part-3-of-3-adding-some-code-glue-and-geolocation)


## Przykłady z *group*

W poniższych przykładach będziemy grupować dokumenty z kolekcji
*dostojewski*. Kolekcję tę utworzyliśmy na poprzednim wykładzie.

Dla przypomnienia przykładowy dokument z kolekcji *dostojewski*:

    :::js
    db.dostojewski.find({word: "morning"}).limit(1)
    {
      "_id": ObjectId("5166f63075c8ae1f2e000057"),
      "word": "morning",
      "para": 32,                                  // numer akapitu ze słowem "morning"
      "letters": [ "g", "i", "m", "n", "o", "r" ]  // posortowane i unikalne
    }

Kilka zadań na rozgrzewkę. Jak to rozwiązać?

**Zadanie 1.** Ile jest słów zawierających daną literę?

**Zadanie 2.** Ile jest akapitów zawierających daną literę?

**Zadanie 3.** Ile jest akapitów zawierających dane słowo?

**Zadanie 4.** Dla danego zestawu liter, ile słów można z nich utworzyć.

**Zadanie 5.** W języku angielskim jest pięć samogłosek: a, e, i, o, u.
Wobec tego jest 32 podzbiorów samogłosek (włączając podzbiór pusty).
Ile jest słów zawierających wszystkie samogłoski, ile – bez
samogłosek, itd.

Dla każdego akapitu, dla którego *para* ϵ [1022, 1024) zliczymy liczbę
słów, liczbę liter oraz średnią długość słowa dla słów tego akapitu.

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
          "word_count" : 11,
          "total_words_len" : 72,
          "avg_word_len" : 6.54
      },
      {
          "para" : 1023,
          "word_count" : 5,
          "total_words_len" : 40,
          "avg_word_len" : 8
      }
    ]

Teraz będziemy grupować względem atrybutu *letters*:
dla każdego zestawu liter dodamy jego licznik wystąpień:

    :::js group.js
    var res = db.dostojewski.group({
      key: {letters: true}
      , initial: {count: 0}
      , reduce: function(doc, out){ out.count++; }
    } );

Wynikiem *res* jest tablica. Pierwszy element tej tablicy, *res[0]* to:

    :::json
    { "letters" : [ "d", "i", "o", "t" ], "count" : 50 }

Łatwo zgadnąć, że słowo *idiot* oraz inne słowa składające się
z liter z tablicy *letters* wystąpiły w książce 50 razy.

Które zestawy liter występują najczęściej?
Posortujmy malejąco listę *res* względem licznika *count*
i zapamiętajmy w *top10* dziesięć najczęściej występujących
zestawów liter:

    :::js
    var top10 = res.sort(function(a,b){ return b.count - a.count; }).slice(0, 10);

Pierwsza trójka to:

    :::js
    "letters" : [ "c", "e", "i", "n", "p", "r" ], "count" : 1786
    "letters" : [ "d", "n", "o", "t" ],           "count" : 512
    "letters" : [ "a", "e", "g", "l", "n", "r" ], "count" : 499

Drugie miejsce to zasługa słówka *don’t*. Nieprawdaż?
A miejsca pierwsze i trzecie to zasługa…?

    :::js
    var winner = db.dostojewski.find({letters: [ "c", "e", "i", "n", "p", "r" ]})
    var third  = db.dostojewski.find({letters: [ "a", "e", "g", "l", "n", "r" ]})

Warto pogrupować wyniki *winner* względem *word*.
Najpierw zapiszemy wyniki w kolekcji winners:

    :::js
    db.winners.drop();
    winner.forEach(function(obj) { db.winners.insert(obj) });
    var winners = db.winners.group({
      key: {word: true}
      , initial: {count: 0}
      , reduce: function(doc, out){ out.count++; }
    } );
    winners.length  //=> 1  Jakie to słowo?

Dla *third* wynik jest następujący:

    :::js
    thirds.length  //=> 2   Jakie to słowa?

Na koniec, zapamiętamy wyniki grupowania *res*, może się
jeszcze przydadzą do jakiegoś grupowania?

    :::js
    db.results.drop();
    // bulk insert for the mongo 2.1+; res jest tablicą
    db.results.insert(res);
    // there is no bulk insertion for the mongo < 2.1; działa też na cursorach
    // res.forEach(function(obj) { db.results.insert(obj) });

**Uwaga 1:** Wszystkie polecenia możemy wpisać w pliku,
na przykład *group.js* i wykonać je w taki sposób:

    :::bash
    mongo --shell test group.js

albo w taki:

    :::bash
    mongo --shell test
    > load('group.js')

**Uwaga 2:** W pliku [types.js](https://github.com/mongodb/mongo/blob/master/src/mongo/shell/types.js)
zdefiniowano wiele użytecznych funkcji, na przykład:

    :::js
    Array.unique([1, 4, 2, 1, 4]);  //=> [1, 4, 2]
    Array.contains([1, 4, 2], 2);   //=> true
    Array.sum([1, 1, 2]);           //=> 4
    printjson({a: 1, b: "x"});
    db.results.find({count: {$gt: 300}}).forEach(function(o) { printjson(o.letters); });


## TODO: przykład użycia *keyf*

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
    {"day": 1}

Przyda się? Do generowania *keyf*?

    :::js
    word.split("").filter(function(c) { return /[aeiou]/.test(c); })


## Różności

* [SQL to Aggregation Pipeline Mapping Chart](http://docs.mongodb.org/manual/reference/sql-aggregation-comparison/)
* Kristina Chodorow,
  [Hacking Chess with the MongoDB Pipeline](http://www.snailinaturtleneck.com/blog/2012/01/26/hacking-chess-with-the-mongodb-pipeline/)
