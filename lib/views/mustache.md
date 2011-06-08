#### {% title "Mustache – wąsate szablony" %}

Przykład pokazujący jak korzystać z szablonów MustacheJS
(oraz jak sprawdzać czy działają jak należy).

Tworzymy plik *hello.js* o następującej zawartości:

    :::javascript
    var Mustache = require('./mustache')
      , util = require('util')
      , fs = require('fs');

    var view = {
      name: "Joe",
      say_hello: function(){ return "hello" }
    };
    var template = fs.readFileSync('./hello.mustache', 'utf-8');

    var html = Mustache.to_html(template, view);

    util.puts(html);

Następnie piszemy szablon *hello.mustache*:

    {{say_hello}}, {{name}}

I sprawdzamy na konsoli jak renderuje się ten szablon:

    node hello.js  # rozszerzenie .js można pominąć


Przeglądamy pozostałe przykłady ze strony [mustache.js](http://blog.couchbase.com/mustache-js):

* {%= link_to "02.js", "/node/mustache/02.js" %}
* {%= link_to "03.js", "/node/mustache/03.js" %}
* {%= link_to "04.js", "/node/mustache/04.js" %}
* {%= link_to "05.js", "/node/mustache/05.js" %}
* {%= link_to "06.mustache", "/node/mustache/06.ms" %}, {%= link_to "06.js", "/node/mustache/06.js" %}
* {%= link_to "07.js", "/node/mustache/07.js" %}
* {%= link_to "08.js", "/node/mustache/08.js" %} (*partial templates*)
