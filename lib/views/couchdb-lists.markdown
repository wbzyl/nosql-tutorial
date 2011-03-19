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
        "user_mentions":[{"indices":[0,13],"name":"Justin Bieber","screen_name":"justinbieber","id":27260086,"id_str":"27260086"}],
        "hashtags":[]},
      "screen_name":"eliyahhhxD",
      "lang":"en",
      "created_at":"Wed Mar 09 20:11:30 +0000 2011",
      "created_on":[2011,3,9,20,11,30]}
    }

Prosty przykład funkcji listowej znajdziemy
na Wiki, [Formatting with Show and List](http://wiki.apache.org/couchdb/Formatting_with_Show_and_List).
Użyjemy jej w kodzie poniżej.

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


## Zmienne head, req i row

Jeśli do kodu funkcji *all* dopiszemy

    log(head); log(req); log(row);

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

    {
      "id":"47402480702730240",
      "key": ["@_brooklynemm","StephSideris"],
      "value": "RT @_brooklynemm: Billlllin up Thursday with @_ashleymariee_ & @StephSideris & Cassandra Larosa &lt;3"
    }

To co znajdziemy w logach zależy od zapytania. Jeśli je wymienimy na:

    curl 'http://localhost:5984/nosql-slimmed/_design/test/_list/all/sun?group=true'

to *row*:

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

To będzie długi rozdział.

Zależność między: list a view – jeden do wielu; ale w przykładach ponizej będziemy
pisać funkcję list pod konkretny widok. Dlatego pisanie kodu będziemy
zawsze zaczynać od widoku.

Przykłady:

* sortowanie
* filtrowanie: opcje zapytań *cutoff=3* – cytowane częściej niż trzy razy
* szablony mustache
* plain/text + kod programu dla circo (z pakietu Graphvix)


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

jak widac, nie działa zgodnie z oczekiwaniem.


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
często cytowani.

Bez funkcji listowych *quick & dirty solution* – korzystamy ze skryptu:

    :::shell-unix-generic check.sh
    #!/bin/bash
    curl http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\\[\"@$1\"\\]\&endkey=\\[\"@$1\",\\{\\}\\]\&reduce=false

w taki sposób:

    ./check dhh
    ./check mongodb

Czy są jakieś niespodzianki?


## Strona HTML – szablony Mustache

TODO: *application.css*, html5 boiler code

TODO: Graphviz output z szablonów Mustache


## Programowanie po stronie klienta

TODO: umieścić na stronie z mustache linki + ajax
albo generuj kod dla Graphviz: taki / inny


## Trochę niesklasyfikowanych linków

* [CommonJS modules in CouchDB](http://caolanmcmahon.com/posts/commonjs_modules_in_couchdb#/posts/commonjs_modules_in_couchdb)
* [View Snippets](http://wiki.apache.org/couchdb/View_Snippets)
* [CouchDB: Using List Functions to sort Map/Reduce-Results by Value](http://geekiriki.blogspot.com/2010/08/couchdb-using-list-functions-to-sort.html)
* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)

Na koniec coś pięknego?

* [Beauty of Code](http://beauty-of-code.de/2010/07/complex-joins-in-couchdb/)
