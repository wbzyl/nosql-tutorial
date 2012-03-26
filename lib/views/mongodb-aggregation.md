#### {% title "MongoDB – grupowanie" %}

Dane grupujemy za pomocą funkcji agregujących (podsumowujących, grupujących):

* [Aggregation](http://www.mongodb.org/display/DOCS/Aggregation)
* [Aggregation Framework](http://www.mongodb.org/display/DOCS/Aggregation+Framework)


## Zadania na grupowanie

W zadaniach będziemy korzystać z kolekcji *dostojewski*.
Kolekcję tę tworzymy korzystając ze skryptu
{%= link_to "aggregation.rb", "/db/mongodb/aggregation.rb" %}
z wykłądu {%= link_to "Język zapytań", "/mongodb-queries" %}.

Dla przypomnienia przykładowy dokument z kolekcji *dostojewski*:

    :::json
    {
      "_id" : ObjectId("4f2e956fe138237e61000079"),
      "word": "morning",
      "para": 4,                                     # numer akapitu ze słowem "morning"
      "letters": ["g", "i", "m", "n", "o", "r"]      # posortowane i unikalne
    }

Zadanie 1. Ile jest słów zawierających daną literę?

Zadanie 2. Ile jest akapitów zawierających daną literę?

Zadanie 3. Ile jest akapitów zawierających dane słowo?

Zadanie 4. Dla danego zestawu liter, ile słów można z nich utworzyć.

Zadanie 5. W języku angielskim jest pięć samogłosek: a, e, i, o, u.
Wobec tego jest 32 podzbiorów samogłosek (włączając podzbiór pusty).
Ile jest słów zawierających wszystkie samogłoski, ile – bez
samogłosek, itd.


## Funkcja agregująca *group*

Jak działa funkcja *group* wyjaśnimy na trzech prostych przykładach.

W przykładzie poniżej będziemy grupować po atrybucie *para*:

    :::js
    db.dostojewski.findOne()
    {
        "_id" : ObjectId("4f70883be1382375ac000001"),
        "word" : "idiot",
        "para" : 0,
        "letters" : [ "d", "i", "o", "t" ]
    }

Dla każdego akapitu, dla którego *para* ϵ [1022, 1024) zliczamy liczbę
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

Następny przykład. Grupowanie względem atrybutu *letters*:
dla każdego zestawu liter, jego licznik wystąpień

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

**Uwaga 1:** Wszystkie te polecenia możemy wpisać w pliku,
na przykład *group.js* i wykonać je w taki sposób:

    :::bash
    mongo --shell gutenberg group.js

albo taki sposób:

    :::bash
    mongo --shell gutenberg
    > load('group.js')

**Uwaga 2:** W pliku *src/mongo/shell/utils.js* zdefiniowano
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
