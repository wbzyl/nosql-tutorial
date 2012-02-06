#### {% title "MongoDB – grupowanie" %}

Dane grupujemy za pomocą funkcji agregujących (podsumowujących, grupujących):

* [Aggregation](http://www.mongodb.org/display/DOCS/Aggregation)
* [Aggregation Framework](http://www.mongodb.org/display/DOCS/Aggregation+Framework)


## Grupowanie

Zadania na grupowanie?

1\. Ile jest słów zawierających daną literę?

2\. Ile jest akapitów zawierających daną literę?

3\. Ile jest akapitów zawierających dane słowo?

4\. Dla danego zestawu liter, ile słów można z nich utworzyć.

W każdym przypadku ograniczamy się do słów z książki
„Idiota” F. Dostojewskiego.

5\. W języku angielskim jest pięć samogłosek: a, e, i, o, u.
Wobec tego jest 32 podzbiorów samogłosek (włączając podzbiór pusty).

Ile jest słów zawierających wszystkie samogłoski, ile – bez
samogłosek, itd.


## Funkcja agregująca *group*

Zaczynamy od prostego przykładu:

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

Dla przypomnienia przykładowy dokument z kolekcji *dostojewski*:

    :::json
    {
      "_id" : ObjectId("4f2e956fe138237e61000079")
      "word": "morning",
      "para": 4.                                    # paragraph no with "morning"
      "letters": ["g", "i", "m", "n", "o", "r"]     # sorted and unique
    }

Zadanie dodatkowe: Który zestaw liter powtarza się najczęściej?

    :::js
    var res = db.dostojewski.group({
      key: {letters: true}
      , initial: {count: 0}
      , reduce: function(doc, out){ out.count++; }
    } );

    var totals = res.map(function(x) { return x.count });
    // Math.max.apply(null, totals);

    // TODO
    var totals_filtered = totals.filter(callback)
      // creates a new array with all of the elements of this array
      // for which the provided filtering function returns true

    var numeric = function(a, b) { return (a - b); };
    totals.sort(numeric);


## Zadanie 1



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
