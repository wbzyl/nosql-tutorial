var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  name: "Włodek’s shopping card",
  items: ["bananas", "apples"]
};

var template = "{{name}}: <ul> {{#items}}<li>{{.}}</li>{{/items}} </ul>"

var html = Mustache.to_html(template, view);

util.puts(html);
