var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  name: "Tater",
  bolder: function() {
    return function(text, render) {
      return "<b>" + render(text) + '</b>'
    }
  }
};

var template = "{{#bolder}}Hello {{name}}!{{/bolder}}";

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("\n---- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
