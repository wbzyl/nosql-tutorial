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


## Ściąga z budowy obiektów Request & Response

Wygodnie jest mieć te informacje pod ręką.


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


## Linki

[main.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/)
(plik *main.js* powstaje ze sklejenia wszystkich plików w tym katalogu;
najciekawsze rzeczy są w pliku *render.js*, *views.js*).

Dużo przykładów znajdziemy w źródłach CouchDB w katalogu *share/www/script/test* –
pliki *show_documents.js*, *list_views.js*.
