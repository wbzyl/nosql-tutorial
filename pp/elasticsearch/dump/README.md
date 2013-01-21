# Elasticsearch ⟿  MongoDB

Przerzucamy indeks *tweets* z Elasticsearch do MongoDB:

    node dump-tweets-for-mongodb.js | mongoimport -d test -c tweets

## Przerzucamy daty

Stosujemy taki trik:

    today: { $date: Date.parse("20130119T11:59:17Z") }

# MongoDB: keyword and text search

* [Model Data to Support Keyword Search](http://docs.mongodb.org/manual/tutorial/model-data-for-keyword-search/)
* [MongoDB Text Search: Experimental Feature in MongoDB 2.4](http://blog.mongodb.org/post/40513621310/mongodb-text-search-experimental-feature-in-mongodb)