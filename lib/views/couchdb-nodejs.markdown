#### {% title "Dostęp do CouchDB via NodeJS" %}

Link do strony [NodeJS][], do strony z [API Node.JS][]
oraz do *open source eBook for Node.JS* pt. [Mastering Node][]
(zawiera opis modułów *commonjs*).

Warto też zajrzeć na stronę [NodeJS Knockout](http://nodeknockout.com/)
oraz [nodeknockout](http://nodeknockout.posterous.com/):

* [Introduction to npm](http://nodeknockout.posterous.com/countdown-to-knockout-post-3-introduction-to)
* [Debugging with node-inspector](http://nodeknockout.posterous.com/countdown-to-knockout-post-4-debugging-with-n)
* [Deploying to Heroku](http://nodeknockout.posterous.com/countdown-to-knockout-post-8-deploying-to-her)
* [WebSockets everywhere with Socket.io](http://nodeknockout.posterous.com/countdown-to-knockout-post-9-websockets-every)


## CouchDB + NodeJS

Korzystamy z języka Javascript zamiast programu *curl*:
[Countdown to Knockout: Post 14 - Using CouchDB with node.js](http://nodeknockout.posterous.com/countdown-to-knockout-post-14-using-couchdb-w).

{%= image_tag "/images/thingler-t.jpg", :alt => "[Thingler]" %}


## Przykłady + prosta aplikacja korzystająca z WebSockets.

Przykład z screencastu [Meet Node.js](http://peepcode.com/products/nodejs-i)
(repozytorium **/hello/nodejs**).


[nodejs]: http://nodejs.org/ "Node.JS"
[api node.js]: http://nodejs.org/api.html "nodejs(1) man page"
[mastering node]: http://github.com/visionmedia/masteringnode "Mastering Node"


# Czym jest NodeJS?

[NodeJS](http://nodejs.org/) to *evented I/O for V8 Javascript*.

*Evented I/O* oznacza, że programy dla *node* oparte są na zdarzeniach,
co oznacza że kod programu jest wykonywany asynchronicznie.
Co to praktycznie oznacza przedstawił Rick Olson w
[Asynchronous Coding For My Tiny Ruby Brain](http://github.com/technoweenie/pdxjs-twitter-node).

[V8](http://code.google.com/p/v8/) jest silnikiem Javascript napisanym
przez Google.  V8 jest implementacją ECMAScript-262, wydanie
trzecie. Z V8 korzysta na przykład przeglądarka *Google Chrome*.

W programach dla *node*  możemy korzystać z metod zaimplementowanych w
modułach Javascript i dystrybuowanych z Node.JS. Node korzysta
z [CommonJS module system](http://wiki.commonjs.org/wiki/Modules/1.1).

Oto lista modułów wymienionych na stronie manuala *node(1)*.

**TODO**: Uaktualnić listę do ostatniej wersji NodeJS:

* `sys` — system module
* `events`
* `child_process`
* `fs` – file system module
* `http`
* `multipart`
* `tcp`
* `dns`
* `assert`
* `path`
* `url`
* `querystring`
* `repl` – read-eval-print-loop

Po tym krótkim wprowadzeniu przykład implementujący żądanie:

    curl -X GET http://127.0.0.1:5984/_all_dbs

Poniższy kod:

    :::javascript
    var sys = require('sys'),
       http = require('http');

    var client = http.createClient(5984, "127.0.0.1");
    var request = client.request("GET", "/_all_dbs");

    request.addListener('response', function (response) {
      sys.puts("** status: " + response.statusCode);
      sys.puts("** headers: " + JSON.stringify(response.headers));

      response.setBodyEncoding("utf8");
      response.addListener("data", function(chunk) {
        sys.puts(chunk);
      });
    });
    request.close();

po wpisaniu do pliku o nazwie *get_all_dbs.js* uruchamiamy tak:

    node get_all_dbs.js

I jeszcze jeden, nieco bardziej skomplikowany:

    curl -X GET  http://127.0.0.1:5984/_uuids?count=2

Kod: wystarczy tylko, w kodzie powyżej podmienić wiersz z definicją
zmiennej *request* na:

    :::javascript
    var request = client.request("GET", "/_uuids?count=2");

Jeszcze jeden przykład z *Basic Authorization*:

    :::javascript
    var sys = require('sys'),
       http = require('http');
    var client = http.createClient(5984, "127.0.0.1");
    var request = client.request("PUT", "/my-db", {"Authorization": "Basic d2J6eWw6c2VrcmV0"});
    request.close();

Musimy autoryzować się tak jak to zrobiono powyżej,
bo takie proste podejście nie działa:

    :::javascript
    var client = http.createClient(5984, "wbzyl:sekret@127.0.0.1");

Aha, napis `d2J6eWw6c2VrcmV0`, to

    :::ruby
    Base64.encode64 'wbzyl:sekret'

