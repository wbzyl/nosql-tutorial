var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view =  {
  "repo": [{name: "mustache.js"}, {name: "mustache.jquery"}]
}

var view =  {
  "repo": [] // empty array is considered FALSE
}

var template = "{{#repo}}<b>{{name}}</b>{{/repo}}\n" + 
  "{{^repo}}No repos :({{/repo}}\n";

util.puts("---- TEMPLATE");
util.puts(template);

util.puts("--- DATA");
util.puts(util.inspect(view));

var html = Mustache.to_html(template, view);
util.puts("\n---- RENDERED TEMPLATE");
util.puts(html);
