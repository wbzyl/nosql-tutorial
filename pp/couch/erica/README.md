# Erica

1\. [CommonJS Modules / 1.1.1] [commonjs]:

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

2\. CommonJs Modules.

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

<!-- links -->

[commonjs]: <http://wiki.commonjs.org/wiki/Modules/1.1.1> "CommonJS Modules / 1.1.1"
[node modules]: <http://nodejs.org/docs/latest/api/modules.html> "Node.js Modules"
