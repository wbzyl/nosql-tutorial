#### {% title "Funkcje *Show*" %}

Jeśli jeszcze tego nie zrobiliśmy, to tworzymy bazę *lec*
i dodajemy do niej dokumenty z pliku *lec.json*:

    curl -X PUT  http://127.0.0.1:4000/lec
    curl -X POST -H "Content-Type: application/json" \
      http://127.0.0.1:4000/lec/_bulk_docs -d @lec.json

(Link do pliku {%= link_to "lec.json", "/doc/json/lec.json" %}.)

Funkcję show wpisujemy w obiekcie JSON według wzoru:

    :::json
    {
      "shows" : {
        "quotation" : "function(doc, req) { return '<p>' + doc.quotation + '</p>'; }" }
    }

Więcej szczegółów o [Show Functions](http://guide.couchdb.org/draft/show.html).

Zapisujemy powyższy obiekt JSON w pliku *guotation.json*
i umieszczmy go w bazie *lec* z *\_id* równym **_design/default**:

     curl -X PUT http://localhost:4000/lec/_design/default \
       -H "Content-Type: application/json" -d @quotation.json

Teraz po wejściu na stronę:

    http://localhost:4000/lec/_design/default/_show/quotation/4

widzimy sformatowany przez funkcję *quotation* cytat o *_id* równym 4.

Możemy też użyć programu *curl* zamiast przeglądarki:

    curl http://localhost:4000/lec/_design/default/_show/quotation/4


## Korzystamy z *couch_docs*

Wpisywanie kodu Javascript w postaci napisu w pliku JSON to nie jest
to (dlaczego?). Unikniemy tego stosując techniki „filesystem mapping”.
Gem *couch_docs* implementuje tę technikę. 

Tworzymy taki *filesystem mapping*:

    _design/
    `-- default
        |-- shows
            `-- quotation.js

I takiego pliku *quotation.sj*:

    :::javascript
    function(doc, req) { 
      return '<p>' + doc.quotation + '</p>'; 
    }

Zanim skorzystamy z udogodnień *couch_docs*, przygotujemy plik *Gemfile*:

    :::ruby
    source 'http://rubygems.org'
    gem 'rake'
    gem 'rack'
    gem 'couchrest'
    gem 'couch_docs'

Następnie instalujemy gemy:

    bundle install --path=$HOME/.gems

Na koniec tworzymy taki plik *Rakefile* (a może tak skorzystać *Thor*?).

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


## Za & przeciw

Pisanie funkcji *shows* za bardzo przypomina programowanie CGI,
przez co tutaj rozumiem wpisywanie kodu HTML w kodzie Javascript.
Przydałyby się jakieś szablony.

Poza tym idea *shows* jest OK?


## Korzystamy z szablonów Mustache

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



### Przekazywanie parametrów do *shows*

Zobacz [Query Parameters](http://books.couchdb.org/relax/design-documents/shows)
oraz [main.js](http://svn.apache.org/viewvc/couchdb/trunk/share/server/)
(plik *main.js* powstaje ze sklejenia wszystkich plików w tym katalogu;
najciekawsze rzeczy są w pliku *render.js*, *views.js*).

Opis obiektów JSON *Request* oraz *Response* znajdziemy na CouchDB Wiki
[External Processes](http://wiki.apache.org/couchdb/ExternalProcesses).

Dla przykładu, do takiej funkcji *shows*:

    :::javascript
    {
      "shows" : {
        "aye" : "function(doc, req) {
           return '<h2>Aye aye: ' + req.query['q'] + '</h2><p>' + doc.body + '</p>';
        }"
      }
    }

przekazujemy parametr **q** w żądaniu tak:

    http://localhost:4000/lec/_design/shows/_show/aye/1?q=Captain
    => Aye aye, Captain
       Szerzenie niewiedzy o wszechświecie musi być także naukowo opracowane.


## Więcej przykładów

W źródłach CouchDB w katalogu *share/www/script/test* znajdziemy dużo przykładów:

* show_documents.js
* list_views.js
* …???

Zobacz też:

* [NOSQL Databases for Web CRUD (CouchDB) - Shows/Views](http://java.dzone.com/articles/nosql-databases-web-crud)
