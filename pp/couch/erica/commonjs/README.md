# Erica & [CommonJS Modules / 1.1.1] [commonjs]

Zaczynamy od wygenerowania aplikacji
i jej [konfiguracji](http://couchapp.org/page/couchapp-config):

```sh
erica create-app appid=commonjs
```

Podmienimy zawartość dwóch plików: *.couchapprc*:

```json
{
  "env" : {
    "default" : {
      "db" : "http://localhost:5984/commonjs"
    },
    "production" : {
      "db" : "http://admin:password@couch.inf.ug.edu.pl/commonjs"
    }
  }
}
```

oraz *_id*:

```
_design/default
```

i dodajemy cztery dokumenty, *{1,2,3,4}.json* do katalogu `_docs/`:

```json
{"_id":"1","quote":"Mężczyźni wolą kobiety ładne niż mądre…","tags":["ludzie","kobiety","mężczyźni"]}
{"_id":"2","quote":"Podrzuć własne marzenia swoim wrogom….","tags":["ludzie","myślenie","marzenia"]}
{"_id":"3","quote":"By dojść do źródła, trzeba płynąć pod prąd.","tags":["źródło"]}
{"_id":"4","quote":"Chociaż krowie dasz kakao, nie wydoisz czekolady.","tags":["krowa","doić"]}
```

Na tym kończymy konfigurację. Wrzucamy aplikację na CouchDB:

```sh
erica -v push
```


## CommonJS Modules

[Moduł] [commonjs] *math.js* zapisujemy w katalogu `lib/`:

```js
exports.add = function() {
  var sum = 0, i = 0, args = arguments, l = args.length;
  while (i < l) {
    sum += args[i++];
  }
  return sum;
};
```

Na konsoli *node* sprawdzamy moduł:

```js
var math = require('./math');
math.add(1,2,3,4);
```

Jeśli nie ma błędów, przechodzimy dalej.


## Funkcje *show*

Zaczynamy od funkcji *shows/sum.js* korzystającej z modułu *math.js*:

```js
function(doc, req) {
  var math = require('lib/math'); // ścieżka względem _design/default
  log(math.add.toString());

  return "<p>1 + 2 + 3 + 4 = " + math.add(1,2,3,4) + "</p>";
}
```

Teraz wykonujemy `erica push` i wynik do obejrzenia powinien być tutaj:

```
http://localhost:5984/commonjs/_design/default/_show/sum
```

Jednocześnie podglądamy co jest zapisywane w logach:

```
tail -f ~/.data/var/log/couchdb/couch.log
```

Jeśli na konsoli widzimy żródło funkcji *add*
i funkcja *add* wylicza 10, oznacza to że wszystko działa.


### Szablony Mustache

Teraz czas na wąsate szablony.

Klonujemy repozytorium:

```
git clone git://github.com/janl/mustache.js.git
```

Sprawdzamy na konsoli *node*, czy szablony działają:

```js
var Mustache = require('./mustache.js/mustache.js');
Mustache
    { name: 'mustache.js',
      version: '0.7.2',
      tags: [ '{{', '}}' ],
      Scanner: [Function: Scanner],
      Context: { [Function: Context] make: [Function] },
      Writer: [Function: Writer],
      parse: [Function: parseTemplate],
      escape: [Function: escapeHtml],
      clearCache: [Function],
      compile: [Function],
      compilePartial: [Function],
      compileTokens: [Function],
      render: [Function],
      to_html: [Function] }

var view = {
  title: "Joe",
  calc: function () {
     return 2 + 4;
  }
};

var output = Mustache.render("{{title}} spends {{calc}}", view);
output;

var compiledTemplate = Mustache.compile("{{title}} spends {{calc}}", view);
var output = compiledTemplate(view);
output;

```

Jeśli szablon i skompilowany szablon zwracają napis:

```
'Joe spends 6'
```

to oznaczo to że wszystkie pliki są na swoich miejscach.

Jeśli coś nie działa, to sprawdzamy logi CouchDB.

Jeśli wszystko jest OK, to kopiujemy plik *mustache.js*
do katalogu *lib/*:

```
cp .../mustache.js lib/mustache.js
```

### Szablony HTML

Zaczynamy od zapisania w katalogu *templates* pliku *quotation.html.mustache*:

```html
<!doctype html>
<html lang=pl>
  <head>
    <meta charset=utf-8>
    <link rel="stylesheet" href="/commonjs/_design/default/application.css">
    <title>Cytaty Stanisława J. Leca i Hugo D. Steinhausa</title>
  </head>
<body>
  <p>{{ quotation }}</p>
  <p><small>Powered by CouchDB (v1.3.0) &amp; Mustache.js (v0.7.2)</small></p>
</body>
</html>
```

Do katalogu *_attachments* dodajemy plik *application.js* o zawartości:

```css
/* Vitamin C */
body { margin: 4em; background-color: #FF9900; }
```

Na koniec tworzymy funkcję *shows/quotation.js*:

```js
function(doc, req) {
  log(doc.quote);

  var Mustache = require('lib/mustache');
  var template = this.templates['quotation.html']; // this == design document
  return Mustache.render(template, doc);
}
```

Wykonujemy `erica push` i sprawdzamy jak to działa (logi, przeglądarka):

```
http://localhost:5984/commonjs/_design/default/_show/quotation/1
http://localhost:5984/commonjs/_design/default/_show/quotation/2
```

### Kompilowane szablony HTML

W funkcji *shows/quotation.js* możemy uzyć skopilowanego szablonu:

```js
function(doc, req) {
  log(doc.quote);

  var Mustache = require('lib/mustache');
  var template = this.templates['quotation.html']; // this == design document
  var compiledTemplate = Mustache.compile(template); // funkcja

  return compiledTemplate(doc);
}



## TODO: Funkcje *list*


<!-- links -->

[commonjs]: <http://wiki.commonjs.org/wiki/Modules/1.1.1> "CommonJS Modules / 1.1.1"
[node modules]: <http://nodejs.org/docs/latest/api/modules.html> "Node.js Modules"
