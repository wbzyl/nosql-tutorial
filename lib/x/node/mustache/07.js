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

var html = Mustache.to_html(template, view);
util.puts(html);
