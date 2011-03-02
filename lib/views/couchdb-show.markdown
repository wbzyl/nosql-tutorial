#### {% title "Funkcje Show" %}

<blockquote>
 {%= image_tag "/images/show_functions.jpg", :alt => "[Show Functions]" %}
</blockquote>

Do czego mogą się przydać [show functions](http://guide.couchdb.org/draft/show.html):
„There is one important use case that JSON documents don’t cover:
building plain old HTML web pages.”, nie zapominając o innych formatach
danych, takich jak XML, CSV, CSS, JSON…
Innymi słowy – funkcji show będziemy używać do przekształcenia dokumentów
do innych formatu – zazwyczaj do HTML.

W przykładach poniżej skorzystamy z bazy *ls* zawierającej
kilka aforyzmów Stanisława J. Leca (1909–1966)
oraz Hugo D. Steinhausa (1887–1972).
Aforyzmy te skopiowałem z wikipedi
[stąd](http://pl.wikiquote.org/wiki/Stanis%C5%82aw_Jerzy_Lec)
i [stąd](http://pl.wikiquote.org/wiki/Hugo_Steinhaus).

Format przykładowego aforyzmu umieszczonego w bazie:

    :::json
    {
      "_id": "1",
      "created_at": [2010, 0, 1],
      "quotation": "Szerzenie niewiedzy o wszechświecie \
                    musi być także naukowo opracowane.",
      "tags": ["wiedza", "nauka", "wszechświat"]
    }

Tworzymy bazę *ls*, tak:

    curl -X PUT  http://localhost:4000/ls

chyba że, baza jest zabezpieczona hasłem, wtedy polecenie powinno być takie:

    curl -X PUT  http://Admin:Pass@localhost:4000/ls

Następnie wrzucamy do hurtem do bazy wszystkie cytaty
({%= link_to "link do pliku *ls.json* z wszystkimi cytatatami", "/doc/json/ls.json" %}):

    curl -X POST -H "Content-Type: application/json" \
      http://localhost:4000/ls/_bulk_docs -d @ls.json


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

     curl -X PUT http://localhost:4000/ls/_design/default \
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

    http://localhost:4000/ls/_design/default/_show/quotation/4

zobaczymy sformatowany przez funkcję *quotation* czwarty cytat:

Można też pobrać wersję HTML cytatu za pomocą programu *curl*:

    curl -v http://localhost:4000/ls/_design/default/_show/quotation/4

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

     curl -X PUT http://localhost:4000/ls/_design/default \
       -H "Content-Type: application/json" -d @aye.json

Żądanie z parametrem:

    curl http://localhost:4000/ls/_design/default/_show/aye/1?q=Captain

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

     curl -X PUT http://localhost:4000/ls/_design/default \
       -H "Content-Type: application/json" -d @maye.json

Zwykłe żadanie, z domyślnym nagłówkiem *Accept*, oraz z nagłówkiem *Accept: application/xml*

    curl -v http://localhost:4000/ls/_design/default/_show/aye/1?q=Captain
    curl -v -H 'Accept: application/xml' http://localhost:4000/ls/_design/default/_show/aye/1?q=Captain

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
* `info` - same structure as returned by *http://localhost:5984/db_name/*
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
    var couchapp = require('couchapp');

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

    couchapp push aye.js http://wbzyl:sekret@localhost:4000/ls
    Preparing.
    Serializing.
    PUT http://wbzyl:******@localhost:4000/ls/_design/default
    Finished push. 2-7068bcbdcec03650a8dee623e5afe1a1

Powtarzamy żądanie z parametrem::

    curl -v http://localhost:4000/ls/_design/default/_show/aye/1?q=Captain


**Argumenty za a nawet przeciw:**
Pisanie funkcji *shows* za bardzo przypomina programowanie CGI,
przez co tutaj rozumiem wpisywanie kodu HTML w kodzie Javascript.
Przydałyby się jakieś szablony.


<blockquote>
 {%= image_tag "/images/mustache.jpg", :alt => "[Wąsy]" %}
</blockquote>

## Szablony Mustache

Na początek cytat
z [Generating HTML from Javascript shows and lists](http://wiki.apache.org/couchdb/Generating%20HTML%20from%20Javascript%20shows%20and%20lists):<br>
**You should avoid having code in your template.**

Będziemy potrzebować modułu *mustache.js* w wersji
[commonjs](https://github.com/janl/mustache.js/) (na tej stronie
znajdziemy też kilka przykładów).

Klonujemy repozytorium *mustache.js*, instalujemy gem z którego korzysta
program rake i na koniec generujemy moduł:

    gem install rspec -v 1.3.0
    git clone git://github.com/janl/mustache.js.git
    cd mustache.js
    rake commonjs

Wygenerowany moduł *mustache.js* znajdziemy w katalogu *lib*.

Wąsate szablony możemy poćwiczyć na stronie
[{{ mustache }}](http://mustache.github.com/#demo).

To co zamierzam zrobić przedstawię w postaci
diagramu *filesystem mapping* (co to może oznaczać?)
dla design document *_design/default*:

    /_design/default
    .
    |-- _attachments
    |   `-- application.css    // content-type set to text/css
    `-- templates
        |-- mustache           // string mustache.js
        `-- quotation.html     // string quotation.html.mustache

Plik z wąsatym szablonem *quotation.html.mustache*:

    :::html
    <!doctype html>
    <html lang=pl>
      <head>
        <meta charset=utf-8>
        <link rel="stylesheet" href="/ls/_design/default/application.css">
        <title>Cytaty Stanisława J. Leca &  Hugo D. Steinhausa</title>
      </head>
    <body>
      <p>{{ quotation }}</p>
    </body>
    </html>

Na koniec piszemy plik *ls.js* dla programu *couchapp*:

    :::javascript ls.js
    var couchapp = require('couchapp')
      , path = require('path')
      , fs = require('fs');

    ddoc = {
        _id: '_design/default'
      , views: {}
      , lists: {}
      , shows: {}
      , templates: {}
    }
    module.exports = ddoc;

    // funkcja show korzystająca z wąsatego szablonu
    ddoc.shows.quotation = function(doc, req) {
      var mustache = require('templates/mustache');
      /* this == design document (JSON) zawierający tę funkcję */
      var template = this.templates['quotation.html'];
      var html = mustache.to_html(template, {quotation: doc.quotation});
      return html;
    }

    ddoc.templates.mustache = fs.readFileSync('templates/mustache.js', 'UTF-8');
    ddoc.templates['quotation.html'] = fs.readFileSync('templates/quotation.html.mustache', 'UTF-8');

    couchapp.loadAttachments(ddoc, path.join(__dirname, '_attachments'));

I zapisujemy rzeczy, które umieściliśmy w powyższym pliku w bazie *ls*:

    couchapp push ls.js http://wbzyl:sekret@localhost:4000/ls

Na deser oglądamy jak to działa, tak:

    curl -I http://localhost:4000/ls/_design/default/_show/quotation/1

albo w przeglądarce:

    http://localhost:4000/ls/_design/default/_show/quotation/1

Dla porządku (jakiego porządku?), powinnismy skorzystać z jakiegoś
modułu dla NodeJS, aby zapisać w bazie cytaty.

W tym celu skorzystamy z modułu [couch-client](https://github.com/creationix/couch-client).

Po sklonowaniu repozytorium *couch-client*, wymieniamy *invalid*
plik *package.json* na *valid one*:

    :::json
    { "name": "couch-client"
    , "description": "A Simple, Fast, and Flexible CouchDB Client"
    , "tags": ["couchdb","http","database","nosql"]
    , "version": "0.0.3"
    , "author": "Tim Caswell <tim@creationix.com>"
    , "engines": ["node >= 0.2.0"]
    , "main" : "lib/couch-client"
    , "directories": { "lib": "lib" }
    , "modules": { "index": "./lib/couch-client.js" }
    }

Następnie instalujemy sam moduł, wykonując poniższe polecenie
w głównym katalogu repozytorium:

    npm link .

Do umieszczenia cytatów w bazie wykorzystamy poniższy skrypt:

    :::javascript populate.js
    var cc = require('couch-client')('http://localhost:4000/ls')
    , fs = require('fs');
    var text = fs.readFileSync('ls.json', 'UTF-8')
    // console.log(JSON.parse(text));
    cc.request("POST", cc.uri.pathname + "/_bulk_docs", JSON.parse(text), function (err, results) {
        if (err) throw err;
        console.log("saved %s", JSON.stringify(results));
    });

Dokumenty zapisujemy hurtem w bazie wykonując na konsoli polecenie:

    node populate


## Linki

[main.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/)
(plik *main.js* powstaje ze sklejenia wszystkich plików w tym katalogu;
najciekawsze rzeczy są w pliku *render.js*, *views.js*).

Dużo przykładów znajdziemy w źródłach CouchDB w katalogu *share/www/script/test* –
pliki *show_documents.js*, *list_views.js*.
