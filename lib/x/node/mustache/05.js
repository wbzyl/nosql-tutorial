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

var html = Mustache.to_html(template, view);

util.puts(html);
