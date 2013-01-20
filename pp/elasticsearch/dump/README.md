# Elasticsearch ⟿  MongoDB

Przerzucamy indeks *tweets* z Elasticsearch do MongoDB:

    node dump-tweets-for-mongodb.js | mongoimport -d test -c tweets