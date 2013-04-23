# Erica

[CommonJS Modules / 1.1.1] [commonjs]:

```sh
erica create-app appid=commonjs
```

[Konfiguracja](http://couchapp.org/page/couchapp-config), *.couchapprc*:

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

*_id*:

```
_design/default
```

Dodajemy cztery dokumenty do katalogu `_docs`:

```sh
erica -v push commonjs
```

## CommonJs Modules

[Module] [commonjs] `lib/math.js`

```js
exports.add = function() {
    var sum = 0, i = 0, args = arguments, l = args.length;
    while (i < l) {
        sum += args[i++];
    }
    return sum;
};
```

[Module] [node modules] `lib/circle.js`:

```js
var PI = Math.PI;

exports.area = function (r) {
  return PI * r * r;
};
exports.circumference = function (r) {
  return 2 * PI * r;
};
```

Przykład użycia, na konsoli *node*:

```js
var math = require('./math.js');
var circle = require('./circle.js');

math.add(1,2,3,4);
circle.area(4);
```

## Funkcje *show*

*shows/sum.js*:

```js
function(doc, req) {
  var math = require('lib/math');
  log(math.add.toString());

  return "<h3>sum_1^4 i = ?</h3>";
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

```
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
output
//=> 'Joe spends 6'
```
Jeśli szablony działają, to kopiujemy plik *mustache.js*
do katalogu *lib*:

```
cp .../mustache.js lib/mustache.js
```

Dodajemy następną funkcję *shows/info.js*:

```js
function(doc, req) {
  var Mustache = require('lib/mustache');
  var name = Mustache.name;
  var version = Mustache.version;

  log(name + ": ", + version); // szukamy wierszy zawierających ' Log :: '

  return "<h3>read module: " + name + ", version: " + version + "</h3>";
}
```
i wykonujemy `erica push` i oglądamy wyniki w przeglądarce:

```
http://localhost:5984/commonjs/_design/default/_show/sum
```

Jeśli coś nie działa, to sprawdzamy logi CouchDB.

Jeśli wszystko działa to zabieramy się za szablony.

Zaczynamy od zapisania w katalogu *templates* pliku *quotation.html.mustache*
o zawartości:

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

W katalogu *_attachments* dodajemy plik *application.js*
o zawartości:

```css
/* Vitamin C */
body { margin: 4em; background-color: #FF9900; }

```

Na koniec dodajemy funkcję *shows/quotation.js*:

```js
function(doc, req) {
  var Mustache = require('lib/mustache');
  // this == /commonjs/_design/default
  var template = this.templates['quotation.html'];
  log("template:\n" + template);

  var html = Mustache.to_html(template, {quotation: doc.quotation});
  return html;
}
```

## TODO: Funkcje *list*


<!-- links -->

[commonjs]: <http://wiki.commonjs.org/wiki/Modules/1.1.1> "CommonJS Modules / 1.1.1"
[node modules]: <http://nodejs.org/docs/latest/api/modules.html> "Node.js Modules"

<!--
  var html = mustache.to_html(template, {quotation: doc.quotation});
  return html;
-->
