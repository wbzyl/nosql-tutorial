#### {% title "Full Text Search" %}

Od wersji 2.4.0 (oraz dla *nightly builds*):

* [Model Data to Support Keyword Search](http://docs.mongodb.org/manual/tutorial/model-data-for-keyword-search/#model-data-to-support-keyword-search)
* [Release Notes for MongoDB 2.4 (2.3 Development Series)](http://docs.mongodb.org/manual/release-notes/2.4/)
* pliki *jstest/fts\*.js* w źródłach [mongo](https://github.com/mongodb/mongo/tree/master/jstests)

Enable:

    :::js
    db.adminCommand( { setParameter: 1, textSearchEnabled: true } )

albo

    :::bash
    mongod --setParameter textSearchEnabled=true

## Proste przykłady

Zaczynamy od prostszej rzeczy: *keyword search*:

    :::js
    TODO

[Przykłady do przeklikania](https://github.com/ttrelle/mongodb-examples/tree/master/js/fts).

A teraz *full text search*:

    :::js
    https://github.com/mongodb/mongo/blob/master/jstests/fts_mix.js