var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  name: "Joe", 
  say_hello: function(){ return "hello" }
}

var template = "{{say_hello}}, {{name}}"

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("\n---- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
