# Elasticsearch  ⟿    MongoDB

Przerzucamy indeks *tweets* z Elasticsearch do MongoDB:

    node dump-tweets-for-mongodb.js | mongoimport -d test -c tweets


## Node.js v0.10 & Restler

* [How to change .setMaxListeners() in restler?](https://github.com/danwrong/restler/issues/111)
  ⇒ [Invalid behaviour on Node.js v0.10.0](https://github.com/danwrong/restler/issues/110)
  ⇒ [patched fork of Restler](https://github.com/QuePort/restler)
* Restler issues:
  - [Success and failure events fire too often](https://github.com/danwrong/restler/issues/112)
  - [Changed EventEmitter inheritens to Node0.10 style](https://github.com/danwrong/restler/pull/113)

Załatanie Restlera załatwiło sprawę.


## Przerzucamy daty

Stosujemy taki trik:

    today: { $date: Date.parse("20130119T11:59:17Z") }

# MongoDB: keyword and text search

* [Model Data to Support Keyword Search](http://docs.mongodb.org/manual/tutorial/model-data-for-keyword-search/)
* [MongoDB Text Search: Experimental Feature in MongoDB 2.4](http://blog.mongodb.org/post/40513621310/mongodb-text-search-experimental-feature-in-mongodb)
