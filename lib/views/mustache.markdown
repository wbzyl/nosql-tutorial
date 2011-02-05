#### {% title "Mustache – wąsate szablony" %}

Zaczynamy od [przejrzenia prostych przykładów](http://blog.couchone.com/post/622014913/mustache-js).

Przykład pokazujący jak korzystać z szablonów MustacheJS.

Plik *hello.js*:

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

Szablon *hello.mustache*:

    {{say_hello}}, {{name}}

Sprawdzamy jak działa ten szablon:

    node hello.js  # rozszerzenie .js można pominąć


Pozostałe przykłady:

* {%= link_to "01", "/" %}
