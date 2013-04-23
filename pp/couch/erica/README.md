# Erica

1\. [CommonJS Modules / 1.1.1] [commonjs]

```sh
erica create-app appid=commonjs
```
Dodajemy cztery dokumenty do katalogu `_docs`:

```sh
erica -v push commonjs
```

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


<!-- links -->

[commonjs]: <http://wiki.commonjs.org/wiki/Modules/1.1.1> "CommonJS Modules / 1.1.1"
[node modules]: <http://nodejs.org/docs/latest/api/modules.html> "Node.js Modules"
