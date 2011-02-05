var Mustache = require('./mustache')
  , util = require('util')
  , fs = require('fs');

var view = {
  condition: function() {
    // [...your code goes here...]
    return true;
  }
};

var template = "{{#condition}}\n" +
  "I will be visible if condition is true.\n" +
  "{{/condition}}";

var html = Mustache.to_html(template, view);
util.puts(html);
