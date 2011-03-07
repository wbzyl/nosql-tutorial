#### {% title "Szablony Mustache w CouchDB" %}

## Szablony Mustache w CouchDB

<blockquote>
 {%= image_tag "/images/mustache.jpg", :alt => "[Wąsy]" %}
</blockquote>

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
        <title>Cytaty Stanisława J. Leca i Hugo D. Steinhausa</title>
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

    couchapp push ls.js http://User:Pass@localhost:4000/ls

Na deser oglądamy jak to działa, tak:

    curl -I http://localhost:4000/ls/_design/default/_show/quotation/1

albo w przeglądarce:

    http://localhost:4000/ls/_design/default/_show/quotation/1

Dla porządku (jakiego porządku?), powinnismy skorzystać z jakiegoś
modułu dla NodeJS, aby zapisać w bazie cytaty.

W tym celu skorzystamy z modułu [couch-client](https://github.com/creationix/couch-client).

Sam moduł instalujemy wykonując w głównym katalogu repozytorium polecenie:

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
