var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  condition: function() {
    // [...your code goes here...]
    return true;
}};

var template = "{{#condition}}\n" +
"I will be visible if condition is true.\n" +
"{{/condition}}"

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("\n---- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
