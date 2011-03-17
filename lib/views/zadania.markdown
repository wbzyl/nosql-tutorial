#### {% title "Zadania" %}

<blockquote>
 <p>
   After three days without programming, life becomes meaningless.
 </p>
 <p class="author">[The Tao of Programming 2.1]</p>
</blockquote>

Typowe zastosowania dokumentowych baz danych to:

* Contact Address/Phone Book
* Forum/Discussion
* Bug Tracking
* Document Collaboration/Wiki
* Customer Call Tracking
* Expense Reporting
* To-Dos
* Time Sheets
* E-mail
* Help/Reference Desk
* CRM(?)


# Zadania

<blockquote>
 <p>
  A well-written program is its own heaven; a poorly-written program is its own hell.
 </p>
 <p class="author">[The Tao of Programming 4.1]</p>
</blockquote>

1\. Baza (CouchDB) „książki” zawiera dokumenty z informacjami o książkach,
na przykład:

    :::javascript
    {
      "_id": "3194d86ab7cb2c1465fa5fea901f4c55",
      "_rev": "1-2724eb06ca15197e71e13e1b46b75aee",
      "isbn": "1844571696",
      "isbn13": "",
      "book_id": "100_shakespeare_films_a01"
    }
    // http://sigma.ug.edu.pl:5984/ksiazki/3194d86ab7cb2c1465fa5fea901f4c55

Inne dokumenty mogą zawierać inne pola: *publisher*, *authors*, *title*.

Napisać widok wyliczający ile i jakie pola zawarte są w dokumentach tej bazy.
Niektóre pola są puste. Uwzględnić to w rachunkach.


2\. Wizualizacja przykładowych danych.
Przykładowe można przedstawiłem w „Generator przemówień i inne zastosowania…”.


3\. **SQL & JSON**. [Yahoo! Query Language](http://developer.yahoo.com/yql/).
Zobacz przykłady Zillow, Yelp, Pidgets Geo IP – wybrać format JSON.

[streaming twitter into mongodb](http://eliothorowitz.com/post/459890033/streaming-twitter-into-mongodb):

    curl http://stream.twitter.com/1/statuses/sample.json -u<user>:<password> | mongoimport -c twitter_live

Zamiast twittera użyć YQL. Przygotować przykład.
Link do dokumentacji – [YQL Guide](http://developer.yahoo.com/yql/guide/index.html).


## TODO

1\. Przygotować przykład korzystający
z [IndexedDB in Firefox 4](http://hacks.mozilla.org/2011/01/indexeddb-in-firefox-4/).
Więcej dokumentacji – [Mozilla Developer Network](https://developer.mozilla.org/en-US/).

Przykład aplikacji offline korzystającej z HTML5 localStorage, np. Offline Apps
[Part 1](http://railscasts.com/episodes/247) & [Part 2](http://railscasts.com/episodes/248).

3\. [BigQuery](http://code.google.com/intl/pl/apis/bigquery/) –
is a web service that enables you to do interactive analysis of
massively large datasets.
Both RESTful and JSON-RPC methods are available. Queries are expressed
in a SQL dialect.

4\. [Building a Twitter Filter With Sinatra, Redis, and
TweetStream](http://www.digitalhobbit.com/2009/11/08/building-a-twitter-filter-with-sinatra-redis-and-tweetstream/).

Przykłady:

* [cursebird](http://cursebird.com/)
* [twistori](http://twistori.com/#i_wish)
* [twatcher](http://twatcher.com/)

Linki:

* Twitter [Streaming API Documentation](http://apiwiki.twitter.com/Streaming-API-Documentation)
* [tweetstream](http://github.com/intridea/tweetstream) – a RubyGem to access the Twitter Streaming API

3\. [NoSQL Twitter Applications](http://nosql.mypopescu.com/post/319859407/nosql-twitter-applications).

4\. [Usecase: NoSQL-based Blogs](http://nosql.mypopescu.com/post/346471814/usecase-nosql-based-blogs).

5\. [Note taking apps a la NoSQL](http://nosql.mypopescu.com/post/425140372/note-taking-apps-a-la-nosql).

6\. Redis:

* Rob Watson. [A Redis-powered newsfeed
  implementation](http://rfw.posterous.com/a-redis-powered-newsfeed-implementation)

7\. NodeJS:

* Rob Watson. [How NodeJS saved my web
  application](http://rfw.posterous.com/how-nodejs-saved-my-web-application)

8\. Michael Dirolf.
[Getting Non-Relational with MongoDB](http://www.softdevtube.com/2010/03/15/getting-non-relational-with-mongodb/) —
This talk will introduce MongoDB and discuss some of the reasons why
MongoDB might be the right choice for your project. It will include an
overview of MongoDB as well as detailed examples using MongoDB in
Ruby.

<embed src='http://rubyconf2009.confreaks.com/player.swf' height='285' width='480' allowscriptaccess='always' allowfullscreen='true' flashvars='image=images%2F19-nov-2009-16-20-getting-non-relational-with-mongodb-michael-dirolf-preview.png&file=http%3A%2F%2Frubyconf2009.confreaks.com%2Fvideos%2F19-nov-2009-16-20-getting-non-relational-with-mongodb-michael-dirolf-small.mp4&plugins=viral-1'/>

9\. [MySQL vs MongoDB](http://blog.boardtracker.com/viewtopic.php?f=4&t=75)

10\. Ian Warshak.
[Faceted search with MongoDB](http://ianwarshak.posterous.com/faceted-search-with-mongodb) —
przepisać na CouchDB.

7\. [MongoDB geospatial examples in Ruby](http://codesnotdead.blogspot.com/2010/03/mongodb-geospatial-indexing-examples-in.html) — przepisać na CouchDB.

8\. [CouchDB Case Studies](http://nosql.mypopescu.com/post/597651382/couchdb-case-studies)

9\. [A NoSQL Use Case: URL Shorteners](http://nosql.mypopescu.com/post/597603446/a-nosql-use-case-url-shorteners): MongoDB+Redis, Riak+Sinatra, [CouchDB](http://github.com/janl/io).


# Prezentacje (ok. 30 min.)

* **Cassandra** — podstawy, indeksowanie, wyjaśnić
  pojęcie *kolumnowa baza danych*, wyjaśnić dlaczego odczytywanie
  danych z bazy jest tak szybkie
  -- [kilka linków na początek](http://nosql.mypopescu.com/post/660373825/presentation-cassandra-basics-indexing)
* [Node.JS + Riak](http://nosql.mypopescu.com/post/654107903/presentation-an-introduction-to-node-js-and-riak) – koszt operacji IO „Numbers Everyone Should Know”
