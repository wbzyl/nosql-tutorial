var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  name: "Włodek’s shopping card",
  items: ["bananas", "apples"]
};

var template = "{{name}}: <ul> {{#items}}<li>{{.}}</li>{{/items}} </ul>"

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("\n---- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
