# [Erica](https://github.com/benoitc/erica) & [CommonJS Modules / 1.1.1] [commonjs]

Zaczynamy od wygenerowania aplikacji
i zmiany jej [domyślnych ustawień](http://couchapp.org/page/couchapp-config):

```sh
erica create-app appid=commonjs
```

W pliku: *.couchapprc* dodamy atrybut "default":

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
Po tej zmianie, oba polecenia robią to samo:

```sh
erica push commonjs
erica push
```

Zamieniamy wygenerowaną nazwę dokumentu design z
`_design/commonjs`. W tym celu podmieniamy
zawartość pliku *_id* na:

```
_design/default
```

Według mnie daje to czytelniejsze adresy URL.

Dodamy jeszcze cztery dokumenty, *{1,2,3,4}.json* do katalogu `_docs/`:

```json
{"_id":"1","quote":"Mężczyźni wolą kobiety ładne niż mądre…","tags":["ludzie","kobiety","mężczyźni"]}
{"_id":"2","quote":"Podrzuć własne marzenia swoim wrogom….","tags":["ludzie","myślenie","marzenia"]}
{"_id":"3","quote":"By dojść do źródła, trzeba płynąć pod prąd.","tags":["źródło"]}
{"_id":"4","quote":"Chociaż krowie dasz kakao, nie wydoisz czekolady.","tags":["krowa","doić"]}
```

tak aby można było testować funkcje show, list i widoki.

Na tym kończymy konfigurację. Pozostała wrzucić aplikację na CouchDB:

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


### [Szablony Mustache.js](https://github.com/janl/mustache.js)

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

Sprawdzamy, czy szablon i skompilowany szablon zwracają napis:

```
'Joe spends 6'
```

Jeśli coś nie działa, sprawdzamy logi CouchDB.

Jeśli wszystko jest OK, to kopiujemy plik *mustache.js*
do katalogu *lib/*:

```
cp .../mustache.js lib/mustache.js
```

### szablon.html.mustache

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

### kompilowane szablony

W funkcji *shows/quotation.js* możemy uzyć skopilowanego szablonu:

```js
function(doc, req) {
  log(doc.quote);

  var Mustache = require('lib/mustache');
  var template = this.templates['quotation.html']; // this == design document
  var compiledTemplate = Mustache.compile(template); // funkcja

  return compiledTemplate(doc);
}
```

Czy kompilacja coś daje? Chyba tak. Co? Dlaczego? Jak to sprawdzić?


### Szablony Handlebars

* [CommonJS Handlebars](http://kan.so/packages/details/handlebars)

Przykład ze strony [wycats/handlebars.js](https://github.com/wycats/handlebars.js/):

```js
var Handlebars = require('./handlebars');

var source = "<p>Hello, my name is {{name}}. I am from {{hometown}}. I have " +
    "{{kids.length}} kids:</p>" +
    "<ul>{{#kids}}<li>{{name}} is {{age}}</li>{{/kids}}</ul>";

var template = Handlebars.compile(source);

var data = { "name": "Alan", "hometown": "Somewhere, TX",
    "kids": [{"name": "Jimmy", "age": "12"}, {"name": "Sally", "age": "4"}]};
var result = template(data);

// <p>Hello, my name is Alan. I am from Somewhere, TX. I have 2 kids:</p>
// <ul><li>Jimmy is 12</li><li>Sally is 4</li></ul>
```


## TODO: Funkcje *list*


<!-- links -->

[commonjs]: <http://wiki.commonjs.org/wiki/Modules/1.1.1> "CommonJS Modules / 1.1.1"
[node modules]: <http://nodejs.org/docs/latest/api/modules.html> "Node.js Modules"
