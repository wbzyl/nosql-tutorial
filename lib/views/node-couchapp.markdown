#### {% title "NodeJS i moduł node.couchapp.js" %}

Wpisując kod Javascript w postaci napisu, korzystając z programu
curl do zapisywania takich napisów – takie podejście ma tylko jedną
zaletę, a poza tym same wady.
Jedyną zaletą takiego podejścia jest to, że każdy potrafi to zrobić.

Programiści wolą postępować inaczej.
Poniżej, do zapisywania w bazie funkcji show,
a później też innych funkcji, skorzystamy z modułu
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

    couchapp push aye.js http://User:Pass@localhost:4000/ls
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
