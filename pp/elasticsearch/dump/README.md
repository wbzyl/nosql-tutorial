# Elasticsearch ⟿  MongoDB

Przerzucamy indeks *tweets* z Elasticsearch do MongoDB:

    node dump-tweets-for-mongodb.js | mongoimport -d test -c tweets

## Przerzucamy daty

Stosujemy taki trik:

    today: { $date: Date.parse("20130119T11:59:17Z") }