#### {% title "Funkcje listowe" %}

Do czego będziemy używać tych funkcji:
„Just as show functions convert documents to arbitrary output formats,
CouchDB list functions allow you to render
**the output of *view queries* in any format.**”

Funkcje listowe konwertują widoki, dlatego aby poeksperymentować
z tymi funkcjami będziemy potrzebować jakiejś bazy z widokiem.

Skorzystamy z bazy *nosql-slimmed*. Oto przykładowy dokument z tej bazy:

    :::json
    {
      "_id":"45577472607125504",
      "_rev":"1-f70043f8ccf7399b32015af990b5c607",
      "text":"@JustinBieber my friend cassandra said hi (: and asked me if you can RT this :D",
      "entities":{
        "urls":[],
        "user_mentions":[
          {
            "indices":[0,13],
            "name":"Justin Bieber",
            "screen_name":"justinbieber",
            "id":27260086,
            "id_str":"27260086"
          }
         ],
        "hashtags":[]},
      "screen_name":"eliyahhhxD",
      "lang":"en",
      "created_at":"Wed Mar 09 20:11:30 +0000 2011",
      "created_on":[2011,3,9,20,11,30]}
    }

Prosty przykład funkcji listowej znajdziemy
na Wiki, [Formatting with Show and List](http://wiki.apache.org/couchdb/Formatting_with_Show_and_List).
Użyjemy jej, na początek/aby od czegoś zacząć, w kodzie poniżej.

Widoki będziemy zapisywać w bazie za pomocą Node.Couchapp:

    :::javascript sun.js
    var couchapp = require('couchapp');
    ddoc = {
      _id: '_design/test'
      , views: {}
      , lists: {}
    }
    module.exports = ddoc;

    ddoc.views.sun = {
      map: function(doc) {
        var retweeted = /\b(via|RT)\s*(@\w+)/ig;
        // w tej wersji tylko pierwsze dopasowanie
        var match = retweeted.exec(doc.text);
        if (match != null) {
          emit([match[2].toLowerCase(), doc.screen_name], doc.text);
        };
      },
      reduce: "_count"
    }

    ddoc.lists.all = function(head, req) {
      var row;
      start({
        "headers": {
          "Content-Type": "text/plain"
         }
      });
      while(row = getRow()) {
        send(row.value);
        send("\n");
      }
    }

Aby zapisać powyższy widok i funkcję list w bazie należy wykonać na konsoli polecenie:

    couchapp push sun.js http://localhost:5984/nosql-slimmed


### Co zawierają zmienne *head*, *req* i *row*

Jeśli do kodu funkcji *all* dopiszemy

    log(head); log(req); log(JSON.stringify(row));

to w logach będziemy mogli podejrzeć jaką wartość nadaje tym zmiennym
CouchDB. I tak po wykonaniu polecenia:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?reduce=false&limit=2&q="rbates"'

w logach znajdziemy, że *head* to:

    {"total_rows":4876,"offset":0,"update_seq":25539}

*req* to:

    :::javascript
    {
      "info":{"db_name":"nosql-slimmed","doc_count":25535,"doc_del_count":0,
      "update_seq":25539,"purge_seq":0,"compact_running":false,"disk_size":18853986,
      "instance_start_time":"1300552781362609","disk_format_version":5,"committed_update_seq":25539},
      "id":null,"uuid":"c751b293488b9076644fb906a2002764",

      "method":"GET",
      "requested_path":["nosql-slimmed","_design","test","_list","all","sun?reduce=false&limit=2&q=\"rbates\""],
      "path":["nosql-slimmed","_design","test","_list","all","sun"],
      "query":{"reduce":"false","limit":"2","q":"\"rbates\""},
      "headers":{"Accept":"*/*","Host":"localhost:5984","User-Agent":"curl/7.21.0..."},
      "cookie":{},
      "userCtx":{"db":"nosql-slimmed","name":null,"roles":["_admin"]},

      "body":"undefined","peer":"127.0.0.1","form":{},
      "secObj":{}
    }

a *row* to:

    :::javascript
    {
      "id":"47402480702730240",
      "key": ["@_brooklynemm","StephSideris"],
      "value": "RT @_brooklynemm: Billlllin up Thursday with @_ashleymariee_ & @StephSideris & Cassandra Larosa &lt;3"
    }

To co znajdziemy w logach zależy od zapytania. Jeśli je wymienimy na:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group=true'

to tym razem *row* będzie zawierać:

    {
      "key":["@_brooklynemm","StephSideris"],
      "value":1
    }

Jeśli ustawimy group level:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1'

to *row*:

    {
      "key":["@_felipera"],
      "value":5
    }


## Paskudne szczegóły – start, send, getRow

Poniższa list pochodzi z bloga C. McMahona,
[On _design undocumented](http://caolanmcmahon.com/posts/on__designs_undocumented).
(zob. też [render.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/render.js?view=markup),
zawiera opis funkcji *getRow()*):

* **start** – sets the response headers to send from a list
  function. These are sent on the first call to *getRow()*. Therefore
  you cannot call start after *getRow()*, even if you only send data
  after getting all rows.
* **send** – sets a chunk of response data to be sent on the next call
  to *getRow()*, or at the end of the list functions execution.
* **getRow** – returns the next row from the view or null if there are
  no more rows. On the first call to get row, the headers set by
  *start()* are sent, on subsequent calls the data chunks set by *send()*
  are sent.

W kodzie poniżej przydadzą się dwie funkcje: *JSON.stringify* i *JSON.parse*.


# Twitter

Zależność między list a view, to jeden do wielu.

W przykładach poniżej będziemy
pisać funkcję list pod konkretny widok.
Dlatego pisanie kodu będziemy zawsze zaczynać od widoku.

Lista przykładów:

* sortowanie po *values*
* filtrowanie rekordów: opcje zapytań *cutoff=3* – cytowane częściej niż trzy razy
* plain/text + kod programu dla circo (z pakietu Graphvix)
* szablony mustache


## Sortowanie po *values*

Widoki są sortowane według *keys*.
Aby wygenerować listę posortowaną po liczbie cytowań, należy ją posortować
według *values*. W tym celu wystarczy zapamiętać wszystkie wiersze
widoku w tablicy, następnie je posortować za pomocą funkcji *sort*
i na koniec przesłać za pomocą *send*:

    :::javascript
    ddoc.lists.all = function(head, req) {
      var row;
      var rows = [];
      start({
        "headers": {
          "Content-Type": "text/plain"
         }
      });
      while(row = getRow()) {
        rows.push(row);
      };
      rows.sort(function(a, b) {
        return b.value - a.value;
      });
      rows.map(function(row) {
        send(JSON.stringify(row));
      });
    }

Teraz wykonanie polecenia:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1'

daje widok posortowany malejąco według listy cytowań.

Niestety, teraz polecenie:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1&limit=2'
      {"key":["@_felipera"],"value":5}
      {"key":["@_brooklynemm"],"value":1}

jak widac, nie działa zgodnie z oczekiwaniem – sortowanie & limit nie składają się
się w tej kolejności (ale, najpierw mamy limit a następnie sortowanie).
Czy można to jakoś naprawić?


## Filtrowanie – dodajemy *cutoff=N*

Query option *cutoff=4* ma zwracać listę tweets cytowanych co najmniej cztery razy.
Coś takiego można zaimplementować w taki sposób:

    :::javascript
    ddoc.lists.all = function(head, req) {
      var row;
      var rows = [];
      var cutoff = req.query["cutoff"] || 1;
      start({
        "headers": {
          "Content-Type": "text/plain"
         }
      });
      while(row = getRow()) {
        if (row.value >= cutoff) {
          rows.push(row);
        };
      };
      rows.sort(function(a, b) {
        return b.value - a.value;
      }).map(function(row) {
        send(JSON.stringify(row));
      });
    }

Teraz sprawdzamy, kto był najczęściej cytowany:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group_level=1&cutoff=40'
      {"key":["@dhh"],"value":376}
      {"key":["@mongodb"],"value":201}
      {"key":["@sstephenson"],"value":110}
      {"key":["@ryah"],"value":90}
      {"key":["@hipsterhacker"],"value":57}
      {"key":["@rbates"],"value":41}

Jak sprawdzić, za pomocą funkcji listowych, dlaczego ci użytkownicy byli tak
często cytowani?

Bez funkcji listowych *quick & dirty solution* – korzystamy ze skryptu:

    :::text check.sh
    #!/bin/bash
    curl http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\\[\"@$1\"\\]\&endkey=\\[\"@$1\",\\{\\}\\]\&reduce=false

w taki sposób:

    ./check dhh
    ./check mongodb

Czy są jakieś niespodzianki?


## Graphviz output

[Graphviz](http://www.graphviz.org/) to język do wizualizacji danych w postaci grafów.
Do rysowania grafu używamy jedenej z „layout engines”:
**dot**, **neato**, **fdb**, **sfdp**, **twopi** lub **circo**.
Do wizualizacji tweets użyjemy maszynki **circo** (dlaczego? to się za
chwilę okaże).

Za pomocą funkcji listowej wygeneruję program :

    :::dot tweets.gv
    strict digraph {
      "@JustinBieber" -> "eliyahhhxD" [tweet_id=45577472607125504];
      ...
      "@jsconfit" -> "UrbanDEV" [tweet_id=49367585552207872];
    }

Po zapisaniu design doc w bazie, a następnie danych w pliku *nosql_tweets.gv*:

    couchapp push circo.js http://localhost:5984/nosql-slimmed
    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/circo/sun?limit=100' > nosql-tweets.gv

będziemy mogli wygenerować obrazek z grafem:

    circo -v -Tpng -Onosql-tweets nosql-tweets.gv


### Piszemy widok + funkcję listową

Wystarczy prosta modyfikacja kodu powyżej:

    :::javascript circo.js
    var couchapp = require('couchapp');
    ddoc = {
      _id: '_design/test'
      , views: {}
      , lists: {}
    }
    module.exports = ddoc;

    ddoc.views.graph = {
      map: function(doc) {
        var retweeted = /\b(via|RT)\s*(@\w+)/ig;
        var match = retweeted.exec(doc.text);
        if (match != null) {
          emit([match[2].toLowerCase(), doc.screen_name], null);
        };
      },
      reduce: function(keys, values, rereduce) {
        var retwitters = [];

        if (!rereduce) {
          keys.map(function(key) {
              // [["@tapajos","dirceu"],"45880323204067328"]
              retwitters.push(key[0][1]);
          });
        } else {
          values.map(function(o) {
              //if (value.retwitters.length < 32) {
              retwitters.push(o.retwitters[0]);
              //};
          });
        };
        return retwitters;
      }
    }

    ddoc.lists.circo = function(head, req) {
      var row;
      start({
        "headers": {
          "Content-Type": "text/plain"
        }
      });
      send("strict digraph {\n");
      while(row = getRow()) {
        // "@JustinBieber" -> "eliyahhhxD" [tweet_id=45577472607125504];
        send('"' + row.key[0] + '"' + " -> " + '"' + row.key[1] + '"' + " [tweet_id=" + row.id + "];\n");
      };
      send("}\n");
    }

Niestety, całego grafu (tzn. bez opcji *limit*) nie można wyrenderować:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/circo/sun' > nosql-tweets.gv
    circo -Tpng -Onosql-tweets nosql-tweets.gv
    circo: graph is too large for cairo-renderer bitmaps. Scaling by 0.0256786 to fit
    circo: failure to create cairo surface: out of memory
    Segmentation fault (core dumped)

Jak odfiltrować dane?
Jeśli zmodyfikujemy widok,
zob. [Retrieve the top N tags](http://wiki.apache.org/couchdb/View_Snippets#Retrieve_the_top_N_tags):

    :::javascript circo.js
    ddoc.views.graph = {
      map: function(doc) {
        var retweeted = /\b(via|RT)\s*(@\w+)/ig;
        var match = retweeted.exec(doc.text);
        if (match != null) {
          emit([match[2].toLowerCase(), doc.screen_name], null);
        };
      },
      reduce: function(keys, values, rereduce) {
        var retwitters = [];

        if (!rereduce) {
          keys.map(function(key) {
              retwitters.push(key[0][1]);
          });
        } else {
          values.map(function(o) {
              //if (value.retwitters.length < 32) {
              retwitters.push(o.retwitters[0]);
              //};
          });
        };
        return retwitters;
      }
    }

To teraz, niestety (**sprawdzić!**), CouchDB wycina najczęściej cytowanych autorów:

    :::json
    {"key":["@addthis"],"value":null},
    {"key":["@dhh"],"value":null},
    {"key":["@hipsterhacker"],"value":null},
    {"key":["@jchris"],"value":null},
    {"key":["@mongodb"],"value":null},
    {"key":["@railsforzombies"],"value":null},
    {"key":["@rbates"],"value":null},
    {"key":["@ryah"],"value":null},
    {"key":["@sstephenson"],"value":null},
    {"key":["@techcrunch"],"value":null},
    {"key":["@vmische"],"value":null},

Czyli mamy znowu problem! Najwyższa pora przejść na MongoDB!
Albo, raz jeszcze przemyśleć, o co tak naprawdę nam chodzi.


## Strona HTML – szablony Mustache

Napiszemy funkcję listową pod ten widok:

    :::javascript tweets.js
    var couchapp = require('couchapp')
      , path = require('path')
      , fs = require('fs');
    ddoc = {
      _id: '_design/test'
      , views: {}
      , lists: {}
      , shows: {}
      , templates: {}
    }
    module.exports = ddoc;

    ddoc.views.cloud = {
      map: function(doc) {
        var retweeted = /\b(via|RT)\s*(@\w+)/ig;
        var match = retweeted.exec(doc.text);
        if (match != null) {
          emit([match[2].toLowerCase(), doc.screen_name], null);
        };
      }
    }

Dokument generowany przez funkcję listową będzie się składał
z akapitów:

    :::html
    <p>RT <b>@_brooklynemm</b> <a href="tweet_id">StephSideris</a></p>

Funkcja listowa generująca ten kod:

    :::javascript tweets.js
    ddoc.lists.tweets = function(head, req) {
      var row;
      start({
        "headers": {
          "Content-Type": "text/html"
        }
      });
      while(row = getRow()) {
        // send(JSON.stringify(row));
        send("<p>RT <b>" + row.key[0] + "</b> <a href='http://localhost:5984/nosql-slimmed/" + row.id +"'>" + row.key[1] + "</a></p>\n");
      };
    }

Po wejściu na stronę:

    http://localhost:5984/nosql-slimmed/_design/test/_list/all/cloud?limit=20

powinniśmy zobaczyć rezultat dotychczasowego kodowania.


### Mustache

Zaczynamy od prostego arkusza CSS:

    :::css attachments/application.css
    html {
      background-color: #7812B7; /* full of mysteries */
    }
    body {
      width: 600px;
      margin: 1em auto;
      padding: 1em;
      color: #444;
    }

Następnie piszemy (też prosty) szablon Mustache:

    :::html templates/tweet.html.mustache
    <!doctype html>
    <html lang=pl>
      <head>
        <meta charset=utf-8>
        <link rel="stylesheet" href="/nosql-slimmed/_design/test/application.css">
        <title>Recent Tweets</title>
      </head>
    <body>
      {{#rows}}
      <p>RT <b>{{author}}</b> <a href='http://localhost:5984/nosql-slimmed/{{id}}'>{{tweeterer}}</a></p>
      {{/rows}}
    </body>
    </html>

Na koniec, zmieniona, funkcja listowa do powyższego szablonu:

    :::javascript tweets.js
    ddoc.lists.tweets = function(head, req) {
      var mustache = require('templates/mustache');
      var template = this.templates['tweet.html'];

      var row;
      var rows = [];
      start({
        "headers": {
          "Content-Type": "text/html"
        }
      });
      while(row = getRow()) {
        // {"id":"47402480702730240","key":["@_brooklynemm","StephSideris"]
        rows.push({id: row["id"], author: row.key[0] , tweeterer: row.key[1]});
      };

      var view = {rows: rows};
      var html = mustache.to_html(template, view);
      return html;
    }

    ddoc.templates.mustache = fs.readFileSync('templates/mustache.js', 'UTF-8');
    ddoc.templates['tweet.html'] = fs.readFileSync('templates/tweet.html.mustache', 'UTF-8');


    couchapp.loadAttachments(ddoc, path.join(__dirname, 'attachments'));

Sprawdzamy jak to działa:

    couchapp push tweets.js http://localhost:5984/nosql-slimmed
    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?limit=2'

Albo wchodzimy na stronę:

    http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?limit=16
    http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?limit=16&skip=100
    http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?limit=8&startkey=["@dhh"]
    http://localhost:5984/nosql-slimmed/_design/test/_list/tweets/cloud?startkey=["@dhh"]&endkey=["@dhh",{}]

Co zostało jeszcze do zrobienia?


## Programowanie po stronie klienta

TODO: umieścić na stronie z mustache linki + ajax
albo generuj kod dla Graphviz.


# Trochę niesklasyfikowanych linków

* [CommonJS modules in CouchDB](http://caolanmcmahon.com/posts/commonjs_modules_in_couchdb#/posts/commonjs_modules_in_couchdb)
* [View Snippets](http://wiki.apache.org/couchdb/View_Snippets)
* [CouchDB: Using List Functions to sort Map/Reduce-Results by Value](http://geekiriki.blogspot.com/2010/08/couchdb-using-list-functions-to-sort.html)
* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)

Na koniec coś pięknego?

* [Beauty of Code](http://beauty-of-code.de/2010/07/complex-joins-in-couchdb/)
