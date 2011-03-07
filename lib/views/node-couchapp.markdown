#### {% title "NodeJS i moduł node.couchapp.js" %}

Do tej pory, aby umieścić dokument w bazie używaliśmy
programu *curl*. W przypadku design documents, wymagało
to od nas uwagi przy zapisywaniu kodu Javascript
w napisach – trudno jest poprawnie wpisać zagnieżdżone napisy.

Ale takie podejście ma dużą zaletę – takie przykłady łatwo jest
przeklikać na terminal i uruchomić.
Jednak gdy sami mamy taki przykład przgotować, lepiej
jest skorzystać z metody która umożliwia wpisywanie
kodu bezpośrednio.

Poniżej opisuję jak to można zrobić korzystając z modułu
NodeJS [node.couchapp.js](https://github.com/mikeal/node.couchapp.js).
Wadą tego rozwiązania jest to, że wymaga umiejętności
programowania w Javascripcie.

Zaczynamy od instalacji modułu według wskazówek
z pliku [README](https://github.com/mikeal/node.couchapp.js/blob/master/README.md):

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


## Przykład użycia

Teraz wzorując się na przykładzie z *README.md* kodujemy przykład z *maye.json*:

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

Po wpisaniu powyższego kodu w pliku *aye.js*, zapisujemy funkcję show w bazie
(swoje dane uwierzytelniające wpisujemy tylko gdy zabezpieczyliśmy dostęp do CouchDB hasłem):

    couchapp push aye.js http://User:Pass@localhost:5984/ls
    Preparing.
    Serializing.
    PUT http://wbzyl:******@localhost:5984/ls/_design/default
    Finished push. 2-7068bcbdcec03650a8dee623e5afe1a1

Sprawdzamy, czy wszystkie polecenia wykonane zostały bez błędu:

    curl -v http://localhost:5984/ls/_design/default/_show/aye/1?q=Captain
