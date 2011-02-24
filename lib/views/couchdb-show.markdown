#### {% title "Funkcje *Show*" %}

<blockquote>
 {%= image_tag "/images/show_functions.jpg", :alt => "[Show Functions]" %}
</blockquote>

Do czego mogą się przydać [show functions](http://guide.couchdb.org/draft/show.html):
„There is one important use case that JSON documents don’t cover:
building plain old HTML web pages.”, nie zapominając o innych formatach
danych, takich jak XML, CSV, CSS, JSON…
Innymi słowy – funkcji show będziemy używać do przekształcenia dokumentów
do innych formatu – zazwyczaj do HTML.

W przykładach poniżej skorzystamy z bazy *lec*, która zawiera
osiem cytatów Stanisława J. Leca (1909–1966)
{%= link_to "lec.json", "/couch/show/lec.json" %}
({%= link_to "link do jsona z wszystkimi cytatatami", "/doc/json/lec.json" %}):

    :::json
    {
      "_id": "1",
      "created_at": [2010, 0, 1],
      "quotation": "Szerzenie niewiedzy o wszechświecie \
                    musi być także naukowo opracowane.",
      "tags": ["wiedza", "nauka", "wszechświat"]
    }

Tworzymy bazę *lec* i wrzucamy do niej hurtem wszystkie cytaty:

    curl -X PUT  http://User:Pass@127.0.0.1:4000/lec
    curl -X POST -H "Content-Type: application/json" \
      http://127.0.0.1:4000/lec/_bulk_docs -d @lec.json

*Uwaga:* W drugim poleceniu nie podajemy swoich danych.


## Przykład: HTML

Funkcje show musimy umieścić w polu *shows* (uwaga: liczbę mnoga)
w jakimś design document.

Oto prosty przykład:

    :::json quotation.json
    {
      "shows" : {
        "quotation" : "function(doc, req) { return '<p>' + doc.quotation + '</p>'; }" }
    }

Po zapisaniu kodu w pliku *quotation.json*, skorzystamy z programu *curl*
aby zapiszać kod w bazie:

     curl -X PUT http://User:Pass@localhost:4000/lec/_design/default \
       -H "Content-Type: application/json" -d @quotation.json

**Uwaga:**: kilka funkcji show wpisujemy w polu *shows* w taki sposób:

    :::json
    {
      "shows" : {
        "quotation" : "function(doc, req) { ... }",
        "tags" :      "function(doc, req) { ... }"
      }
    }

Teraz po wejściu na stronę:

    http://localhost:4000/lec/_design/default/_show/quotation/4

zobaczymy sformatowany przez funkcję *quotation* czwarty cytat:

Można też pobrać wersję HTML cytatu za pomocą programu *curl*:

    curl -v http://localhost:4000/lec/_design/default/_show/quotation/4

Przy okazji przyjrzyjmy się nagłówkom żądania i odpowiedzi.


## Bardziej skomplikowane funkcje show

Wysyłamy nagłówki:

    :::javascript
    function(doc, req) {
      return {
        body : '<foo>' + doc.quotation + '</foo>',
        headers : {
          "Content-Type" : "application/xml",
          "X-My-Own-Header": "you can set your own headers"
        }
      }
    }

Przekazujemy parametry do funkcji show:

    :::javascript aye.json
    {
      "shows" : {
        "aye" : "function(doc, req) {
           return 'Aye aye: ' + req.query['q'] + '. ' + doc.quotation;
        }"
      }
    }

W Futonie usuwamy dokument *_design/default* (dlaczego to robimy?),
następnie zapisujemy funkcję show *aye* w bazie:

     curl -X PUT http://User:Pass@localhost:4000/lec/_design/default \
       -H "Content-Type: application/json" -d @aye.json

Żądanie z parametrem:

    curl http://localhost:4000/lec/_design/default/_show/aye/1?q=Captain
    => Aye aye, Captain. Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.

Odpowiadanie na różne nagłówki *Content-Type* żądania.

    :::json maye.json
    {
      "shows" : {
        "aye" : "function(doc, req) {
           provides('html', function() {
             return '<h2>Aye aye: ' + req.query['q'] + '</h2><p>' + doc.quotation + '</p>';
           });
           provides('xml', function() {
             return '<aye><hej>Aye aye: ' + req.query['q'] + '</hej><you>' + doc.quotation + '</you></aye>';
           });
        }"
      }
    }

Tak jak poprzednio, zaczynamy od usunięcia w Futonie dokumentu *_design/default*,
dopiero potem, zapisujemy funkcję show *aye* w bazie:

     curl -X PUT http://User:Pass@localhost:4000/lec/_design/default \
       -H "Content-Type: application/json" -d @maye.json

Zwykłe żadanie, z domyślnym nagłówkiem *Accept*, oraz z nagłówkiem *Accept: application/xml*

    curl -v http://localhost:4000/lec/_design/default/_show/aye/1?q=Captain
    curl -v -H 'Accept: application/xml' http://localhost:4000/lec/_design/default/_show/aye/1?q=Captain

Pozostałe *mime types* wbudowane w CouchDB są zdefiniowane w pliku *main.js*:

    :::javascript ./share/server/main.js
    // Some default types ported from Ruby on Rails
    // Build list of Mime types for HTTP responses
    // http://www.iana.org/assignments/media-types/
    // http://dev.rubyonrails.org/svn/rails/trunk/actionpack/lib/action_controller/mime_types.rb

    registerType("all", "*/*");
    registerType("text", "text/plain; charset=utf-8", "txt");
    registerType("html", "text/html; charset=utf-8");
    registerType("xhtml", "application/xhtml+xml", "xhtml");
    registerType("xml", "application/xml", "text/xml", "application/x-xml");
    registerType("js", "text/javascript", "application/javascript", "application/x-javascript");
    registerType("css", "text/css");
    registerType("ics", "text/calendar");
    registerType("csv", "text/csv");
    registerType("rss", "application/rss+xml");
    registerType("atom", "application/atom+xml");
    registerType("yaml", "application/x-yaml", "text/yaml");
    // just like Rails
    registerType("multipart_form", "multipart/form-data");
    registerType("url_encoded_form", "application/x-www-form-urlencoded");
    // http://www.ietf.org/rfc/rfc4627.txt
    registerType("json", "application/json", "text/x-json");

Oczywiście możemy też rejestrować swoje typy mime.

### Obiekt *Request*

* `body` - raw post body
* `cookie` - cookie information passed on from mochiweb
* `form` - if the request’s *Content-Type* is
  *application/x-www-form-urlencoded*, a decoded version of the body
* `info` - same structure as returned by *http://127.0.0.1:5984/db_name/*
* `path` - any extra path information after routing to the external process
* `query` - decoded version of the query string parameters.
* `method` - HTTP request verb
* `userCtx` - Information about the User

### Obiekt *Response*

* `code` - HTTP response code (default is 200). Note that this must be a
  number and cannot be a string (no "")
* `headers` - an object with key-value pairs that specify HTTP headers
  to send to the client.
* `json` - an arbitrary JSON object to send the client. Automatically
  sets the Content-Type header to "application/json"
* `body` - an arbitrary CLOB to be sent to the client. *Content-Type*
  header defaults to *text/html*
* `base64` - arbitrary binary data for the response body, base64-encoded


Opis obiektów *Request* oraz *Response* przeklikałem z CouchDB Wiki
[External Processes](http://wiki.apache.org/couchdb/ExternalProcesses).

Zobacz też opis
[Querying Options/Parameters](http://wiki.apache.org/couchdb/HTTP_view_API#Querying_Options).


# Korzystamy z modułu NodeJS *node.couchapp.js*

Wpisywanie kodu Javascript w postaci napisu, dodawanie takiego napisu
do pliku JSON, jest jakimś nieporozumieniem programistycznym.

Jedyną zaletą takiego podejścia jest to, kązdy potrafi to zrobić.
Poniżej, do zapisywania w bazie funkcji show
(a później też funkcji list, filter…),  skorzystamy z modułu
NodeJS [node.couchapp.js](https://github.com/mikeal/node.couchapp.js)
Wadą tego rozwiązania jest to, że wymaga umiejętności
programowania w Javascripcie.

Moduł *node.couchapp.js* instalujemy, tak jak to opisano w pliku *README.md*:

    git clone git://github.com/mikeal/node.couchapp.js.git
    cd node.couchapp.js
    npm link .

Sprawdzamy instalację modułu próbując uruchomic program *couchapp*:

    → couchapp
    couchapp -- utility for creating couchapps
    Usage:
      couchapp <command> app.js http://localhost:5984/dbname
    Commands:
      push   : Push app once to server.
      sync   : Push app then watch local files for changes.
      boiler : Create a boiler project.

Teraz wzorując się na przykładzie z *README.md* kodujemy przykład
z *maye.json* opisany powyżej:

    :::javascript aye.js
    var couchapp = require('couchapp')
      , path = require('path');

    ddoc = {
        _id: '_design/default'
      , views: {}
      , lists: {}
      , shows: {}
    }

    module.exports = ddoc;

    ddoc.shows.aye = function(doc, req) {
      return {
        headers: { "Content-Type": "text/html" },
        body: "<h2>Aye aye: " + req.query["q"] + "</h2>\n<p>" + doc.quotation + "</p>\n"
      }
    }

Po wpisaniu powyższego kodu w pliku *aye.js*, zapisujemy funkcję show w bazie:

    couchapp push aye.js http://wbzyl:sekret@localhost:4000/lec
    Preparing.
    Serializing.
    PUT http://wbzyl:******@localhost:4000/lec/_design/default
    Finished push. 2-7068bcbdcec03650a8dee623e5afe1a1

Powtarzamy żądanie z parametrem::

    curl -v http://localhost:4000/lec/_design/default/_show/aye/1?q=Captain


**Argumenty za a nawet przeciw:**
Pisanie funkcji *shows* za bardzo przypomina programowanie CGI,
przez co tutaj rozumiem wpisywanie kodu HTML w kodzie Javascript.
Przydałyby się jakieś szablony.


## Szablony Mustache

TODO: link do dokumentacji. Szablony dust – podobne
Jakaś strona do ekperymentowania z Mustache
[demo](http://mustache.github.com/#demo)

Jakiś obrazek.

**TODO:** opisać przykład **couch/show2**.

Korzystamy z takiego *filesystem mapping*:

    _design/
    `-- default
        |-- shows
        |   `-- quotation.js
        `-- templates
            |-- mustache.js
            `-- quotation.html.js

Funkcja show korzystająca z szablonu Mustache:

    :::javascript quotation.js
    function(doc, req) {
        var mustache = require('templates/mustache');

        /* this == design document (JSON) zawierający tę funkcję */
        var template = this.templates["quotation.html"];
        var html = mustache.to_html(template, {quotation: doc.quotation});

        return html;
    }

**Uwaga:** plik *mustache.js* to „commonjs-compatible mustache.js module”.

Szablon mustache *quotation.js*:

    :::html
    <!doctype html>
    <html lang=pl>
      <head>
        <meta charset=utf-8>
        <link rel="stylesheet" href="/lec/_design/default/application.css">
        <title>Cytaty Stanisława J. Leca</title>
      </head>
    <body>
      <p>{{quotation}}</p>
    </body>
    </html>

Plik CSS jest załącznikiem. Dodałem go ręcznie w Futonie (**TODO**).



[main.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/)
(plik *main.js* powstaje ze sklejenia wszystkich plików w tym katalogu;
najciekawsze rzeczy są w pliku *render.js*, *views.js*).

Dużo przykładów znajdziemy w źródłach CouchDB w katalogu *share/www/script/test* –
pliki *show_documents.js*, *list_views.js*.



<!--

# TODO: nie skorzystamy z *couch_docs*

Unikniemy tego stosując technikę
o nazwie „filesystem mapping” (mapowania plików).

Takie *filesystem mapping* lepiej pokazuje strukturę JSON-ów:

    _design/
    `-- default
        |-- shows
            `-- quotation.js

gdzie *quotation.js* zawiera jakiś kod Javascript, na przykład:

    :::javascript
    function(doc, req) {
      return doc.quotation;
    }

Zanim nie skorzystamy z udogodnień *couch_docs*, przygotujemy plik *Gemfile*:

    :::ruby
    source 'http://rubygems.org'
    gem 'rake'
    gem 'rack'
    gem 'couchrest'
    gem 'couch_docs'

Następnie instalujemy gemy:

    bundle install --path=$HOME/.gems

Na koniec tworzymy taki plik *Rakefile* (a może tak skorzystać *Thora*?).

    :::ruby Rakefile
    require 'bundler'
    Bundler.setup

    require 'rake'
    require 'rack/mime'
    require 'couchrest'
    require 'couch_docs'

    require 'pp'

    Database = CouchRest.database!('http://127.0.0.1:4000/lec')

    desc "Upload application design documents"
    task :default => [:design] do
      puts "-"*80
      puts "Uploaded design documents into database, please check:",
           " * http://localhost:4000/lec/_design/default/_show/quotation/4"
    end

    desc "Upload design documents from _design/default"
    task :design do
      dir = CouchDocs::DesignDirectory.new('_design/default')
      doc = dir.to_hash
      doc.update('_id' => '_design/default', 'language' => 'javascript')

      rev = Database.get('_design/default')['_rev'] rescue nil
      doc.update({'_rev' => rev}) if rev
      #pp doc
      #pp doc['shows'].keys

      response = Database.save_doc(doc)
      pp response
    end

Teraz, aby przenieść zawartość plików Javascript do bazy wystarczy
wykonać polecenie:

    rake

-->
